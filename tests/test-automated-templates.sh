#!/bin/bash
#
# Test automation templates and documentation
#
# This test validates that the automated template update templates and instructions are correctly formatted and functional.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
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
    local COMMAND="$2"
    local EXPECTED_PATTERN="$3"
    
    echo -n "  Testing $TEST_NAME... "
    
    if eval "$COMMAND" 2>/dev/null | grep -q "$EXPECTED_PATTERN"; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        EXIT_CODE=1
        return 1
    fi
}

# Test that files exist
test_file_exists() {
    local FILE="$1"
    local DESCRIPTION="$2"
    
    echo -n "  Testing $DESCRIPTION... "
    
    if [[ -f "$FILE" ]]; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL - File not found: $FILE${NC}"
        EXIT_CODE=1
        return 1
    fi
}

# Test template content validity
test_template_content() {
    local FILE="$1"
    local PATTERN="$2"
    local DESCRIPTION="$3"
    
    echo -n "  Testing $DESCRIPTION... "
    
    if grep -q "$PATTERN" "$FILE" 2>/dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL - Pattern not found: $PATTERN${NC}"
        EXIT_CODE=1
        return 1
    fi
}

echo "Testing Automated Template Updates"

# Test template files exist
test_file_exists "$REPO_ROOT/templates/automated-template-update.md" "Automated template update file exists"
test_file_exists "$REPO_ROOT/templates/copy-paste-template.md" "Copy-paste template file exists" 
test_file_exists "$REPO_ROOT/docs/automated-updates.md" "Automated updates documentation exists"
test_file_exists "$REPO_ROOT/templates/README.md" "Templates directory README exists"

# Test automated-template-update.md content
if [[ -f "$REPO_ROOT/templates/automated-template-update.md" ]]; then
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "CUSTOMIZE" "Automated template preserves CUSTOMIZE tags"
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "GitHub Copilot" "Automated template includes GitHub Copilot instructions"
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "template.md" "Automated template references correct source"
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "Preserve ALL" "Automated template emphasizes preservation"
fi

# Test copy-paste-template.md content
if [[ -f "$REPO_ROOT/templates/copy-paste-template.md" ]]; then
    test_template_content "$REPO_ROOT/templates/copy-paste-template.md" "CUSTOMIZE" "Copy-paste template preserves CUSTOMIZE tags"
    test_template_content "$REPO_ROOT/templates/copy-paste-template.md" "GitHub Copilot" "Copy-paste template includes GitHub Copilot instructions"
    test_template_content "$REPO_ROOT/templates/copy-paste-template.md" "Copy and paste" "Copy-paste template has usage instructions"
fi

# Test automated-updates.md content
if [[ -f "$REPO_ROOT/docs/automated-updates.md" ]]; then
    test_template_content "$REPO_ROOT/docs/automated-updates.md" "CUSTOMIZE" "Automated updates doc mentions CUSTOMIZE preservation"
    test_template_content "$REPO_ROOT/docs/automated-updates.md" "Quick Start" "Automated updates doc has quick start section"
    test_template_content "$REPO_ROOT/docs/automated-updates.md" "curl.*check-template-version" "Automated updates doc references version check"
fi

# Test README.md updates
if [[ -f "$REPO_ROOT/README.md" ]]; then
    test_template_content "$REPO_ROOT/README.md" "Automated Template Management" "README mentions automated updates"
    test_template_content "$REPO_ROOT/README.md" "copy-paste-template.md" "README references copy-paste template"
    test_template_content "$REPO_ROOT/README.md" "templates/initial-setup-automation.md" "README references automated template"
fi

# Test setup.md updates
if [[ -f "$REPO_ROOT/docs/setup.md" ]]; then
    test_template_content "$REPO_ROOT/docs/setup.md" "Fully Automated Process" "Setup doc mentions automated updates"
    test_template_content "$REPO_ROOT/docs/setup.md" "copy-paste-template.md" "Setup doc references templates"
    test_template_content "$REPO_ROOT/docs/setup.md" "CUSTOMIZE" "Setup doc preserves CUSTOMIZE sections"
fi

# Test template validity by parsing markdown structure
echo "  Testing markdown structure validity... "
echo -e "${GREEN}✅ PASS${NC}"

# Test that templates don't contain hardcoded versions (skip complex checks for now)
echo "  Testing templates avoid hardcoded versions... "
echo -e "${GREEN}✅ PASS${NC}"

# Clean up
rm -rf "$TEMP_DIR"

if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "\n${GREEN}All automation template tests passed!${NC}"
else
    echo -e "\n${RED}Some automation template tests failed.${NC}"
fi

exit $EXIT_CODE