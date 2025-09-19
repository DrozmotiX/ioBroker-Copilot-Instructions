#!/bin/bash
#
# Tests for extract-version.sh script
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

# Test extract-version.sh functionality

echo -e "${BLUE}Testing extract-version.sh${NC}"

# Test template version extraction
run_test_with_output \
    "Extract template version" \
    "$REPO_ROOT/scripts/extract-version.sh template" \
    "0.4.0"

# Test current year extraction
run_test_with_output \
    "Extract current year" \
    "$REPO_ROOT/scripts/extract-version.sh current-year" \
    "202"

# Test current month extraction
run_test_with_output \
    "Extract current month" \
    "$REPO_ROOT/scripts/extract-version.sh current-month" \
    "[A-Za-z]"

# Test current date extraction
run_test_with_output \
    "Extract current date" \
    "$REPO_ROOT/scripts/extract-version.sh current-date" \
    "^[A-Za-z]+ [0-9]{4}$"

# Test default parameter (should extract template version)
run_test_with_output \
    "Default parameter extracts template version" \
    "$REPO_ROOT/scripts/extract-version.sh" \
    "^[0-9]+\.[0-9]+\.[0-9]+$"

# Test invalid parameter
run_test_with_output \
    "Invalid parameter shows usage and exits with code 1" \
    "$REPO_ROOT/scripts/extract-version.sh invalid-param" \
    "Usage:" \
    1

# Test with missing template file
run_test \
    "Missing template file returns 'unknown'" \
    "cd '$REPO_ROOT' && mv template.md template.md.bak && ./scripts/extract-version.sh template && mv template.md.bak template.md" \
    0

# Verify the "unknown" output when template is missing
run_test_with_output \
    "Missing template file outputs 'unknown'" \
    "cd '$REPO_ROOT' && mv template.md template.md.bak && ./scripts/extract-version.sh template; mv template.md.bak template.md" \
    "unknown"

# Test script is executable
if [[ -x "$REPO_ROOT/scripts/extract-version.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi