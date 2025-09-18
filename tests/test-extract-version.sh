#!/bin/bash
#
# Tests for extract-version.sh script
#

# Test extract-version.sh functionality

echo -e "${BLUE}Testing extract-version.sh${NC}"

# Test template version extraction
run_test_with_output \
    "Extract template version" \
    "$TEST_DIR/scripts/extract-version.sh template" \
    "^[0-9]+\.[0-9]+\.[0-9]+$"

# Test current year extraction
run_test_with_output \
    "Extract current year" \
    "$TEST_DIR/scripts/extract-version.sh current-year" \
    "^[0-9]{4}$"

# Test current month extraction
run_test_with_output \
    "Extract current month" \
    "$TEST_DIR/scripts/extract-version.sh current-month" \
    "^[A-Za-z]+$"

# Test current date extraction
run_test_with_output \
    "Extract current date" \
    "$TEST_DIR/scripts/extract-version.sh current-date" \
    "^[A-Za-z]+ [0-9]{4}$"

# Test default parameter (should extract template version)
run_test_with_output \
    "Default parameter extracts template version" \
    "$TEST_DIR/scripts/extract-version.sh" \
    "^[0-9]+\.[0-9]+\.[0-9]+$"

# Test invalid parameter
run_test_with_output \
    "Invalid parameter shows usage and exits with code 1" \
    "$TEST_DIR/scripts/extract-version.sh invalid-param" \
    "Usage:" \
    1

# Test with missing template file
run_test \
    "Missing template file returns 'unknown'" \
    "cd '$TEST_DIR' && mv template.md template.md.bak && ./scripts/extract-version.sh template && mv template.md.bak template.md" \
    0

# Verify the "unknown" output when template is missing
run_test_with_output \
    "Missing template file outputs 'unknown'" \
    "cd '$TEST_DIR' && mv template.md template.md.bak && ./scripts/extract-version.sh template; mv template.md.bak template.md" \
    "unknown"

# Test script is executable
if [[ -x "$TEST_DIR/scripts/extract-version.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi