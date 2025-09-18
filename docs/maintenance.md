# Repository Maintenance Guide

This guide is specifically for maintainers of the ioBroker Copilot Instructions repository. It covers version management, testing infrastructure, and repository maintenance procedures.

## 📋 Table of Contents

- [Version Management](#version-management)
- [Automated Testing Infrastructure](#automated-testing-infrastructure)
- [Development Guidelines](#development-guidelines)
- [Release Process](#release-process)
- [Troubleshooting](#troubleshooting)

## Version Management

This repository includes comprehensive version management scripts that automatically handle version consistency across all documentation.

### Available Commands

```bash
# Show current versions across all files
./scripts/manage-versions.sh show

# Check for version inconsistencies
./scripts/manage-versions.sh check

# Sync documentation with current template version (updates dates and versions dynamically)
./scripts/manage-versions.sh sync

# Update to a new version across all files
./scripts/manage-versions.sh update 0.3.2
```

### What the Scripts Do

These scripts ensure that:
- Version numbers are dynamically pulled from the template
- Documentation dates stay current
- All cross-references remain consistent
- Manual version updates are no longer needed

### Version Check for Users

Users can validate their local template version with our provided script:

```bash
# Download and run the version check script
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

### GitHub Action for Continuous Monitoring

You can set up a GitHub Action to periodically check if templates are up-to-date:

```yaml
# .github/workflows/check-copilot-template.yml
name: Check Copilot Template Version
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly check
  workflow_dispatch:

jobs:
  check-template:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check template version
        run: |
          CURRENT_VERSION=$(grep "Version:" .github/copilot-instructions.md | head -1 | sed 's/.*Version:\s*//')
          LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md | grep "Version:" | head -1 | sed 's/.*Version:\s*//')
          if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
            echo "Template is outdated. Current: $CURRENT_VERSION, Latest: $LATEST_VERSION"
            exit 1
          fi
```

## Automated Testing Infrastructure

This repository includes a comprehensive automated testing framework that ensures all scripts and automations work correctly.

### Running Tests

```bash
# Run all tests (54 total tests)
./tests/test-runner.sh

# Run specific test file
./tests/test-runner.sh tests/test-extract-version.sh

# Tests are automatically run in CI/CD via GitHub Actions
```

### Test Coverage

**Unit Tests**: Individual script functions and parameter validation
**Integration Tests**: Cross-script workflows and end-to-end scenarios  
**Error Handling Tests**: Missing files, invalid parameters, network failures
**Consistency Tests**: Version synchronization and file state validation

### Key Testing Features

- **Isolated Test Environments**: Each test run uses temporary directories to prevent interference
- **Comprehensive Reporting**: Color-coded output with detailed error messages and debugging information
- **CI/CD Integration**: Automated testing on all repository changes via `.github/workflows/test-scripts.yml`
- **Developer Friendly**: Simple commands with clear documentation in `TESTING.md`

All repository scripts are thoroughly tested to prevent regressions and ensure reliability for the ioBroker community.

For detailed testing documentation, see [TESTING.md](../TESTING.md).

## Development Guidelines

### Contributing Requirements

- All new scripts must have corresponding tests in the `tests/` directory
- Changes to existing scripts require updating relevant test cases
- Follow the testing patterns documented in `TESTING.md`
- Ensure all 54 tests pass before submitting PRs

### Code Standards

- Shell scripts must be executable and follow bash best practices
- All scripts should handle errors gracefully
- Use descriptive variable names and add comments for complex logic
- Test scripts on different environments when possible

### Documentation Standards

- **ALWAYS update CHANGELOG.md** - Every PR that introduces new functionality, fixes issues, or makes changes must include a detailed changelog entry with issue references (e.g., "Fixes #16")
  - Add entries under `## **WORK IN PROGRESS**` section following AlCalzone release-script standard
  - Use format: `- (author) **TYPE**: Description of user-visible change (Fixes #XX)`
  - Types: **NEW** (features), **FIXED** (bugs), **ENHANCED** (improvements), **TESTING** (test additions), **CI/CD** (automation)
  - Focus on user impact, not technical implementation details
- **ALWAYS update README.md** - When adding new functionality, infrastructure, or changing how users interact with the repository, update the relevant sections
- Include detailed CHANGELOG.md entries for user-facing changes with specific details about what was added/changed/fixed

### Testing Requirements

When adding new scripts or modifying existing ones, you **MUST**:

1. **Create/Update Tests**: Add comprehensive test cases in the appropriate `test-<script-name>.sh` file
2. **Test All Functions**: Cover success scenarios, error conditions, and edge cases
3. **Validate Dependencies**: Ensure tests check for required files and dependencies
4. **Test Integration**: Add integration tests if scripts interact with other components
5. **Run Full Suite**: Execute `./tests/test-runner.sh` to verify all tests pass
6. **Update Documentation**: Modify `TESTING.md` if adding new testing patterns

#### Test Categories Required:
- **Unit Tests**: Individual function and command-line option testing
- **Integration Tests**: Script interaction and workflow testing  
- **Error Handling Tests**: Missing files, invalid parameters, network failures
- **Consistency Tests**: Version synchronization and file state validation

## Release Process

### Preparing a Release

1. **Update Version**: Use the version management script
   ```bash
   ./scripts/manage-versions.sh update X.Y.Z
   ```

2. **Update CHANGELOG.md**: Add comprehensive change descriptions

3. **Verify Consistency**: Run consistency checks
   ```bash
   ./scripts/manage-versions.sh check
   ```

4. **Test Everything**: Run the complete test suite
   ```bash
   ./tests/test-runner.sh
   ```

5. **Validate Integration**: Test download URLs and integration scripts

### Post-Release Tasks

- Announce significant changes to the ioBroker community
- Monitor for user feedback and issues
- Update documentation if needed based on user questions

## Troubleshooting

### Common Issues

**Test Environment Setup Failures**: Ensure all scripts have execute permissions
```bash
chmod +x scripts/*.sh tests/*.sh
```

**Version Inconsistencies**: Use the sync command to restore consistency
```bash
./scripts/manage-versions.sh sync
```

**Failed Tests**: Run specific test files for detailed debugging
```bash
./tests/test-runner.sh tests/test-specific-feature.sh
```

### Debugging Failed Tests

1. Run specific failing test file for detailed output
2. Check the error message in the test summary
3. Verify script dependencies and file permissions
4. Test the actual script manually with the failing scenario

### Repository Maintenance

**Regular Tasks:**
- Monitor test results in CI/CD
- Update dependencies and security patches
- Review and respond to community feedback
- Keep documentation current with template changes

**Quarterly Tasks:**
- Review version management system performance
- Analyze test coverage and add missing scenarios
- Update examples to reflect current ioBroker best practices
- Evaluate new testing or automation opportunities

---

**For general usage information**, return to the [main README](../README.md) or consult the [setup guide](setup.md) for template integration instructions.