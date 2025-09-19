#!/bin/bash
#
# Tests for check-template-version.sh script
#

set -e

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Test helper functions
run_test_with_output() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    printf "  Testing %s... " "$test_name"
    
    if eval "$test_command" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        return 1
    fi
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    printf "  Testing %s... " "$test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        return 1
    fi
}

print_test_result() {
    local test_name="$1"
    local result="$2"
    
    if [[ "$result" == "PASS" ]]; then
        echo -e "  ${GREEN}✅ PASS${NC} $test_name"
    else
        echo -e "  ${RED}❌ FAIL${NC} $test_name"
    fi
}

echo -e "${BLUE}Testing check-template-version.sh${NC}"

# Test successful version check with existing template
run_test_with_output \
    "Check template version runs successfully" \
    "$REPO_ROOT/scripts/check-template-version.sh" \
    "🔍 Checking ioBroker Copilot template version"

# Test version extraction from local template
run_test_with_output \
    "Local version extraction works" \
    "$REPO_ROOT/scripts/check-template-version.sh" \
    "📄 Local template version:"

# Test remote version check (may fail in CI due to network)
run_test_with_output \
    "Remote version check attempts" \
    "$REPO_ROOT/scripts/check-template-version.sh" \
    "🌐 Checking remote template version"

# Test completion message
run_test_with_output \
    "Check completion message" \
    "$REPO_ROOT/scripts/check-template-version.sh" \
    "🏁 Template check complete"

# Test missing local template handling
test_missing_template() {
    cd "$REPO_ROOT"
    mv .github/copilot-instructions.md .github/copilot-instructions.md.bak 2>/dev/null || true
    local result=0
    
    if ./scripts/check-template-version.sh 2>&1 | grep -q "❌ Local template not found"; then
        result=0
    else
        result=1
    fi
    
    mv .github/copilot-instructions.md.bak .github/copilot-instructions.md 2>/dev/null || true
    return $result
}

run_test \
    "Missing local template error handling" \
    "$(declare -f test_missing_template); test_missing_template"

# Test template without version (malformed)
test_malformed_template() {
    cd "$REPO_ROOT"
    
    # Backup original and create malformed version
    cp .github/copilot-instructions.md .github/copilot-instructions.md.bak
    sed -i '/Version:/d' .github/copilot-instructions.md
    
    local result=0
    if ./scripts/check-template-version.sh 2>&1 | grep -q "Could not detect version"; then
        result=0
    else
        result=1
    fi
    
    # Restore original
    mv .github/copilot-instructions.md.bak .github/copilot-instructions.md
    return $result
}

run_test \
    "Malformed template version handling" \
    "$(declare -f test_malformed_template); test_malformed_template"

# Test URL configuration
local_template_path="$REPO_ROOT/.github/copilot-instructions.md"
if [[ -f "$local_template_path" ]]; then
    print_test_result "Local template file exists" "PASS"
else
    print_test_result "Local template file exists" "FAIL" "Local template not found at expected path"
fi

# Test script contains correct remote URL
if grep -q "https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md" "$REPO_ROOT/scripts/check-template-version.sh"; then
    print_test_result "Correct remote URL configured" "PASS"
else
    print_test_result "Correct remote URL configured" "FAIL" "Remote URL not found or incorrect"
fi

# Test script is executable
if [[ -x "$REPO_ROOT/scripts/check-template-version.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi

# Test curl command handling (simulate network failure)
test_network_failure() {
    cd "$REPO_ROOT"
    
    # Create a modified script with invalid URL to simulate network failure
    cp scripts/check-template-version.sh scripts/check-template-version-test.sh
    sed -i 's|https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md|http://invalid-url-for-testing.invalid|g' scripts/check-template-version-test.sh
    chmod +x scripts/check-template-version-test.sh
    
    local result=0
    if ./scripts/check-template-version-test.sh 2>&1 | grep -q "Could not fetch remote version"; then
        result=0
    else
        result=1
    fi
    
    rm -f scripts/check-template-version-test.sh
    return $result
}

run_test \
    "Network failure handling" \
    "$(declare -f test_network_failure); test_network_failure"

# Test update guidance is provided for outdated templates
test_update_guidance() {
    cd "$REPO_ROOT"
    
    # Backup original and create outdated version
    cp .github/copilot-instructions.md .github/copilot-instructions.md.bak
    sed -i 's/\*\*Version:\*\* [0-9\.]*/**Version:** 0.1.0/' .github/copilot-instructions.md
    
    local result=0
    # Note: This test may pass even if network is unavailable, because it tests local vs remote comparison
    if ./scripts/check-template-version.sh 2>&1 | grep -q "💡 To update your template"; then
        result=0
    else
        # If network failed, we might see network error instead
        if ./scripts/check-template-version.sh 2>&1 | grep -q "Could not fetch remote version"; then
            result=0  # Network failure is acceptable for this test
        else
            result=1
        fi
    fi
    
    # Restore original
    mv .github/copilot-instructions.md.bak .github/copilot-instructions.md
    return $result
}

run_test \
    "Update guidance for outdated templates" \
    "$(declare -f test_update_guidance); test_update_guidance"