# Testing Infrastructure Documentation

This document describes the automated testing infrastructure for all scripts and automations in the ioBroker Copilot Instructions repository.

## Overview

The testing framework provides comprehensive automated testing for all shell scripts in the `scripts/` directory:

- `manage-versions.sh` - Master version management script
- `extract-version.sh` - Version and date extraction utility  
- `update-versions.sh` - Documentation version synchronization
- `check-template-version.sh` - Template version comparison tool
- `generate-release-notes.sh` - Automated release notes generation with changelog aggregation

## Test Structure

### Test Files

All test files are located in the `tests/` directory:

- `test-runner.sh` - Main test execution framework
- `test-extract-version.sh` - Tests for extract-version.sh functionality
- `test-manage-versions.sh` - Tests for manage-versions.sh commands
- `test-update-versions.sh` - Tests for update-versions.sh operations
- `test-check-template-version.sh` - Tests for check-template-version.sh features
- `test-generate-release-notes.sh` - Tests for generate-release-notes.sh with changelog aggregation
- `test-integration.sh` - Integration tests for script interactions
- `test-issue-duplicate-prevention.sh` - Tests for GitHub Actions duplicate issue prevention
- `test-automated-templates.sh` - Tests for automated template update functionality
- `test-centralized-automation.sh` - Tests for centralized automation workflows
- `test-initial-setup-automation.sh` - Tests for initial setup automation

### Test Categories

**Unit Tests**: Test individual script functions and command-line options
- Parameter validation
- Output format verification
- Error handling
- Edge cases

**Integration Tests**: Test script interactions and workflows
- End-to-end version update workflows
- Cross-script dependencies
- File system operations
- Consistency validation

**Error Handling Tests**: Test graceful failure scenarios
- Missing files
- Invalid parameters  
- Network failures (for remote checks)
- Dependency failures

## Running Tests

### Local Development

```bash
# Run all tests
./tests/test-runner.sh

# Run specific test file
./tests/test-runner.sh tests/test-extract-version.sh

# Make test runner executable if needed
chmod +x tests/test-runner.sh
```

### Continuous Integration

Tests run automatically via GitHub Actions on:

- Push to main/develop branches
- Pull requests to main branch
- Daily schedule (2 AM UTC) 
- Manual trigger via workflow_dispatch

The workflow is defined in `.github/workflows/test-scripts.yml`.

## Test Framework Features

### Isolated Test Environment

Each test run creates an isolated temporary directory with copies of all repository files, ensuring tests don't interfere with the actual repository or each other.

### Comprehensive Assertions

- **Exit Code Validation**: Tests verify expected success/failure states
- **Output Pattern Matching**: Tests check for specific output messages
- **File State Verification**: Tests validate file changes and consistency
- **Dependency Checking**: Tests verify script dependencies exist

### Detailed Reporting

- Color-coded pass/fail indicators
- Detailed error messages for failed tests
- Test summary with counts
- Failed test details for debugging

## Adding New Tests

When adding new functionality to existing scripts or creating new scripts:

### For Existing Scripts

1. Add test cases to the appropriate `test-<script-name>.sh` file
2. Follow the existing test patterns:
   ```bash
   run_test_with_output \
       "Test description" \
       "command to test" \
       "expected output pattern"
   ```

### For New Scripts

1. Create a new test file: `tests/test-<new-script>.sh`
2. Follow the structure of existing test files
3. Test all command-line options and error conditions
4. Add integration tests to `test-integration.sh` if the script interacts with others

### Test Function Reference

```bash
# Test with exit code validation only
run_test "test name" "command" [expected_exit_code]

# Test with output pattern validation  
run_test_with_output "test name" "command" "regex_pattern" [expected_exit_code]

# Direct pass/fail reporting
print_test_result "test name" "PASS|FAIL" ["error message"]
```

## Version Management Testing

The test suite includes specific validation for version management workflows:

### Version Consistency Tests
- Template vs README version matching
- Date synchronization verification
- Cross-file version propagation

### Update Workflow Tests
- Full version update cycle testing
- Rollback and restoration testing
- Error recovery testing

### Remote Version Checking Tests
- Network failure handling
- Malformed response handling
- Update guidance verification

## Best Practices

### Test Design
- Test both success and failure scenarios
- Include edge cases and boundary conditions
- Verify error messages are helpful and actionable
- Test script behavior with missing dependencies

### Test Maintenance
- Update tests when script functionality changes
- Ensure tests are deterministic and don't depend on external state
- Use meaningful test names that describe the scenario
- Group related tests logically

### Error Handling
- Test graceful degradation when files are missing
- Verify appropriate exit codes for different error conditions
- Test recovery from inconsistent states

## Troubleshooting

### Common Issues

**Test Environment Setup Failures**: Ensure all scripts have execute permissions
```bash
chmod +x scripts/*.sh tests/*.sh
```

**Hidden File Copying**: The test framework copies hidden directories (like `.github`) for complete testing

**Network-dependent Tests**: Some tests (remote version checking) may fail in network-restricted environments but include fallback scenarios

### Debugging Failed Tests

1. Run specific failing test file for detailed output
2. Check the error message in the test summary
3. Verify script dependencies and file permissions
4. Test the actual script manually with the failing scenario

## Issue Duplicate Prevention Testing

The `test-issue-duplicate-prevention.sh` suite validates the GitHub Actions workflows that prevent duplicate issue creation. This addresses the bug where workflows were creating multiple identical issues for template updates.

### What It Tests

**Creator Filtering**: Ensures workflows only check issues created by `github-actions[bot]`
- Prevents false positives from manually created issues
- Focuses on automation-generated issues only

**Label Independence**: Verifies workflows don't rely on labels for duplicate detection
- Uses title pattern matching instead
- More reliable as labels can be modified or missing

**Comprehensive Closing**: Validates that ALL existing issues are closed
- Iterates through all matching issues (not just the first)
- Prevents accumulation of stale update issues

**Title Pattern Matching**: Tests case-insensitive keyword detection
- Checks for "copilot" + ("template" OR "setup" OR "update" OR "instructions")
- Catches various issue title formats

**Comment Before Close**: Ensures users are notified when issues are auto-closed
- Adds explanatory comment before closing
- Provides context for the closure

**Unconditional Issue Creation**: Verifies new issues are always created after cleanup
- Doesn't skip creation if old issues existed
- Ensures users always have a current update issue

### Test Coverage

- 40 comprehensive tests across 4 workflow files
- Tests both centralized and legacy workflow templates
- Validates snippet examples match workflow behavior
- Ensures consistent behavior across all automation files

### Running Issue Prevention Tests

```bash
# Run only the duplicate prevention tests
./tests/test-issue-duplicate-prevention.sh

# Or run as part of full suite
./tests/test-runner.sh
```

## Future Enhancements

Potential testing improvements:

- **Performance Testing**: Add timing measurements for large operations
- **Stress Testing**: Test with large files or many concurrent operations  
- **Security Testing**: Validate input sanitization and path traversal protection
- **Cross-Platform Testing**: Test on different OS environments (Windows, macOS)
- **Mutation Testing**: Verify test quality by introducing intentional bugs