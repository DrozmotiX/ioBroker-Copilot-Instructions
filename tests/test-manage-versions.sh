#!/bin/bash
#
# Tests for manage-versions.sh script
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

echo -e "${BLUE}Testing manage-versions.sh${NC}"

# Test show command
run_test_with_output \
    "Show command displays version status" \
    "$REPO_ROOT/scripts/manage-versions.sh show" \
    "📋 Current Version Status"

# Test check command with consistent versions
run_test_with_output \
    "Check command validates consistency" \
    "$REPO_ROOT/scripts/manage-versions.sh check" \
    "🔍 Checking Version Consistency"

# Test default command (should be show)
run_test_with_output \
    "Default command shows versions" \
    "$REPO_ROOT/scripts/manage-versions.sh" \
    "📋 Current Version Status"

# Test invalid command
run_test_with_output \
    "Invalid command shows usage" \
    "$REPO_ROOT/scripts/manage-versions.sh invalid-command" \
    "Usage:" \
    1

# Test update command without version
run_test_with_output \
    "Update command without version shows error" \
    "$REPO_ROOT/scripts/manage-versions.sh update" \
    "Please specify a new version" \
    1

# Test update command with invalid version format
run_test_with_output \
    "Update command with invalid version format" \
    "$REPO_ROOT/scripts/manage-versions.sh update invalid.version" \
    "Invalid version format" \
    1

# Test update command with valid version format
run_test_with_output \
    "Update command with valid version format" \
    "cd '$REPO_ROOT' && ./scripts/manage-versions.sh update 0.9.9" \
    "📦 Updating to version 0.9.9"

# Test sync command
run_test_with_output \
    "Sync command updates documentation" \
    "$REPO_ROOT/scripts/manage-versions.sh sync" \
    "🔄 Syncing Documentation"

# Test that version inconsistency is detected
create_version_inconsistency() {
    # Create inconsistency by modifying README
    sed -i 's/Latest Version:\*\* v[0-9]\+\.[0-9]\+\.[0-9]\+/Latest Version:** v9.9.9/' "$REPO_ROOT/README.md"
}

run_test \
    "Create version inconsistency for testing" \
    "$(declare -f create_version_inconsistency); create_version_inconsistency"

run_test_with_output \
    "Check command detects inconsistency" \
    "$REPO_ROOT/scripts/manage-versions.sh check" \
    "Version mismatch" \
    1

# Test package.json versioning functionality
run_test_with_output \
    "Show command displays package.json version" \
    "$TEST_DIR/scripts/manage-versions.sh show" \
    "📦 Package.json version"

# Test package.json consistency checking
create_package_inconsistency() {
    # Create inconsistency by modifying package.json version
    if [[ -f "$TEST_DIR/package.json" ]]; then
        sed -i 's/"version": "[^"]*"/"version": "9.8.7"/' "$TEST_DIR/package.json"
    fi
}

run_test \
    "Create package.json inconsistency for testing" \
    "$(declare -f create_package_inconsistency); create_package_inconsistency"

run_test_with_output \
    "Check command detects package.json inconsistency" \
    "$TEST_DIR/scripts/manage-versions.sh check" \
    "Template.*vs.*Package.json" \
    1

# Test package.json is updated during version update
run_test_with_output \
    "Update command updates package.json version" \
    "cd '$TEST_DIR' && ./scripts/manage-versions.sh update 0.8.8" \
    "✅ Updated package.json"

# Verify package.json version was actually changed
run_test_with_output \
    "Package.json version was actually updated" \
    "grep '\"version\":' '$TEST_DIR/package.json'" \
    "0.8.8"

# Test script dependencies exist
dependencies=("extract-version.sh" "update-versions.sh")
for dep in "${dependencies[@]}"; do
    if [[ -f "$REPO_ROOT/scripts/$dep" ]]; then
        print_test_result "Dependency $dep exists" "PASS"
    else
        print_test_result "Dependency $dep exists" "FAIL" "Missing dependency: $dep"
    fi
done

# Test script is executable
if [[ -x "$REPO_ROOT/scripts/manage-versions.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi