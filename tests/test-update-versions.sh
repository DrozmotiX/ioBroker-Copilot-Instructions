#!/bin/bash
#
# Tests for update-versions.sh script
#

echo -e "${BLUE}Testing update-versions.sh${NC}"

# Test successful version update
run_test_with_output \
    "Update versions script runs successfully" \
    "$TEST_DIR/scripts/update-versions.sh" \
    "🔄 Updating documentation versions"

# Test that script updates README with current template version
run_test_with_output \
    "Script extracts template version" \
    "$TEST_DIR/scripts/update-versions.sh" \
    "Template version:"

# Test that script extracts current date
run_test_with_output \
    "Script extracts current date" \
    "$TEST_DIR/scripts/update-versions.sh" \
    "Current date:"

# Test completion message
run_test_with_output \
    "Script shows completion message" \
    "$TEST_DIR/scripts/update-versions.sh" \
    "🏁 Version update complete"

# Test dependency on extract-version.sh
if [[ -f "$TEST_DIR/scripts/extract-version.sh" ]]; then
    print_test_result "Dependency extract-version.sh exists" "PASS"
else
    print_test_result "Dependency extract-version.sh exists" "FAIL" "Missing dependency: extract-version.sh"
fi

# Test with missing extract-version.sh dependency
test_missing_dependency() {
    cd "$TEST_DIR"
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
    cd "$TEST_DIR"
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
if [[ -f "$TEST_DIR/README.md" ]]; then
    print_test_result "README.md exists for updating" "PASS"
else
    print_test_result "README.md exists for updating" "FAIL" "README.md not found"
fi

# Test that no changes are made if already up to date
run_test_with_output \
    "No changes message when already up to date" \
    "cd '$TEST_DIR' && ./scripts/update-versions.sh && ./scripts/update-versions.sh" \
    "No changes needed"

# Test script is executable
if [[ -x "$TEST_DIR/scripts/update-versions.sh" ]]; then
    print_test_result "Script is executable" "PASS"
else
    print_test_result "Script is executable" "FAIL" "Script is not executable"
fi

# Test actual version replacement in README
test_version_replacement() {
    local original_version=$(grep "Latest Version:" "$TEST_DIR/README.md" | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
    
    # Change template version temporarily
    sed -i 's/^\*\*Version:\*\* [0-9\.]*/**Version:** 9.8.7/' "$TEST_DIR/template.md"
    
    # Run update script
    "$TEST_DIR/scripts/update-versions.sh" >/dev/null 2>&1
    
    # Check if README was updated
    local updated_version=$(grep "Latest Version:" "$TEST_DIR/README.md" | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
    
    # Restore original template
    sed -i 's/^\*\*Version:\*\* [0-9\.]*/**Version:** '"$original_version"'/' "$TEST_DIR/template.md"
    
    if [[ "$updated_version" == "9.8.7" ]]; then
        return 0
    else
        return 1
    fi
}

run_test \
    "Version replacement functionality" \
    "$(declare -f test_version_replacement); test_version_replacement"