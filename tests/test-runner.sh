#!/bin/bash
#
# Test Runner for ioBroker Copilot Instructions Scripts
#
# This script runs all automated tests for the repository scripts.
# It provides a simple testing framework for shell scripts.
#
# Usage: ./tests/test-runner.sh [specific-test-file]

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
FAILED_TEST_DETAILS=()

# Get script directory and repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to print test results
print_test_result() {
    local test_name="$1"
    local result="$2"
    local error_msg="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [[ "$result" == "PASS" ]]; then
        echo -e "  ${GREEN}✅ PASS${NC} $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "  ${RED}❌ FAIL${NC} $test_name"
        if [[ -n "$error_msg" ]]; then
            echo -e "    ${RED}Error: $error_msg${NC}"
        fi
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_TEST_DETAILS+=("$test_name: $error_msg")
    fi
}

# Function to run a test and capture output
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    local output
    local exit_code
    
    # Run command and capture output and exit code
    if output=$(eval "$test_command" 2>&1); then
        exit_code=0
    else
        exit_code=$?
    fi
    
    # Check if exit code matches expected
    if [[ $exit_code -eq $expected_exit_code ]]; then
        print_test_result "$test_name" "PASS"
        return 0
    else
        print_test_result "$test_name" "FAIL" "Expected exit code $expected_exit_code, got $exit_code. Output: $output"
        return 1
    fi
}

# Function to run a test with output validation
run_test_with_output() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    local expected_exit_code="${4:-0}"
    
    local output
    local exit_code
    
    # Run command and capture output and exit code
    if output=$(eval "$test_command" 2>&1); then
        exit_code=0
    else
        exit_code=$?
    fi
    
    # Check exit code and output pattern
    if [[ $exit_code -eq $expected_exit_code ]] && [[ "$output" =~ $expected_pattern ]]; then
        print_test_result "$test_name" "PASS"
        return 0
    else
        local error_msg="Expected exit code $expected_exit_code (got $exit_code) and pattern '$expected_pattern'. Output: $output"
        print_test_result "$test_name" "FAIL" "$error_msg"
        return 1
    fi
}

# Function to create test environment
setup_test_env() {
    # Create temporary directory for test files
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
    
    # Copy original files to test directory for isolated testing
    cp -r "$REPO_ROOT"/* "$TEST_DIR/" 2>/dev/null || true
    
    # Ensure hidden directories are copied (like .github)
    cp -r "$REPO_ROOT"/.* "$TEST_DIR/" 2>/dev/null || true
    
    # Clean up unwanted copied directories
    rm -rf "$TEST_DIR/.git" "$TEST_DIR/." "$TEST_DIR/.." 2>/dev/null || true
    
    echo -e "${BLUE}🧪 Test Environment Setup${NC}"
    echo "Test directory: $TEST_DIR"
}

# Function to cleanup test environment
cleanup_test_env() {
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Function to run specific test file
run_test_file() {
    local test_file="$1"
    if [[ -f "$test_file" ]]; then
        echo -e "${BLUE}📋 Running tests from: $(basename "$test_file")${NC}"
        source "$test_file"
        echo ""
    else
        echo -e "${RED}❌ Test file not found: $test_file${NC}"
        exit 1
    fi
}

# Function to display final summary
display_summary() {
    echo -e "${BLUE}📊 Test Summary${NC}"
    echo "================"
    echo -e "Total tests: $TOTAL_TESTS"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
    echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    
    if [[ $FAILED_TESTS -gt 0 ]]; then
        echo ""
        echo -e "${RED}Failed Test Details:${NC}"
        for detail in "${FAILED_TEST_DETAILS[@]}"; do
            echo -e "  ${RED}•${NC} $detail"
        done
    fi
    
    echo ""
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Some tests failed.${NC}"
        exit 1
    fi
}

# Main execution
main() {
    echo -e "${BLUE}🚀 ioBroker Copilot Instructions - Script Test Suite${NC}"
    echo "==========================================================="
    echo ""
    
    # Setup test environment
    setup_test_env
    
    # Trap to ensure cleanup
    trap cleanup_test_env EXIT
    
    # If specific test file provided, run only that
    if [[ $# -gt 0 ]]; then
        run_test_file "$1"
    else
        # Run all test files
        for test_file in "$SCRIPT_DIR"/test-*.sh; do
            # Skip the test-runner itself to avoid infinite recursion
            if [[ "$(basename "$test_file")" != "test-runner.sh" && -f "$test_file" ]]; then
                run_test_file "$test_file"
            fi
        done
    fi
    
    # Display summary
    display_summary
}

# Run main function with all arguments
main "$@"