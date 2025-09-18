#!/bin/bash
#
# Tests for manage-versions.sh script
#

echo -e "${BLUE}Testing manage-versions.sh${NC}"

# Test show command
run_test_with_output \
    "Show command displays version status" \
    "$TEST_DIR/scripts/manage-versions.sh show" \
    "📋 Current Version Status"

# Test check command with consistent versions
run_test_with_output \
    "Check command validates consistency" \
    "$TEST_DIR/scripts/manage-versions.sh check" \
    "🔍 Checking Version Consistency"

# Test default command (should be show)
run_test_with_output \
    "Default command shows versions" \
    "$TEST_DIR/scripts/manage-versions.sh" \
    "📋 Current Version Status"

# Test invalid command
run_test_with_output \
    "Invalid command shows usage" \
    "$TEST_DIR/scripts/manage-versions.sh invalid-command" \
    "Usage:" \
    1

# Test update command without version
run_test_with_output \
    "Update command without version shows error" \
    "$TEST_DIR/scripts/manage-versions.sh update" \
    "Please specify a new version" \
    1

# Test update command with invalid version format
run_test_with_output \
    "Update command with invalid version format" \
    "$TEST_DIR/scripts/manage-versions.sh update invalid.version" \
    "Invalid version format" \
    1

# Test update command with valid version format
run_test_with_output \
    "Update command with valid version format" \
    "cd '$TEST_DIR' && ./scripts/manage-versions.sh update 0.9.9" \
    "📦 Updating to version 0.9.9"

# Test sync command
run_test_with_output \
    "Sync command updates documentation" \
    "$TEST_DIR/scripts/manage-versions.sh sync" \
    "🔄 Syncing Documentation"

# Test that version inconsistency is detected
create_version_inconsistency() {
    # Create inconsistency by modifying README
    sed -i 's/Latest Version:\*\* v[0-9]\+\.[0-9]\+\.[0-9]\+/Latest Version:** v9.9.9/' "$TEST_DIR/README.md"
}

run_test \
    "Create version inconsistency for testing" \
    "$(declare -f create_version_inconsistency); create_version_inconsistency"

run_test_with_output \
    "Check command detects inconsistency" \
    "$TEST_DIR/scripts/manage-versions.sh check" \
    "Version mismatch" \
    1

# Test script dependencies exist
dependencies=("extract-version.sh" "update-versions.sh")
for dep in "${dependencies[@]}"; do
    if [[ -f "$TEST_DIR/scripts/$dep" ]]; then
        print_test_result "Dependency $dep exists" "PASS"
    else
        print_test_result "Dependency $dep exists" "FAIL" "Missing dependency: $dep"
    fi
done

# Test script is executable
if [[ -x "$TEST_DIR/scripts/manage-versions.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi