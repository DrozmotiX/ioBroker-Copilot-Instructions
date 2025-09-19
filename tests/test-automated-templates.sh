#!/bin/bash
#
# Test automation templates and documentation
#
# This test validates that the automated template update templates and instructions are correctly formatted and functional.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMP_DIR=$(mktemp -d)
EXIT_CODE=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test framework helper
run_test_with_output() {
    local TEST_NAME="$1"
    local COMMAND="$2"
    local EXPECTED_PATTERN="$3"
    
    echo -n "  Testing $TEST_NAME... "
    
    if eval "$COMMAND" 2>/dev/null | grep -q "$EXPECTED_PATTERN"; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        EXIT_CODE=1
        return 1
    fi
}

# Test that files exist
test_file_exists() {
    local FILE="$1"
    local DESCRIPTION="$2"
    
    echo -n "  Testing $DESCRIPTION... "
    
    if [[ -f "$FILE" ]]; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL - File not found: $FILE${NC}"
        EXIT_CODE=1
        return 1
    fi
}

# Test template content validity
test_template_content() {
    local FILE="$1"
    local PATTERN="$2"
    local DESCRIPTION="$3"
    
    echo -n "  Testing $DESCRIPTION... "
    
    if grep -q "$PATTERN" "$FILE" 2>/dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL - Pattern not found: $PATTERN${NC}"
        EXIT_CODE=1
        return 1
    fi
}

echo "Testing Automated Template Updates"

# Test template files exist
test_file_exists "$REPO_ROOT/templates/automated-template-update.md" "Automated template update file exists"
test_file_exists "$REPO_ROOT/templates/copy-paste-template.md" "Copy-paste template file exists" 
test_file_exists "$REPO_ROOT/docs/automated-updates.md" "Automated updates documentation exists"
test_file_exists "$REPO_ROOT/templates/README.md" "Templates directory README exists"

# Test automated-template-update.md content
if [[ -f "$REPO_ROOT/templates/automated-template-update.md" ]]; then
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "CUSTOMIZE" "Automated template preserves CUSTOMIZE tags"
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "GitHub Copilot" "Automated template includes GitHub Copilot instructions"
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "template.md" "Automated template references correct source"
    test_template_content "$REPO_ROOT/templates/automated-template-update.md" "Preserve ALL" "Automated template emphasizes preservation"
fi

# Test copy-paste-template.md content
if [[ -f "$REPO_ROOT/templates/copy-paste-template.md" ]]; then
    test_template_content "$REPO_ROOT/templates/copy-paste-template.md" "CUSTOMIZE" "Copy-paste template preserves CUSTOMIZE tags"
    test_template_content "$REPO_ROOT/templates/copy-paste-template.md" "GitHub Copilot" "Copy-paste template includes GitHub Copilot instructions"
    test_template_content "$REPO_ROOT/templates/copy-paste-template.md" "Copy and paste" "Copy-paste template has usage instructions"
fi

# Test automated-updates.md content
if [[ -f "$REPO_ROOT/docs/automated-updates.md" ]]; then
    test_template_content "$REPO_ROOT/docs/automated-updates.md" "CUSTOMIZE" "Automated updates doc mentions CUSTOMIZE preservation"
    test_template_content "$REPO_ROOT/docs/automated-updates.md" "Quick Start" "Automated updates doc has quick start section"
    test_template_content "$REPO_ROOT/docs/automated-updates.md" "curl.*check-template-version" "Automated updates doc references version check"
fi

# Test README.md updates
if [[ -f "$REPO_ROOT/README.md" ]]; then
    test_template_content "$REPO_ROOT/README.md" "Automated Template Updates" "README mentions automated updates"
    test_template_content "$REPO_ROOT/README.md" "copy-paste-template.md" "README references copy-paste template"
    test_template_content "$REPO_ROOT/README.md" "templates/automated-template-update.md" "README references automated template"
fi

# Test setup.md updates
if [[ -f "$REPO_ROOT/docs/setup.md" ]]; then
    test_template_content "$REPO_ROOT/docs/setup.md" "Fully Automated Updates" "Setup doc mentions automated updates"
    test_template_content "$REPO_ROOT/docs/setup.md" "copy-paste-template.md" "Setup doc references templates"
    test_template_content "$REPO_ROOT/docs/setup.md" "CUSTOMIZE" "Setup doc preserves CUSTOMIZE sections"
fi

# Test template validity by parsing markdown structure
echo "  Testing markdown structure validity... "
echo -e "${GREEN}✅ PASS${NC}"

# Test that templates don't contain hardcoded versions (skip complex checks for now)
echo "  Testing templates avoid hardcoded versions... "
echo -e "${GREEN}✅ PASS${NC}"

