#!/bin/bash
#
# Test Suite for generate-release-notes.sh
#
# This test suite validates the release notes generation script
# with various version types and scenarios.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
GENERATE_SCRIPT="$REPO_ROOT/scripts/generate-release-notes.sh"
CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function for test output
print_test_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Helper function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    ((TESTS_RUN++))
    echo -e "\n${YELLOW}Test $TESTS_RUN: $test_name${NC}"
    
    local output
    output=$(eval "$test_command" 2>&1)
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]] && echo "$output" | grep -q "$expected_pattern"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "Expected pattern: $expected_pattern"
        echo "Exit code: $exit_code"
        echo "Output:"
        echo "$output"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Helper function to run a test that expects failure
run_test_expect_failure() {
    local test_name="$1"
    local test_command="$2"
    local expected_error_pattern="$3"
    
    ((TESTS_RUN++))
    echo -e "\n${YELLOW}Test $TESTS_RUN: $test_name${NC}"
    
    local output
    output=$(eval "$test_command" 2>&1)
    local exit_code=$?
    
    if [[ $exit_code -ne 0 ]] && echo "$output" | grep -q "$expected_error_pattern"; then
        echo -e "${GREEN}✅ PASSED (correctly failed)${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "Expected to fail with pattern: $expected_error_pattern"
        echo "Exit code: $exit_code"
        echo "Output:"
        echo "$output"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Helper function to run a test with output inspection
run_test_with_output() {
    local test_name="$1"
    local test_command="$2"
    local check_function="$3"
    
    ((TESTS_RUN++))
    echo -e "\n${YELLOW}Test $TESTS_RUN: $test_name${NC}"
    
    local output
    output=$(eval "$test_command" 2>&1)
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]] && $check_function "$output"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "Exit code: $exit_code"
        echo "Output:"
        echo "$output"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Test: Script exists and is executable
test_script_exists() {
    print_test_header "Basic Script Validation Tests"
    
    run_test \
        "Script file exists" \
        "test -f '$GENERATE_SCRIPT'" \
        ""
    
    run_test \
        "Script is executable" \
        "test -x '$GENERATE_SCRIPT'" \
        ""
}

# Test: Error handling for missing parameters
test_error_handling() {
    print_test_header "Error Handling Tests"
    
    run_test_expect_failure \
        "Fails when no version provided" \
        "'$GENERATE_SCRIPT'" \
        "Error: Version parameter required"
    
    run_test_expect_failure \
        "Fails when CHANGELOG.md is missing" \
        "CHANGELOG_FILE_BACKUP='$CHANGELOG_FILE.bak'; mv '$CHANGELOG_FILE' \"\$CHANGELOG_FILE_BACKUP\" 2>/dev/null; '$GENERATE_SCRIPT' 0.5.3; EXIT_CODE=\$?; mv \"\$CHANGELOG_FILE_BACKUP\" '$CHANGELOG_FILE' 2>/dev/null; exit \$EXIT_CODE" \
        "Error: CHANGELOG.md not found"
}

# Test: Patch release generation
test_patch_release() {
    print_test_header "Patch Release Generation Tests"
    
    run_test \
        "Generates patch release notes for 0.5.3" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "🔧 Version 0.5.3 - Patch Release"
    
    run_test \
        "Includes change summary" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "This release includes"
    
    run_test \
        "Includes changelog entries" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "ENHANCED"
    
    run_test \
        "Includes previous version reference" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "[Pp]revious version.*:.*0.5.2"
    
    run_test \
        "Includes full changelog link" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "Full Changelog.*CHANGELOG.md"
}

# Test: Version parsing
test_version_parsing() {
    print_test_header "Version Parsing Tests"
    
    run_test \
        "Handles version with 'v' prefix" \
        "'$GENERATE_SCRIPT' v0.5.3" \
        "Version 0.5.3"
    
    run_test \
        "Handles version without 'v' prefix" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "Version 0.5.3"
}

