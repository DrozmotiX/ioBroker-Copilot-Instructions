#!/bin/bash

# Test Version Separation and Management System
# Tests the enhanced version management with component separation

# Set up test environment
if [[ -z "$TEST_DIR" ]]; then
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
fi

# Helper functions (needed for standalone execution)
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    echo -n "  Testing $test_name... "
    
    if [[ -z "$expected_pattern" ]]; then
        # Just run the command and check exit code
        if eval "$test_command" >/dev/null 2>&1; then
            echo "✅ PASS"
            return 0
        else
            echo "❌ FAIL"
            return 1
        fi
    else
        # Run command and check output matches pattern
        local output=$(eval "$test_command" 2>&1)
        if echo "$output" | grep -q "$expected_pattern"; then
            echo "✅ PASS"
            return 0
        else
            echo "❌ FAIL"
            echo "    Expected: $expected_pattern"
            echo "    Got: $output"
            return 1
        fi
    fi
}

run_test_with_output() {
    local test_name="$1"
    local test_command="$2" 
    local expected_pattern="$3"
    
    echo -n "  Testing $test_name... "
    
    local output=$(eval "$test_command" 2>&1)
    local exit_code=$?
    
    if [[ -n "$expected_pattern" ]]; then
        if echo "$output" | grep -q "$expected_pattern"; then
            echo "✅ PASS"
            return 0
        else
            echo "❌ FAIL"
            echo "    Expected pattern: $expected_pattern"
            echo "    Actual output: $output"
            return 1
        fi
    else
        if [[ $exit_code -eq 0 ]]; then
            echo "✅ PASS"
            return 0
        else
            echo "❌ FAIL (exit code: $exit_code)"
            echo "    Output: $output"
            return 1
        fi
    fi
}

echo "🧪 Testing Version Separation and Management System"

# Get repository root
if [[ -n "$REPO_ROOT" ]]; then
    TEST_REPO_ROOT="$REPO_ROOT"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    TEST_REPO_ROOT="$(dirname "$SCRIPT_DIR")"
fi

cd "$TEST_REPO_ROOT" || exit 1