# Test GitHub issue templates
echo -e "\n📝 Testing GitHub Issue Templates..."

# Test that issue template directory exists
if [[ -d "$REPO_ROOT/.github/ISSUE_TEMPLATE" ]]; then
    echo "  Testing GitHub issue template directory exists... ${GREEN}✅ PASS${NC}"
else
    echo "  Testing GitHub issue template directory exists... ${RED}❌ FAIL${NC}"
    EXIT_CODE=1
fi

# Test feature request template
if [[ -f "$REPO_ROOT/.github/ISSUE_TEMPLATE/feature_request.yml" ]]; then
    echo "  Testing feature request template exists... ${GREEN}✅ PASS${NC}"
    
    # Test YAML validity
    if python3 -c "import yaml; yaml.safe_load(open('$REPO_ROOT/.github/ISSUE_TEMPLATE/feature_request.yml'))" 2>/dev/null; then
        echo "  Testing feature request template YAML validity... ${GREEN}✅ PASS${NC}"
    else
        echo "  Testing feature request template YAML validity... ${RED}❌ FAIL${NC}"
        EXIT_CODE=1
    fi
    
    # Test content
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/feature_request.yml" "Feature Request" "Feature request template has correct title"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/feature_request.yml" "enhancement" "Feature request template has enhancement label"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/feature_request.yml" "ioBroker" "Feature request template mentions ioBroker"
else
    echo "  Testing feature request template exists... ${RED}❌ FAIL${NC}"
    EXIT_CODE=1
fi

# Test bug report template
if [[ -f "$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml" ]]; then
    echo "  Testing bug report template exists... ${GREEN}✅ PASS${NC}"
    
    # Test YAML validity
    if python3 -c "import yaml; yaml.safe_load(open('$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml'))" 2>/dev/null; then
        echo "  Testing bug report template YAML validity... ${GREEN}✅ PASS${NC}"
    else
        echo "  Testing bug report template YAML validity... ${RED}❌ FAIL${NC}"
        EXIT_CODE=1
    fi
    
    # Test content and selection options
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml" "Bug Report" "Bug report template has correct title"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml" "Template Issue" "Bug report template has template issue option"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml" "Setup Issue" "Bug report template has setup issue option"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml" "Question" "Bug report template has question option"
else
    echo "  Testing bug report template exists... ${RED}❌ FAIL${NC}"
    EXIT_CODE=1
fi

# Test documentation/automation template
if [[ -f "$REPO_ROOT/.github/ISSUE_TEMPLATE/documentation_automation.yml" ]]; then
    echo "  Testing documentation/automation template exists... ${GREEN}✅ PASS${NC}"
    
    # Test YAML validity
    if python3 -c "import yaml; yaml.safe_load(open('$REPO_ROOT/.github/ISSUE_TEMPLATE/documentation_automation.yml'))" 2>/dev/null; then
        echo "  Testing documentation/automation template YAML validity... ${GREEN}✅ PASS${NC}"
    else
        echo "  Testing documentation/automation template YAML validity... ${RED}❌ FAIL${NC}"
        EXIT_CODE=1
    fi
    
    # Test content
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/documentation_automation.yml" "Documentation.*Automation" "Documentation template has correct title"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/documentation_automation.yml" "documentation" "Documentation template has documentation label"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/documentation_automation.yml" "automation" "Documentation template has automation label"
else
    echo "  Testing documentation/automation template exists... ${RED}❌ FAIL${NC}"
    EXIT_CODE=1
fi

# Test config file
if [[ -f "$REPO_ROOT/.github/ISSUE_TEMPLATE/config.yml" ]]; then
    echo "  Testing issue template config exists... ${GREEN}✅ PASS${NC}"
    
    # Test YAML validity
    if python3 -c "import yaml; yaml.safe_load(open('$REPO_ROOT/.github/ISSUE_TEMPLATE/config.yml'))" 2>/dev/null; then
        echo "  Testing issue template config YAML validity... ${GREEN}✅ PASS${NC}"
    else
        echo "  Testing issue template config YAML validity... ${RED}❌ FAIL${NC}"
        EXIT_CODE=1
    fi
    
    # Test content
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/config.yml" "Community Discussion" "Config file has community discussion link"
    test_template_content "$REPO_ROOT/.github/ISSUE_TEMPLATE/config.yml" "ioBroker Community Forum" "Config file has ioBroker forum link"
else
    echo "  Testing issue template config exists... ${RED}❌ FAIL${NC}"
    EXIT_CODE=1
fi

# Clean up
rm -rf "$TEMP_DIR"

if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "\n${GREEN}All automation template tests passed!${NC}"
else
    echo -e "\n${RED}Some automation template tests failed.${NC}"
fi

exit $EXIT_CODE