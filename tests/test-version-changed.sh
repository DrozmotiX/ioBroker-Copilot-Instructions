#!/bin/bash
#
# Test to verify that version has been changed in PR
# This test should run FIRST before all other tests
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

# Exit codes
EXIT_CODE=0

echo -e "${BLUE}Testing Version Change Requirement${NC}"
echo "========================================"

# Function to run tests
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    printf "  Testing %s... " "$test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        EXIT_CODE=1
        return 1
    fi
}

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
        EXIT_CODE=1
        return 1
    fi
}

# Check if we're in a PR context (git branch exists)
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Not in a git repository - skipping version change test${NC}"
    exit 0
fi

# Get current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# Skip test if we're on main branch (not a PR)
if [ "$CURRENT_BRANCH" = "main" ]; then
    echo -e "${YELLOW}⚠️  On main branch - skipping version change test${NC}"
    exit 0
fi

# Get the base branch (usually main)
BASE_BRANCH="main"

# Check if base branch exists
if ! git rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
    # Try to fetch it
    if git fetch origin "$BASE_BRANCH:$BASE_BRANCH" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Fetched base branch${NC}"
    else
        echo -e "${YELLOW}⚠️  Cannot fetch base branch - skipping version change test${NC}"
        exit 0
    fi
fi

# Extract current version from package.json
CURRENT_VERSION=$(grep -o '"version": *"[^"]*"' "$REPO_ROOT/package.json" | head -1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*' || echo "")

if [ -z "$CURRENT_VERSION" ]; then
    echo -e "${RED}❌ FAIL: Could not extract current version from package.json${NC}"
    exit 1
fi

# Extract base version from package.json on base branch
BASE_VERSION=$(git show "$BASE_BRANCH:package.json" 2>/dev/null | grep -o '"version": *"[^"]*"' | head -1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*' || echo "")

if [ -z "$BASE_VERSION" ]; then
    echo -e "${YELLOW}⚠️  Could not extract base version - skipping version change test${NC}"
    exit 0
fi

echo ""
echo "Base version (${BASE_BRANCH}): ${BASE_VERSION}"
echo "Current version: ${CURRENT_VERSION}"
echo ""

# Check if version has changed
if [ "$CURRENT_VERSION" = "$BASE_VERSION" ]; then
    echo -e "${RED}❌ FAIL: Version has NOT been changed!${NC}"
    echo ""
    echo "Every PR MUST bump the version following semantic versioning:"
    echo "  - PATCH bump (X.Y.Z+1) for bug fixes, docs, minor improvements"
    echo "  - MINOR bump (X.Y+1.0) for new features"
    echo "  - MAJOR bump (X+1.0.0) for breaking changes"
    echo ""
    echo "To fix this, run:"
    echo "  ./scripts/manage-versions.sh update ${BASE_VERSION%.*}.$((${BASE_VERSION##*.}+1))"
    echo ""
    EXIT_CODE=1
else
    echo -e "${GREEN}✅ PASS: Version has been changed from ${BASE_VERSION} to ${CURRENT_VERSION}${NC}"
    
    # Verify version files are consistent
    run_test "Version consistency check" "$REPO_ROOT/scripts/manage-versions.sh check"
fi

# Exit with appropriate code
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "\n${GREEN}All version change tests passed!${NC}"
else
    echo -e "\n${RED}Version change test failed - Please bump the version!${NC}"
fi

exit $EXIT_CODE
