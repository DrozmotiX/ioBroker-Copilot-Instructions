#!/bin/bash
#
# Test suite for centralized automation setup functionality
# Tests the new centralized GitHub Action and configuration setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

#!/bin/bash
#
# Test suite for centralized automation setup functionality
# Tests the new centralized GitHub Action and configuration setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Simple test utilities (avoiding full test-runner.sh)
run_test_with_output() {
    local test_name="$1"
    local command="$2"
    local expected_pattern="$3"
    
    printf "  Testing %s... " "$test_name"
    
    if eval "$command" 2>/dev/null | grep -q "$expected_pattern"; then
        echo "✅ PASS"
        return 0
    else
        echo "❌ FAIL"
        return 1
    fi
}

echo "Testing Centralized Automation Setup"

# Test centralized GitHub Action template exists and has correct structure
run_test_with_output "Centralized GitHub Action template exists" \
    "ls -la '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "centralized-version-check-action.yml"

run_test_with_output "Centralized action uses metadata.json for version" \
    "grep -i 'metadata.json' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "metadata.json"

run_test_with_output "Centralized action has dynamic version detection" \
    "grep -i 'dynamic.*version' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "dynamic"

run_test_with_output "Centralized action prevents duplicate issues" \
    "grep -i 'existing.*issue\|duplicate' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "existing"

run_test_with_output "Centralized action has Copilot-driven automation" \
    "grep -i 'copilot.*driven\|copilot.*intelligence' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "Copilot"

# Test automation setup configuration file
run_test_with_output "Automation setup config exists" \
    "ls -la '$REPO_ROOT/config/automation-setup.yml'" \
    "automation-setup.yml"

run_test_with_output "Config has repository detection logic" \
    "grep -A5 -B5 'repository_detection' '$REPO_ROOT/config/automation-setup.yml'" \
    "repository_detection"

run_test_with_output "Config has copilot status checking" \
    "grep -A5 -B5 'copilot_status_check' '$REPO_ROOT/config/automation-setup.yml'" \
    "copilot_status_check"

run_test_with_output "Config has version storage policy" \
    "grep -i 'version.*storage\|store.*copilot' '$REPO_ROOT/config/automation-setup.yml'" \
    "storage"

run_test_with_output "Config prohibits package.json version storage" \
    "grep -i 'NOT.*package.json' '$REPO_ROOT/config/automation-setup.yml'" \
    "NOT.*package.json"

# Test updated initial setup automation template
run_test_with_output "Initial setup uses centralized config" \
    "grep -i 'automation-setup.yml' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "automation-setup.yml"

run_test_with_output "Initial setup mentions Copilot-driven approach" \
    "grep -i 'copilot.*driven\|copilot.*intelligence' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "Copilot"

run_test_with_output "Initial setup avoids manual scripts" \
    "grep -i 'no.*manual.*script\|avoid.*manual\|avoid.*script' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "manual"

run_test_with_output "Initial setup references Discovergy PR as anti-pattern" \
    "grep -i 'discovergy.*286\|DrozmotiX.*discovergy' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "discovergy"

run_test_with_output "Initial setup uses centralized GitHub Action" \
    "grep -i 'centralized.*action\|centralized-version-check-action' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "centralized"

# Test metadata.json updates
run_test_with_output "Metadata includes centralized action component" \
    "grep -A5 'centralized_version_check' '$REPO_ROOT/config/metadata.json'" \
    "centralized_version_check"

run_test_with_output "Metadata includes automation setup config" \
    "grep -A3 'automation_setup' '$REPO_ROOT/config/metadata.json'" \
    "automation_setup"

run_test_with_output "Metadata has automation configuration reference" \
    "grep -i 'configuration_file\|automation-setup.yml' '$REPO_ROOT/config/metadata.json'" \
    "automation-setup"

# Test version management requirements
run_test_with_output "Centralized action stores version in copilot instructions" \
    "grep -i 'copilot-instructions.md.*version\|version.*copilot-instructions' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "copilot-instructions"

run_test_with_output "Centralized action avoids package.json version storage" \
    "grep -i 'NOT.*package.json\|not.*package.json' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "package.json"

# Test template structure and validation
run_test_with_output "Centralized action has workflow permissions" \
    "grep -A5 'permissions:' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "issues.*write"

run_test_with_output "Centralized action has schedule and manual trigger" \
    "grep -A10 'on:' '$REPO_ROOT/templates/centralized-version-check-action.yml' | grep -E 'schedule|workflow_dispatch'" \
    "schedule"

# Test issue creation logic
run_test_with_output "Centralized action creates setup issues for uninitialized repos" \
    "grep -A10 -B5 'Setup.*Copilot.*Instructions' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "Setup.*Copilot"

run_test_with_output "Centralized action creates update issues for outdated repos" \
    "grep -A10 -B5 'Update.*Copilot.*Instructions' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "Update.*Copilot"

# Test preservation requirements
run_test_with_output "Centralized action emphasizes custom section preservation" \
    "grep -i 'customization\|preserve.*custom' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "customization"

run_test_with_output "Centralized action prevents duplicate content" \
    "grep -i 'duplicate.*content\|remove.*duplicate' '$REPO_ROOT/templates/centralized-version-check-action.yml'" \
    "duplicate"

# Test integration with existing system
run_test_with_output "Config references centralized action template" \
    "grep -i 'centralized-version-check-action.yml' '$REPO_ROOT/config/automation-setup.yml'" \
    "centralized-version-check-action"

run_test_with_output "Config has success criteria validation" \
    "grep -A10 'success_criteria' '$REPO_ROOT/config/automation-setup.yml'" \
    "success_criteria"

run_test_with_output "Config has testing steps defined" \
    "grep -A10 'testing_steps' '$REPO_ROOT/config/automation-setup.yml'" \
    "testing_steps"

# Test anti-pattern avoidance
run_test_with_output "Initial setup explicitly mentions avoiding manual validation" \
    "grep -C3 -i 'no.*manual.*script\|avoid.*script' '$REPO_ROOT/templates/initial-setup-automation.md'" \
    "manual.*script"

run_test_with_output "Config promotes Copilot intelligence over scripts" \
    "grep -i 'copilot.*driven' '$REPO_ROOT/config/automation-setup.yml'" \
    "driven"

echo ""
echo "All centralized automation setup tests completed!"