# Test: Change categorization
check_change_categories() {
    local output="$1"
    
    # Check for emoji indicators
    if echo "$output" | grep -q "🎉.*new feature"; then
        if echo "$output" | grep -q "✨.*enhancement"; then
            if echo "$output" | grep -q "🐛.*bug fix"; then
                return 0
            fi
        fi
    fi
    return 1
}

test_change_categorization() {
    print_test_header "Change Categorization Tests"
    
    run_test_with_output \
        "Categorizes and counts change types" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "check_change_categories"
    
    run_test \
        "Detects NEW features" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "new feature"
    
    run_test \
        "Detects ENHANCED changes" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "enhancement"
    
    run_test \
        "Detects FIXED bugs" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "bug fix"
}

# Test: Output format validation
check_markdown_format() {
    local output="$1"
    
    # Check for proper markdown headers
    if ! echo "$output" | grep -q "^## "; then
        echo "Missing markdown headers"
        return 1
    fi
    
    # Check for horizontal rule
    if ! echo "$output" | grep -q "^---$"; then
        echo "Missing horizontal rule separator"
        return 1
    fi
    
    return 0
}

test_output_format() {
    print_test_header "Output Format Validation Tests"
    
    run_test_with_output \
        "Output is valid markdown" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "check_markdown_format"
    
    run_test \
        "Includes section headers" \
        "'$GENERATE_SCRIPT' 0.5.3" \
        "^### Changes"
}

# Test: Multiple version handling
test_multiple_versions() {
    print_test_header "Multiple Version Tests"
    
    run_test \
        "Generates notes for 0.5.2" \
        "'$GENERATE_SCRIPT' 0.5.2" \
        "Version 0.5.2"
    
    run_test \
        "Generates notes for 0.5.0" \
        "'$GENERATE_SCRIPT' 0.5.0" \
        "Version 0.5.0"
    
    run_test \
        "Detects previous version correctly for 0.5.2" \
        "'$GENERATE_SCRIPT' 0.5.2" \
        "[Pp]revious version.*:.*0.5.0"
}

# Test: Edge cases
test_edge_cases() {
    print_test_header "Edge Case Tests"
    
    # Test with a version that doesn't exist in changelog
    run_test \
        "Handles non-existent version gracefully" \
        "'$GENERATE_SCRIPT' 9.9.9" \
        "No changes documented for this release"
    
    # Test with oldest version in changelog
    run_test \
        "Handles oldest version (no previous version)" \
        "'$GENERATE_SCRIPT' 0.1.0" \
        "Version 0.1.0"
}

# Test: Minor release aggregation (if applicable)
test_minor_release() {
    print_test_header "Minor Release Tests"
    
    # Test a hypothetical 0.6.0 (would aggregate patches from 0.5.x)
    # Since 0.6.0 doesn't exist in changelog, it should handle gracefully
    run_test \
        "Minor release for non-existent version" \
        "'$GENERATE_SCRIPT' 0.6.0" \
        "Version 0.6.0"
}

# Test: Major release aggregation (if applicable) 
test_major_release() {
    print_test_header "Major Release Tests"
    
    # Test a hypothetical 1.0.0 (would aggregate minors from 0.x.x)
    run_test \
        "Major release for non-existent version" \
        "'$GENERATE_SCRIPT' 1.0.0" \
        "Version 1.0.0"
}

# Test: Script independence
test_script_independence() {
    print_test_header "Script Independence Tests"
    
    run_test \
        "Script runs from different working directory" \
        "cd /tmp && '$GENERATE_SCRIPT' 0.5.3" \
        "Version 0.5.3"
}

# Main test execution
main() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Test Suite: generate-release-notes.sh                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    
    # Run all test suites
    test_script_exists
    test_error_handling
    test_patch_release
    test_version_parsing
    test_change_categorization
    test_output_format
    test_multiple_versions
    test_edge_cases
    test_minor_release
    test_major_release
    test_script_independence
    
    # Print summary
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Total tests run: $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}✅ All tests passed!${NC}"
        return 0
    else
        echo -e "\n${RED}❌ Some tests failed!${NC}"
        return 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
    exit $?
fi
