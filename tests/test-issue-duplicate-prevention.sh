#!/usr/bin/env bash
# Test Suite: Issue Duplicate Prevention
# Tests for preventing duplicate issue creation and closing old issues
# Part of: ioBroker Copilot Instructions Repository Tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
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

# Test files to check
CENTRALIZED_ACTION="$REPO_ROOT/templates/centralized-version-check-action.yml"
WEEKLY_ACTION="$REPO_ROOT/templates/weekly-version-check-action.yml"
AUTOMATED_ACTION="$REPO_ROOT/templates/ghAction-AutomatedVersionCheckAndUpdate.yml"
SNIPPET_ACTION="$REPO_ROOT/snippets/github-action-version-check.yml"

echo "📋 Testing Issue Duplicate Prevention"

# Test 1: Check that workflows filter by creator (github-actions[bot])
run_test_with_output \
    "Centralized action filters issues by creator" \
    "grep -q \"creator: 'github-actions\[bot\]'\" '$CENTRALIZED_ACTION' && echo 'found'" \
    "found"

run_test_with_output \
    "Weekly action filters issues by creator" \
    "grep -q \"creator: 'github-actions\[bot\]'\" '$WEEKLY_ACTION' && echo 'found'" \
    "found"

run_test_with_output \
    "Automated action filters issues by creator" \
    "grep -q \"creator: 'github-actions\[bot\]'\" '$AUTOMATED_ACTION' && echo 'found'" \
    "found"

run_test_with_output \
    "Snippet action filters issues by creator" \
    "grep -q \"creator: 'github-actions\[bot\]'\" '$SNIPPET_ACTION' && echo 'found'" \
    "found"

# Test 2: Check that workflows do NOT filter by labels
run_test_with_output \
    "Centralized action does not filter by labels in listForRepo" \
    "grep -A5 'listForRepo' '$CENTRALIZED_ACTION' | grep -q 'labels:' && echo 'found-labels' || echo 'no-labels'" \
    "no-labels"

run_test_with_output \
    "Weekly action does not filter by labels in listForRepo" \
    "grep -A5 'listForRepo' '$WEEKLY_ACTION' | grep -q 'labels:' && echo 'found-labels' || echo 'no-labels'" \
    "no-labels"

run_test_with_output \
    "Automated action does not filter by labels in listForRepo" \
    "grep -A5 'listForRepo' '$AUTOMATED_ACTION' | grep -q 'labels:' && echo 'found-labels' || echo 'no-labels'" \
    "no-labels"

run_test_with_output \
    "Snippet action does not filter by labels in listForRepo" \
    "grep -A5 'listForRepo' '$SNIPPET_ACTION' | grep -q 'labels:' && echo 'found-labels' || echo 'no-labels'" \
    "no-labels"

# Test 3: Check that workflows close ALL existing issues (use for loop)
run_test_with_output \
    "Centralized action closes all existing issues" \
    "grep -q 'for (const issue of' '$CENTRALIZED_ACTION' && echo 'closes-all'" \
    "closes-all"

run_test_with_output \
    "Weekly action closes all existing issues" \
    "grep -q 'for (const issue of' '$WEEKLY_ACTION' && echo 'closes-all'" \
    "closes-all"

run_test_with_output \
    "Automated action closes all existing issues" \
    "grep -q 'for (const issue of' '$AUTOMATED_ACTION' && echo 'closes-all'" \
    "closes-all"

run_test_with_output \
    "Snippet action closes all existing issues" \
    "grep -q 'for (const issue of' '$SNIPPET_ACTION' && echo 'closes-all'" \
    "closes-all"

# Test 4: Check that workflows add a comment before closing
run_test_with_output \
    "Centralized action adds comment before closing" \
    "grep -q 'createComment' '$CENTRALIZED_ACTION' && echo 'has-comment'" \
    "has-comment"

run_test_with_output \
    "Weekly action adds comment before closing" \
    "grep -q 'createComment' '$WEEKLY_ACTION' && echo 'has-comment'" \
    "has-comment"

run_test_with_output \
    "Automated action adds comment before closing" \
    "grep -q 'createComment' '$AUTOMATED_ACTION' && echo 'has-comment'" \
    "has-comment"

run_test_with_output \
    "Snippet action adds comment before closing" \
    "grep -q 'createComment' '$SNIPPET_ACTION' && echo 'has-comment'" \
    "has-comment"

# Test 5: Check that workflows actually close issues (not just comment)
run_test_with_output \
    "Centralized action closes issues" \
    "grep -q 'state: .closed.' '$CENTRALIZED_ACTION' && echo 'closes-issues'" \
    "closes-issues"

run_test_with_output \
    "Weekly action closes issues" \
    "grep -q 'state: .closed.' '$WEEKLY_ACTION' && echo 'closes-issues'" \
    "closes-issues"

run_test_with_output \
    "Automated action closes issues" \
    "grep -q 'state: .closed.' '$AUTOMATED_ACTION' && echo 'closes-issues'" \
    "closes-issues"

run_test_with_output \
    "Snippet action closes issues" \
    "grep -q 'state: .closed.' '$SNIPPET_ACTION' && echo 'closes-issues'" \
    "closes-issues"

