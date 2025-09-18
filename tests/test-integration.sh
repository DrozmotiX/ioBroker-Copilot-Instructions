#!/bin/bash
#
# Integration tests for script interactions and end-to-end workflows
#

echo -e "${BLUE}Testing Script Integration${NC}"

# Test full version update workflow
test_version_update_workflow() {
    cd "$TEST_DIR"
    
    # Store original versions
    local original_template_version=$(grep "^**Version:**" template.md | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
    
    # Update to a test version
    ./scripts/manage-versions.sh update 1.2.3 >/dev/null 2>&1
    
    # Check if all files were updated
    local template_version=$(grep "^**Version:**" template.md | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
    local readme_version=$(grep "Latest Version:" README.md | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
    local copilot_version=$(grep "^**Version:**" .github/copilot-instructions.md | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
    
    # Restore original version
    ./scripts/manage-versions.sh update "$original_template_version" >/dev/null 2>&1
    
    if [[ "$template_version" == "1.2.3" && "$readme_version" == "1.2.3" && "$copilot_version" == "1.2.3" ]]; then
        return 0
    else
        return 1
    fi
}

run_test \
    "Full version update workflow" \
    "$(declare -f test_version_update_workflow); test_version_update_workflow"

# Test consistency check after version update
test_consistency_after_update() {
    cd "$TEST_DIR"
    
    # Store original version
    local original_version=$(./scripts/extract-version.sh template)
    
    # Update version
    ./scripts/manage-versions.sh update 2.3.4 >/dev/null 2>&1
    
    # Check consistency
    local consistency_result=0
    if ./scripts/manage-versions.sh check >/dev/null 2>&1; then
        consistency_result=0
    else
        consistency_result=1
    fi
    
    # Restore original version
    ./scripts/manage-versions.sh update "$original_version" >/dev/null 2>&1
    
    return $consistency_result
}

run_test \
    "Consistency check after version update" \
    "$(declare -f test_consistency_after_update); test_consistency_after_update"

# Test sync functionality restores consistency
test_sync_restores_consistency() {
    cd "$TEST_DIR"
    
    # Create inconsistency by manually editing README
    sed -i 's/Latest Version:\*\* v[0-9]\+\.[0-9]\+\.[0-9]\+/Latest Version:** v9.9.9/' README.md
    
    # Sync should fix it
    ./scripts/manage-versions.sh sync >/dev/null 2>&1
    
    # Check if consistency is restored
    if ./scripts/manage-versions.sh check >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

run_test \
    "Sync restores version consistency" \
    "$(declare -f test_sync_restores_consistency); test_sync_restores_consistency"

# Test all scripts have execute permissions
scripts=("manage-versions.sh" "extract-version.sh" "update-versions.sh" "check-template-version.sh")
for script in "${scripts[@]}"; do
    if [[ -x "$TEST_DIR/scripts/$script" ]]; then
        print_test_result "Script $script has execute permission" "PASS"
    else
        print_test_result "Script $script has execute permission" "FAIL" "Script lacks execute permission"
    fi
done

# Test all scripts can be run from any directory
test_script_path_independence() {
    cd "$TEST_DIR"
    
    # Create a subdirectory and test running from there
    mkdir -p test-subdir
    cd test-subdir
    
    local result=0
    if ../scripts/extract-version.sh template >/dev/null 2>&1; then
        result=0
    else
        result=1
    fi
    
    cd ..
    rmdir test-subdir
    return $result
}

run_test \
    "Scripts work from different directories" \
    "$(declare -f test_script_path_independence); test_script_path_independence"

# Test error handling when repository files are missing
test_missing_files_handling() {
    cd "$TEST_DIR"
    
    # Test with missing template - show command should still work (displays warning)
    mv template.md template.md.bak
    
    local result1=0
    if ./scripts/manage-versions.sh show >/dev/null 2>&1; then
        result1=0  # Show command works even without template (shows error message)
    else
        result1=1
    fi
    
    mv template.md.bak template.md
    
    # Test with missing README - check command should fail (can't check consistency)
    mv README.md README.md.bak
    
    local result2=0
    if ./scripts/manage-versions.sh check >/dev/null 2>&1; then
        result2=1  # Should fail when README is missing
    else
        result2=0  # Expected failure
    fi
    
    mv README.md.bak README.md
    
    # Show should work, check should fail
    if [[ $result1 -eq 0 && $result2 -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

run_test \
    "Error handling with missing repository files" \
    "$(declare -f test_missing_files_handling); test_missing_files_handling"

# Test date synchronization
test_date_synchronization() {
    cd "$TEST_DIR"
    
    # Change README date to something old
    sed -i 's/Last Updated:\*\* [A-Za-z]* [0-9]*/Last Updated:** January 2000/' README.md
    
    # Sync should update the date
    ./scripts/manage-versions.sh sync >/dev/null 2>&1
    
    # Check if date was updated to current
    local current_date=$(./scripts/extract-version.sh current-date)
    if grep -q "Last Updated:\*\* $current_date" README.md; then
        return 0
    else
        return 1
    fi
}

run_test \
    "Date synchronization works" \
    "$(declare -f test_date_synchronization); test_date_synchronization"