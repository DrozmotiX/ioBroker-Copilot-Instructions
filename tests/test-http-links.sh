#!/bin/bash
#
# Test HTTP Links in Templates
# 
# This test ensures that templates use HTTP URLs instead of relative
# markdown links for snippet references, as required when templates
# are used in external repositories.

set -e

# Get the directory of this script and find the root of the repository
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$REPO_ROOT/templates"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Testing HTTP Links in Templates"

EXIT_CODE=0

# Test framework helper
run_test_with_output() {
    local TEST_NAME="$1"
    local EXPECTED_PATTERN="$2"
    local COMMAND="$3"
    
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

# Test framework helper for negative tests (commands that should fail)
run_negative_test() {
    local TEST_NAME="$1"
    local COMMAND="$2"
    
    echo -n "  Testing $TEST_NAME... "
    
    if eval "$COMMAND" 2>/dev/null; then
        echo -e "${RED}❌ FAIL${NC}"
        EXIT_CODE=1
        return 1
    else
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    fi
}

# Test that templates don't contain relative links to snippets
run_negative_test \
    "Templates don't contain relative snippet links" \
    "grep -r '\.\./snippets.*\\.md)' \"$TEMPLATES_DIR\" --include='*.md'"

run_negative_test \
    "Templates don't contain relative yml snippet links" \
    "grep -r '\.\./snippets.*\\.yml)' \"$TEMPLATES_DIR\" --include='*.md'"

# Test that templates contain the expected HTTP URLs for snippets
run_test_with_output \
    "Version check snippet uses HTTP URL" \
    "version-check-command.md" \
    "grep -r 'https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/version-check-command.md' \"$TEMPLATES_DIR\" --include='*.md'"

run_test_with_output \
    "GitHub Action snippet uses HTTP URL" \
    "github-action-version-check.yml" \
    "grep -r 'https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/github-action-version-check.yml' \"$TEMPLATES_DIR\" --include='*.md'"

# Test that the HTTP URLs are actually accessible (if network is available)
test_url_accessibility() {
    local url="$1"
    local description="$2"
    
    if curl -s --fail -I "$url" >/dev/null 2>&1; then
        echo -e "  Testing $description URL accessibility... ${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "  Testing $description URL accessibility... ${YELLOW}⚠️ SKIP${NC} (network unavailable or URL inaccessible)"
        return 0  # Don't fail tests if network is unavailable
    fi
}

echo ""
echo -e "${YELLOW}🌐 Testing URL Accessibility (network dependent)${NC}"

test_url_accessibility "https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/version-check-command.md" "version check command"
test_url_accessibility "https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/github-action-version-check.yml" "GitHub Action template"

# Summary
echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}✅ All HTTP link tests passed!${NC}"
else
    echo -e "${RED}❌ Some HTTP link tests failed. Please review the output above.${NC}"
fi

exit $EXIT_CODE