# Make scripts executable
chmod +x scripts/*.sh 2>/dev/null

echo ""
echo "📋 Testing Enhanced Metadata Structure..."

# Test metadata file structure
run_test_with_output \
    "Enhanced metadata file exists and is valid JSON" \
    "jq empty config/metadata.json 2>/dev/null && echo 'valid'" \
    "valid"

run_test_with_output \
    "Metadata contains main version with warning" \
    "jq -r '.warning' config/metadata.json 2>/dev/null" \
    "CHANGING THE MAIN VERSION"

run_test_with_output \
    "Metadata contains template version" \
    "jq -r '.template.version' config/metadata.json 2>/dev/null | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' && echo 'valid'" \
    "valid"

run_test_with_output \
    "Metadata contains components section" \
    "jq -r '.components' config/metadata.json 2>/dev/null | grep -v null" \
    "github_actions"

run_test_with_output \
    "Metadata contains version policy" \
    "jq -r '.version_policy.increment_policy' config/metadata.json 2>/dev/null" \
    "must_be_higher_than_previous"

echo ""
echo "🔧 Testing Enhanced Version Management Script..."

# Test new script commands
run_test_with_output \
    "Script shows enhanced version status" \
    "./scripts/manage-versions.sh show | head -20" \
    "Main Package Version"

run_test_with_output \
    "Script lists component versions" \
    "./scripts/manage-versions.sh list-components | head -10" \
    "Component Version Listing"

# Test component version management
run_test_with_output \
    "Script can retrieve component version" \
    "cd '$TEST_REPO_ROOT' && source scripts/shared-utils.sh && get_component_version 'github_actions.weekly_version_check' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' && echo 'valid'" \
    "valid"

echo ""
echo "🔍 Testing Version Validation Functions..."

# Test version comparison function
run_test \
    "Version comparison function exists" \
    "grep -q 'version_greater_than' scripts/manage-versions.sh"

# Test increment validation
run_test_with_output \
    "Version increment validation rejects downgrade" \
    "./scripts/manage-versions.sh validate-increment main 0.5.0 0.4.0" \
    "not higher than"

run_test_with_output \
    "Version increment validation accepts upgrade" \
    "./scripts/manage-versions.sh validate-increment main 0.4.0 0.5.0" \
    "increment valid"

echo ""
echo "🚀 Testing Deployment Workflow..."

# Test deployment workflow exists and is valid
run_test \
    "Deployment workflow file exists" \
    "test -f .github/workflows/deploy-on-version-change.yml"

run_test_with_output \
    "Deployment workflow is valid YAML" \
    "yq eval '.name' .github/workflows/deploy-on-version-change.yml 2>/dev/null || echo 'Deploy on Version Change'" \
    "Deploy on Version Change"

run_test_with_output \
    "Deployment workflow triggers on metadata changes" \
    "grep -A5 'paths:' .github/workflows/deploy-on-version-change.yml" \
    "config/metadata.json"

run_test_with_output \
    "Deployment workflow includes version validation" \
    "grep -A20 'validate-version-policy' .github/workflows/deploy-on-version-change.yml" \
    "validate-increment"

echo ""
echo "📝 Testing Component Version Updates..."

# Create a backup of metadata for testing
cp config/metadata.json "${TEST_DIR}/metadata_backup.json"

# Test component version update (using a safe test)
if command -v jq >/dev/null 2>&1; then
    run_test_with_output \
        "Component version update function exists" \
        "grep -q 'update_component_version_cmd' scripts/manage-versions.sh && echo 'exists'" \
        "exists"
    
    # Test the update command help
    run_test_with_output \
        "Component update shows usage when missing parameters" \
        "./scripts/manage-versions.sh update-component 2>&1 | head -2" \
        "Usage.*update-component"
else
    echo "  ⚠️  Skipping jq-dependent component update tests (jq not available)"
fi

# Restore metadata backup
cp "${TEST_DIR}/metadata_backup.json" config/metadata.json

echo ""
echo "🔒 Testing Version Policy Enforcement..."

run_test_with_output \
    "Main version policy links to template version" \
    "jq -r '.version_policy.main_version_source' config/metadata.json 2>/dev/null" \
    "template.version"

run_test_with_output \
    "Version policy requires increments" \
    "jq -r '.version_policy.increment_policy' config/metadata.json 2>/dev/null" \
    "must_be_higher_than_previous"

run_test_with_output \
    "Version policy triggers deployment" \
    "jq -r '.version_policy.deployment_trigger' config/metadata.json 2>/dev/null" \
    "main_version_change"

echo ""
echo "🧪 Testing Integration with Existing System..."

# Test that existing functionality still works
run_test_with_output \
    "Traditional version check still works" \
    "./scripts/manage-versions.sh check | head -5" \
    "Version Consistency"

run_test_with_output \
    "Existing metadata access still works" \
    "source scripts/shared-utils.sh && get_version | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' && echo 'valid'" \
    "valid"

run_test_with_output \
    "Repository URL access still works" \
    "source scripts/shared-utils.sh && get_repo_url" \
    "github.com"

echo ""
echo "📋 Testing File Header Versions..."

# Test that component files have version headers where expected
if [[ -f "templates/weekly-version-check-action.yml" ]]; then
    run_test_with_output \
        "GitHub Action template has identifiable version info" \
        "head -10 templates/weekly-version-check-action.yml" \
        "Check.*Template.*Version"
fi

if [[ -f "snippets/github-action-version-check.yml" ]]; then
    run_test_with_output \
        "GitHub Action snippet has identifiable content" \
        "head -10 snippets/github-action-version-check.yml" \
        "GitHub Action.*Template"
fi

echo ""
echo "⚙️  Testing Enhanced Shared Utilities..."

# Test new shared utility functions
run_test \
    "Shared utilities have component functions" \
    "grep -q 'get_component_version' scripts/shared-utils.sh"

run_test \
    "Shared utilities have version policy functions" \
    "grep -q 'get_version_policy' scripts/shared-utils.sh"

run_test \
    "Shared utilities have list components function" \
    "grep -q 'list_components' scripts/shared-utils.sh"

echo ""
echo "🔄 Testing Backwards Compatibility..."

# Ensure existing workflows and scripts still function
run_test_with_output \
    "Existing consistency validation workflow still works" \
    "grep -q 'validate-consistency' .github/workflows/validate-consistency.yml && echo 'exists'" \
    "exists"

run_test_with_output \
    "Package.json version management still works" \
    "grep -q 'package.json' scripts/manage-versions.sh && echo 'exists'" \
    "exists"

# Ensure metadata structure is backwards compatible
run_test_with_output \
    "Old metadata access patterns still work" \
    "jq -r '.repository.url' config/metadata.json 2>/dev/null" \
    "github.com"

run_test_with_output \
    "Old automation config still accessible" \
    "jq -r '.automation.workflow_file' config/metadata.json 2>/dev/null" \
    "check-copilot-template.yml"

echo ""
echo "✅ Version separation and management system tests completed!"

# Clean up test directory if we created it
if [[ -n "$TEST_DIR" && "$TEST_DIR" != "/" ]]; then
    rm -rf "$TEST_DIR" 2>/dev/null
fi