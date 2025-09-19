#!/bin/bash
#
# Test centralized metadata and shared utilities
#
# This test validates the centralized metadata system and shared utility functions.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
METADATA_FILE="$REPO_ROOT/config/metadata.json"
SHARED_UTILS="$REPO_ROOT/scripts/shared-utils.sh"
TEMP_DIR=$(mktemp -d)
EXIT_CODE=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test framework helper
run_test_with_output() {
    local TEST_NAME="$1"
    shift
    local EXPECTED_PATTERN="$1"
    shift
    echo -n "  Testing $TEST_NAME... "
    
    if "$@" 2>/dev/null | grep -q "$EXPECTED_PATTERN"; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        EXIT_CODE=1
        return 1
    fi
}

# Test file existence helper
test_file_exists() {
    local FILE="$1"
    local TEST_NAME="$2"
    
    echo -n "  Testing $TEST_NAME... "
    
    if [[ -f "$FILE" ]]; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        echo "    File not found: $FILE"
        EXIT_CODE=1
        return 1
    fi
}

echo -e "${YELLOW}🧪 Testing Centralized Metadata System${NC}"
echo "============================================"

# Test metadata file exists
test_file_exists "$METADATA_FILE" "Metadata file exists"

# Test shared utilities exist
test_file_exists "$SHARED_UTILS" "Shared utilities file exists"

# Test metadata validation
if [[ -f "$METADATA_FILE" ]]; then
    # Test JSON validity
    if command -v jq >/dev/null 2>&1; then
        echo -n "  Testing JSON syntax is valid... "
        if jq empty "$METADATA_FILE" 2>/dev/null; then
            echo -e "${GREEN}✅ PASS${NC}"
        else
            echo -e "${RED}❌ FAIL${NC}"
            EXIT_CODE=1
        fi
    else
        echo "  ⚠️ jq not available, skipping JSON validation"
    fi
    
    # Test required fields exist
    run_test_with_output "Version field exists" "version" grep '"version"' "$METADATA_FILE"
    run_test_with_output "Repository URL exists" "repository" grep '"repository"' "$METADATA_FILE"
    run_test_with_output "Scripts section exists" "scripts" grep '"scripts"' "$METADATA_FILE"
fi

# Test shared utilities functions
if [[ -f "$SHARED_UTILS" ]]; then
    echo ""
    echo -e "${YELLOW}🔧 Testing Shared Utility Functions${NC}"
    
    # Source the utilities in a subshell to test
    (
        source "$SHARED_UTILS"
        
        # Test version retrieval
        VERSION=$(get_version)
        if [[ -n "$VERSION" && "$VERSION" != "null" ]]; then
            echo -e "  Testing get_version function... ${GREEN}✅ PASS${NC} (version: $VERSION)"
        else
            echo -e "  Testing get_version function... ${RED}❌ FAIL${NC}"
            EXIT_CODE=1
        fi
        
        # Test repository URL
        REPO_URL=$(get_repo_url)
        if [[ "$REPO_URL" == *"github.com"* ]]; then
            echo -e "  Testing get_repo_url function... ${GREEN}✅ PASS${NC}"
        else
            echo -e "  Testing get_repo_url function... ${RED}❌ FAIL${NC}"
            EXIT_CODE=1
        fi
        
        # Test raw base URL
        RAW_URL=$(get_raw_base_url)
        if [[ "$RAW_URL" == *"raw.githubusercontent.com"* ]]; then
            echo -e "  Testing get_raw_base_url function... ${GREEN}✅ PASS${NC}"
        else
            echo -e "  Testing get_raw_base_url function... ${RED}❌ FAIL${NC}"
            EXIT_CODE=1
        fi
        
        # Test metadata validation
        if validate_metadata >/dev/null 2>&1; then
            echo -e "  Testing validate_metadata function... ${GREEN}✅ PASS${NC}"
        else
            echo -e "  Testing validate_metadata function... ${RED}❌ FAIL${NC}"
            EXIT_CODE=1
        fi
    )
fi

# Test snippet files exist
echo ""
echo -e "${YELLOW}📄 Testing Snippet Files${NC}"

test_file_exists "$REPO_ROOT/snippets/version-check-command.md" "Version check snippet exists"
test_file_exists "$REPO_ROOT/snippets/github-action-version-check.yml" "GitHub Action snippet exists"
test_file_exists "$REPO_ROOT/snippets/version-management-commands.md" "Version management snippet exists"

# Test snippet content
if [[ -f "$REPO_ROOT/snippets/version-check-command.md" ]]; then
    run_test_with_output "Version check snippet has curl command" "curl" grep 'curl.*check-template-version' "$REPO_ROOT/snippets/version-check-command.md"
fi

if [[ -f "$REPO_ROOT/snippets/github-action-version-check.yml" ]]; then
    run_test_with_output "GitHub Action snippet has workflow name" "name" grep 'name:.*Check.*Template' "$REPO_ROOT/snippets/github-action-version-check.yml"
    run_test_with_output "GitHub Action snippet has cron schedule" "cron" grep 'cron:.*0 0' "$REPO_ROOT/snippets/github-action-version-check.yml"
fi

# Test integration with existing scripts
echo ""
echo -e "${YELLOW}🔗 Testing Script Integration${NC}"

# Test extract-version.sh integration
if [[ -f "$REPO_ROOT/scripts/extract-version.sh" ]]; then
    run_test_with_output "Extract version script sources shared utils" "source" grep 'source.*shared-utils.sh' "$REPO_ROOT/scripts/extract-version.sh"
    
    # Test metadata option
    if source "$SHARED_UTILS" 2>/dev/null; then
        METADATA_VERSION=$("$REPO_ROOT/scripts/extract-version.sh" metadata 2>/dev/null)
        if [[ -n "$METADATA_VERSION" && "$METADATA_VERSION" != "null" ]]; then
            echo -e "  Testing extract metadata version... ${GREEN}✅ PASS${NC}"
        else
            echo -e "  Testing extract metadata version... ${RED}❌ FAIL${NC}"
            EXIT_CODE=1
        fi
    fi
fi

# Test manage-versions.sh integration
if [[ -f "$REPO_ROOT/scripts/manage-versions.sh" ]]; then
    run_test_with_output "Manage versions script sources shared utils" "source" grep 'source.*shared-utils.sh' "$REPO_ROOT/scripts/manage-versions.sh"
    run_test_with_output "Manage versions script references metadata file" "METADATA_FILE" grep 'METADATA_FILE' "$REPO_ROOT/scripts/manage-versions.sh"
fi

# Test documentation references
echo ""
echo -e "${YELLOW}📚 Testing Documentation References${NC}"

# Test that documentation now references snippets instead of duplicating content
run_test_with_output "Maintenance doc references snippet" "snippets" grep 'snippets/github-action-version-check.yml' "$REPO_ROOT/docs/maintenance.md"
run_test_with_output "Testing doc references snippet" "snippets" grep 'snippets/github-action-version-check.yml' "$REPO_ROOT/docs/testing.md"
run_test_with_output "Template references snippet" "snippets" grep 'snippets/' "$REPO_ROOT/templates/automated-template-update.md"

# Clean up
rm -rf "$TEMP_DIR"

# Summary
echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}✅ All centralized metadata tests passed!${NC}"
else
    echo -e "${RED}❌ Some tests failed. Please review the output above.${NC}"
fi

exit $EXIT_CODE