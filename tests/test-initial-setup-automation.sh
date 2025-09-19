#!/bin/bash

# Test script for automated setup templates
# Tests the new initial-setup-automation.md and related templates

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

echo -e "${BLUE}Testing Automated Setup Templates${NC}"

# Test helper function
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

# Test file existence
run_test_with_output "Initial setup automation template exists" \
    "ls '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "initial-setup-automation.md"

run_test_with_output "Weekly version check action exists" \
    "ls '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "weekly-version-check-action.yml"

# Test template content requirements
run_test_with_output "Initial setup template validates existing Copilot setup" \
    "grep -i 'Copilot Status Check' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Copilot Status Check"

run_test_with_output "Initial setup template handles missing instructions" \
    "grep -i 'If Copilot Instructions DON.*T Exist' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "If Copilot Instructions DON"

run_test_with_output "Initial setup template handles existing instructions" \
    "grep -i 'If Copilot Instructions DO Exist' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "If Copilot Instructions DO Exist"

run_test_with_output "Initial setup template includes GitHub Action setup" \
    "grep -i 'Create GitHub Action for Weekly Monitoring' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Create GitHub Action for Weekly Monitoring"

run_test_with_output "Initial setup template includes automation setup" \
    "grep -i 'check-copilot-template.yml' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "check-copilot-template.yml"

# Test GitHub Action content
run_test_with_output "GitHub Action has weekly schedule" \
    "grep -i 'cron.*0 0 \* \* 0' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "cron"

run_test_with_output "GitHub Action has manual trigger" \
    "grep -i 'workflow_dispatch' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "workflow_dispatch"

run_test_with_output "GitHub Action checks for existing issues" \
    "grep -i 'check-issue' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "check-issue"

run_test_with_output "GitHub Action creates issues automatically" \
    "grep -i 'Create.*issue' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "Create"

run_test_with_output "GitHub Action prevents duplicate issues" \
    "grep -i 'existing.*issue' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "existing"

# Test integration requirements  
run_test_with_output "Initial setup template includes validation steps" \
    "grep -i 'Validation and Testing' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Validation and Testing"

run_test_with_output "Initial setup template includes success criteria" \
    "grep -i 'Critical Success Criteria' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Critical Success Criteria"

run_test_with_output "Initial setup template references preservation" \
    "grep -i 'preserve.*CUSTOMIZE.*sections' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "CUSTOMIZE.*sections"

run_test_with_output "Initial setup template includes template source reference" \
    "grep -i 'Template.*Source.*github' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Template.*Source"

# Test documentation updates
run_test_with_output "Setup.md references initial setup automation" \
    "grep -i 'initial-setup-automation.md' '$REPO_ROOT/docs/setup.md'" \
    "initial-setup-automation"

run_test_with_output "Setup.md emphasizes automation over manual steps" \
    "grep -i 'Fully Automated Process' '$REPO_ROOT/docs/setup.md'" \
    "Fully Automated Process"

run_test_with_output "README.md mentions automated setup" \
    "grep -i 'Fully Automated Setup' '$REPO_ROOT/README.md'" \
    "Fully Automated Setup"

run_test_with_output "Templates README documents new templates" \
    "grep -i 'initial-setup-automation.md' '$REPO_ROOT/templates/README.md'" \
    "initial-setup-automation"

# Test automation completeness
run_test_with_output "Initial setup handles both new and existing repositories" \
    "grep -i 'If Copilot Instructions.*Exist' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "If Copilot Instructions"

run_test_with_output "GitHub Action handles both setup and updates" \
    "grep -i 'Setup ioBroker.*Copilot.*Instructions\|Update.*Copilot.*Instructions.*Template' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "Setup.*Copilot"

# Test issue requirements adherence  
run_test_with_output "Template validates if Copilot is setup (requirement 1)" \
    "grep -i 'Verify if GitHub Copilot is active' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Verify if GitHub Copilot is active"

run_test_with_output "Template initiates copilot instructions automatically (requirement 2)" \
    "grep -i 'create.*complete.*copilot-instructions.md' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "copilot-instructions.md"

run_test_with_output "Template includes GitHub Action for weekly checks (requirement 3a)" \
    "grep -i 'Weekly.*check' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "Weekly"

run_test_with_output "Template prevents duplicate issues (requirement 3b)" \
    "grep -i 'existing.*issue' '$REPO_ROOT/templates/weekly-version-check-action.yml'" \
    "existing.*issue"

# Test removal of manual references (requirement 4)
run_test_with_output "Setup.md emphasizes automation over manual" \
    "grep -c -i 'curl.*sed.*manual' '$REPO_ROOT/docs/setup.md'" \
    "0"

run_test_with_output "README.md emphasizes zero manual steps" \
    "grep -i 'Zero Manual Steps' '$REPO_ROOT/README.md'" \
    "Zero Manual Steps"

echo -e "\n${GREEN}All automated setup template tests passed!${NC}"