# Test 6: Check that workflows filter by title keywords (copilot + template/setup/update)
run_test_with_output \
    "Centralized action filters by copilot keyword" \
    "grep -q \"title.includes('copilot')\" '$CENTRALIZED_ACTION' && echo 'has-filter'" \
    "has-filter"

run_test_with_output \
    "Centralized action filters by template/setup/update keywords" \
    "grep -q \"title.includes('template')\" '$CENTRALIZED_ACTION' && grep -q \"title.includes('setup')\" '$CENTRALIZED_ACTION' && grep -q \"title.includes('update')\" '$CENTRALIZED_ACTION' && echo 'has-keywords'" \
    "has-keywords"

run_test_with_output \
    "Weekly action filters by copilot keyword" \
    "grep -q \"title.includes('copilot')\" '$WEEKLY_ACTION' && echo 'has-filter'" \
    "has-filter"

run_test_with_output \
    "Automated action filters by copilot keyword" \
    "grep -q \"title.includes('copilot')\" '$AUTOMATED_ACTION' && echo 'has-filter'" \
    "has-filter"

run_test_with_output \
    "Snippet action filters by copilot keyword" \
    "grep -q \"title.includes('copilot')\" '$SNIPPET_ACTION' && echo 'has-filter'" \
    "has-filter"

# Test 7: Check that create issue step does NOT depend on check-issue result
run_test_with_output \
    "Centralized action creates issue without check-issue condition" \
    "grep -B2 'Create automated setup or update issue' '$CENTRALIZED_ACTION' | grep -q 'check-issue.outputs.result' && echo 'has-condition' || echo 'no-condition'" \
    "no-condition"

run_test_with_output \
    "Weekly action creates issue without check-issue condition" \
    "grep -B2 'Create or update template issue' '$WEEKLY_ACTION' | grep -q 'check-issue.outputs.result' && echo 'has-condition' || echo 'no-condition'" \
    "no-condition"

run_test_with_output \
    "Automated action creates issue without has_existing_issue condition" \
    "grep -B2 'Create initial setup issue' '$AUTOMATED_ACTION' | grep -q 'has_existing_issue' && echo 'has-condition' || echo 'no-condition'" \
    "no-condition"

run_test_with_output \
    "Snippet action creates issue without check-issue condition" \
    "grep -B2 'Create template update issue' '$SNIPPET_ACTION' | grep -q 'check-issue.outputs.result' && echo 'has-condition' || echo 'no-condition'" \
    "no-condition"

# Test 8: Check that step names reflect new behavior
run_test_with_output \
    "Centralized action step name indicates closing" \
    "grep -q 'Check for and close existing' '$CENTRALIZED_ACTION' && echo 'has-close-in-name'" \
    "has-close-in-name"

run_test_with_output \
    "Weekly action step name indicates closing" \
    "grep -q 'Check for and close existing' '$WEEKLY_ACTION' && echo 'has-close-in-name'" \
    "has-close-in-name"

run_test_with_output \
    "Automated action step name indicates closing" \
    "grep -q 'Check for and close existing' '$AUTOMATED_ACTION' && echo 'has-close-in-name'" \
    "has-close-in-name"

run_test_with_output \
    "Snippet action step name indicates closing" \
    "grep -q 'Check for and close existing' '$SNIPPET_ACTION' && echo 'has-close-in-name'" \
    "has-close-in-name"

# Test 9: Check that title matching is case-insensitive
run_test_with_output \
    "Centralized action uses lowercase for title matching" \
    "grep -q 'title.toLowerCase()' '$CENTRALIZED_ACTION' && echo 'case-insensitive'" \
    "case-insensitive"

run_test_with_output \
    "Weekly action uses lowercase for title matching" \
    "grep -q 'title.toLowerCase()' '$WEEKLY_ACTION' && echo 'case-insensitive'" \
    "case-insensitive"

run_test_with_output \
    "Automated action uses lowercase for title matching" \
    "grep -q 'title.toLowerCase()' '$AUTOMATED_ACTION' && echo 'case-insensitive'" \
    "case-insensitive"

run_test_with_output \
    "Snippet action uses lowercase for title matching" \
    "grep -q 'title.toLowerCase()' '$SNIPPET_ACTION' && echo 'case-insensitive'" \
    "case-insensitive"

# Test 10: Check that workflows log the number of closed issues
run_test_with_output \
    "Centralized action logs closed issue count" \
    "grep -q 'Closed.*existing issue' '$CENTRALIZED_ACTION' && echo 'logs-count'" \
    "logs-count"

run_test_with_output \
    "Weekly action logs closed issue count" \
    "grep -q 'Closed.*existing issue' '$WEEKLY_ACTION' && echo 'logs-count'" \
    "logs-count"

run_test_with_output \
    "Automated action logs closed issue count" \
    "grep -q 'Closed.*existing issue' '$AUTOMATED_ACTION' && echo 'logs-count'" \
    "logs-count"

run_test_with_output \
    "Snippet action logs closed issue count" \
    "grep -q 'Closed.*existing issue' '$SNIPPET_ACTION' && echo 'logs-count'" \
    "logs-count"

echo ""
echo "All issue duplicate prevention tests passed!"

exit $EXIT_CODE
