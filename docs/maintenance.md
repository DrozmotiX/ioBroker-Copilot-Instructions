# Repository Maintenance Guide

This guide is specifically for maintainers of the ioBroker Copilot Instructions repository. It covers version management, testing infrastructure, and repository maintenance procedures.

## 💬 Community Support & Development

**Join the ioBroker Copilot Instructions Community!**

This repository serves the ioBroker community by providing standardized GitHub Copilot instructions for adapter development. We're continuously improving these templates based on real-world usage and community feedback.

### 🏠 Why Join Our Community:
- **Share Experiences**: Learn from other developers using Copilot for ioBroker adapter development
- **Collaborate on Improvements**: Help refine templates and best practices
- **Get Support**: Quick help with setup and troubleshooting
- **Accelerated Development**: Write adapter code faster with intelligent suggestions
- **Best Practice Enforcement**: Ensure your adapters follow ioBroker conventions

### 🤝 How to Contribute & Participate:
- **[ioBroker Community Forum](https://forum.iobroker.net/topic/82238/ki-trifft-iobroker-ein-gemeinsames-abenteuer)** - Join discussions about improving adapter development with AI assistance
- **[Submit Issues](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/issues)** - Report bugs, suggest improvements, or request new features
- **[GitHub Discussions](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/discussions)** - Share ideas, ask questions, and collaborate on best practices
- **Share Success Stories**: Help others by sharing what works well in your adapter projects
- **Contribute Templates**: Suggest improvements to existing instructions or propose new patterns

### 🎯 Easy Setup, Lasting Benefits:
Setting up GitHub Copilot with our ioBroker templates takes just minutes. The templates handle the complexity while you focus on building great adapters.

**Ready to improve your ioBroker development experience?** The setup is straightforward, the community is supportive, and your contributions help everyone!

---

## 📋 Table of Contents

- [Community Support & Development](#-community-support--development)
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
./scripts/manage-versions.sh update 0.4.1
```

### What the Scripts Do

These scripts ensure that:
- Version numbers are dynamically pulled from the template
- Documentation dates stay current
- All cross-references remain consistent
- Manual version updates are no longer needed

### Version Check for Users

Use the provided script to check if your template is up-to-date:

```bash
# Download and run the version check script
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

This script will:
- Compare your local template version with the latest available
- Provide update guidance if your template is outdated
- Show you what's changed in newer versions

### GitHub Action for Continuous Monitoring

For automated template monitoring, copy the GitHub Action from our centralized template:

**Reference**: [GitHub Action Template](https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/github-action-version-check.yml)

This action will:
- Check for template updates weekly
- Automatically create GitHub issues when updates are available
- Handle both initial setup and update scenarios
- Preserve custom content during updates

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

For documentation formatting standards and changelog entry requirements, please refer to:
- [AlCalzone release-script documentation](https://github.com/AlCalzone/release-script/blob/main/README.md)
- [Main README](../README.md)

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

### Automated Release Creation

The repository now includes an automated release system that creates GitHub releases whenever a version is bumped and merged to main.

**How it Works:**
1. When a PR with a version bump is merged to `main`, the deployment workflow creates a git tag (e.g., `v0.5.4`)
2. The tag automatically triggers the `create-release.yml` workflow
3. The workflow generates human-readable release notes from `CHANGELOG.md`
4. A GitHub release is automatically created with the generated notes

**Release Note Features:**
- **Smart Aggregation**: Minor releases include summaries of all patch releases, major releases include summaries of all minor releases
- **Human-Readable**: Automatically categorizes and counts changes (new features, enhancements, bug fixes, etc.)
- **Emoji Indicators**: Uses emojis (🎉 ✨ 🐛 🧪 🔧) for visual clarity
- **Statistics**: Shows total number of changes by category

**Example Release Types:**
- **Patch Release (e.g., 0.5.4)**: Lists all changes for that version
- **Minor Release (e.g., 0.6.0)**: Includes summary of all 0.5.x patches plus the 0.6.0 changes
- **Major Release (e.g., 1.0.0)**: Includes summary of all 0.x.0 minor releases plus the 1.0.0 changes

**Manual Release Creation:**
If you need to create a release manually, you can trigger it via GitHub Actions:
1. Go to Actions → "Create GitHub Release"
2. Click "Run workflow"
3. Enter the tag (e.g., `v0.5.4`)
4. Click "Run workflow"

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

- **GitHub Release**: Automatically created with aggregated release notes (no manual action needed)
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