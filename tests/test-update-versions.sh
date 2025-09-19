#!/bin/bash
#
# Tests for update-versions.sh script
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

echo -e "${BLUE}Testing update-versions.sh${NC}"

# Test successful version update
run_test_with_output \
    "Update versions script runs successfully" \
    "$REPO_ROOT/scripts/update-versions.sh" \
    "🔄 Updating documentation versions"

# Test that script updates README with current template version
run_test_with_output \
    "Script extracts template version" \
    "$REPO_ROOT/scripts/update-versions.sh" \
    "Template version:"

# Test that script extracts current date
run_test_with_output \
    "Script extracts current date" \
    "$REPO_ROOT/scripts/update-versions.sh" \
    "Current date:"

# Test completion message
run_test_with_output \
    "Script shows completion message" \
    "$REPO_ROOT/scripts/update-versions.sh" \
    "🏁 Version update complete"

# Test dependency on extract-version.sh
if [[ -f "$REPO_ROOT/scripts/extract-version.sh" ]]; then
    print_test_result "Dependency extract-version.sh exists" "PASS"
else
    print_test_result "Dependency extract-version.sh exists" "FAIL" "Missing dependency: extract-version.sh"
fi

# Test with missing extract-version.sh dependency
test_missing_dependency() {
    cd "$REPO_ROOT"
    mv scripts/extract-version.sh scripts/extract-version.sh.bak
    
    local exit_code=0
    if ./scripts/update-versions.sh >/dev/null 2>&1; then
        exit_code=0
    else
        exit_code=1
    fi
    
    mv scripts/extract-version.sh.bak scripts/extract-version.sh
    return $exit_code
}

run_test \
    "Missing dependency handling" \
    "$(declare -f test_missing_dependency); test_missing_dependency" \
    1

# Test that script handles missing template gracefully
test_missing_template() {
    cd "$REPO_ROOT"
    mv template.md template.md.bak
    
    local exit_code=0
    if ./scripts/update-versions.sh >/dev/null 2>&1; then
        exit_code=0
    else
        exit_code=1
    fi
    
    mv template.md.bak template.md
    return $exit_code
}

run_test \
    "Missing template file handling" \
    "$(declare -f test_missing_template); test_missing_template" \
    1

# Test README file exists
if [[ -f "$REPO_ROOT/README.md" ]]; then
    print_test_result "README.md exists for updating" "PASS"
else
    print_test_result "README.md exists for updating" "FAIL" "README.md not found"
fi

# Test that no changes are made if already up to date
run_test_with_output \
    "No changes message when already up to date" \
    "cd '$REPO_ROOT' && ./scripts/update-versions.sh && ./scripts/update-versions.sh" \
    "No changes needed"

# Test script is executable
if [[ -x "$REPO_ROOT/scripts/update-versions.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi

# Test actual version replacement in README
test_version_replacement() {
    local original_version=$(grep "Latest Version:" "$REPO_ROOT/README.md" | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
    
    # Change template version temporarily
    sed -i 's/^\*\*Version:\*\* [0-9\.]*/**Version:** 9.8.7/' "$REPO_ROOT/template.md"
    
    # Run update script
    "$REPO_ROOT/scripts/update-versions.sh" >/dev/null 2>&1
    
    # Check if README was updated
    local updated_version=$(grep "Latest Version:" "$REPO_ROOT/README.md" | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
    
    # Restore original template
    sed -i 's/^\*\*Version:\*\* [0-9\.]*/**Version:** '"$original_version"'/' "$REPO_ROOT/template.md"
    
    if [[ "$updated_version" == "9.8.7" ]]; then
        return 0
    else
        return 1
    fi
}

run_test \
    "Version replacement functionality" \
    "$(declare -f test_version_replacement); test_version_replacement"