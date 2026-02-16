# ioBroker Copilot Instructions Template Repository

**Repository Purpose:** This repository maintains the template and best practices for GitHub Copilot instructions used in ioBroker adapter development.

**Version:** 0.5.1

This file contains instructions specific to maintaining and improving this template repository, not for ioBroker adapter development (that's in `template.md`).

## Repository Context

You are working on the ioBroker Copilot Instructions template repository. This repository:

- Maintains a comprehensive template (`template.md`) for ioBroker adapter developers
- Provides best practices and standardized instructions for GitHub Copilot 
- Serves as the authoritative source for ioBroker adapter development patterns
- Requires careful versioning and documentation of changes

## Key Files Structure

- `template.md` - The main template file that developers copy to their repositories as `.github/copilot-instructions.md`
- `README.md` - Repository documentation explaining how to use the template  
- `CHANGELOG.md` - Version history and detailed change documentation
- `TESTING.md` - Automated testing infrastructure documentation
- `config/metadata.json` - **CENTRALIZED VERSION REGISTRY** - Contains all component versions and deployment configuration
- `scripts/check-template-version.sh` - Version checking utility for users
- `scripts/manage-versions.sh` - **Enhanced version management** (show/check/sync/update/update-component/list-components commands)
- `scripts/extract-version.sh` - Dynamic version extraction from template and current dates
- `scripts/update-versions.sh` - Automated documentation synchronization script
- `scripts/shared-utils.sh` - **Enhanced with component version functions** for metadata access
- `tests/test-runner.sh` - Main test execution framework for all scripts
- `tests/test-*.sh` - Comprehensive test suites for each script and integration scenarios
- `tests/test-version-separation.sh` - **NEW** - Tests for multi-component versioning system
- `.github/workflows/test-scripts.yml` - GitHub Actions workflow for continuous testing
- `.github/workflows/deploy-on-version-change.yml` - **NEW** - Automated deployment on main version changes
- `.github/copilot-instructions.md` - THIS file - repository-specific instructions

## Template Development Guidelines

### Version Management
- **Enhanced Multi-Component Versioning**: Repository now supports independent versioning for templates, GitHub Actions, and other components
- **Main Package Version**: Always tied to template version and triggers automated deployment when changed
- **Component Updates**: Use `./scripts/manage-versions.sh update-component <component_path> <version>` for individual component versions
- **Version Policy Enforcement**: All version changes must be incremental (higher than previous version)
- **Centralized Configuration**: All version information stored in `config/metadata.json` with full component tracking
- **Main Version Updates**: Use `./scripts/manage-versions.sh update X.Y.Z` (automatically updates template and package versions together)
- **Version Validation**: Built-in checks ensure main version matches template version and prevents downgrades
- **Automated Deployment**: Changes to main version trigger deployment workflow automatically
- Document all changes in `CHANGELOG.md` with detailed descriptions
- Use semantic versioning (MAJOR.MINOR.PATCH) for all components
- Validate consistency with: `./scripts/manage-versions.sh check`
- Sync documentation with: `./scripts/manage-versions.sh sync` when needed

### GitHub Copilot Review Instructions for Version Changes
When reviewing PRs that modify versions:
1. **Always verify main version changes match template version** - these must be identical
2. **Check that version increments are higher than previous** - prevent downgrades
3. **Validate component version changes** - ensure they follow semantic versioning
4. **Confirm CHANGELOG.md is updated** - require detailed change documentation
5. **Check for deployment readiness** - main version changes trigger automated deployment
6. **Review version policy compliance** - ensure all changes follow increment requirements
7. **Validate metadata consistency** - run `./scripts/manage-versions.sh check` mentally
8. **Component separation compliance** - ensure components use independent versioning appropriately

### Template Content Standards  
- Focus on practical, actionable guidance for ioBroker adapter developers
- Include comprehensive examples with real code snippets
- Maintain sections: Testing, README Updates, Dependency Management, JSON-Config, Error Handling, CI/CD
- Keep customization points marked with `[CUSTOMIZE]` tags
- Ensure all recommendations are tested and proven in real adapter projects

### Documentation Quality
- README.md must clearly explain template usage and integration steps
- Provide both "merge with existing" and "new repository" workflows
- Include version checking and update procedures
- Maintain links to ioBroker community resources and official documentation

### Testing and Validation
- Test template instructions with real ioBroker adapter projects
- Validate all code examples for syntax and functionality
- Ensure version management scripts work correctly (`manage-versions.sh`, `extract-version.sh`, `update-versions.sh`)
- Verify download URLs and curl commands in documentation
- **Run automated test suite before any changes**: `./tests/test-runner.sh`
- **All scripts must have corresponding tests** in the `tests/` directory
- **New functionality requires new test cases** to prevent regressions

### Automated Testing Requirements
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

#### Test Framework Usage:
```bash
# Run all tests
./tests/test-runner.sh

# Run specific test file  
./tests/test-runner.sh tests/test-extract-version.sh

# Add new test to existing file
run_test_with_output \
    "Test description" \
    "command to test" \
    "expected output pattern"
```

GitHub Copilot will automatically validate if new test cases should be created or existing ones removed when new functionality is added.

## Contributing to the Template

### Making Template Updates
- Focus changes on improving adapter development experience
- Base recommendations on proven practices from real ioBroker adapter projects  
- Consider both beginner and advanced adapter developers
- Maintain backward compatibility when possible
- Update examples to reflect current Node.js and ioBroker versions

### Adding New Sections
- Research the topic thoroughly within ioBroker ecosystem context
- Provide practical examples and code snippets
- Include both "what to do" and "what not to do" guidance
- Consider impact on existing adapter projects using the template
- Document the rationale for additions in CHANGELOG.md

### Code Examples Standards
- Use modern JavaScript/TypeScript syntax (ES2020+)
- Follow ioBroker adapter patterns and conventions
- Include error handling and edge cases
- Test examples in real adapter development environments
- Prefer `@iobroker/testing` framework patterns for integration tests

### Community Feedback Integration
- Monitor ioBroker forums and GitHub issues for common development challenges
- Incorporate lessons learned from adapter developers
- Address frequently asked questions in template guidance
- Consider feedback from both new and experienced developers

## Repository Maintenance

### Issue Management
- Template improvement requests should reference specific adapter development challenges
- Bug reports should include which section of template is problematic
- Feature requests should align with ioBroker community needs
- Close duplicate or outdated issues promptly

### Pull Request Guidelines  
- **ALWAYS update CHANGELOG.md** - Every PR that introduces new functionality, fixes issues, or makes changes must include a detailed changelog entry with issue references (e.g., "Fixes #16")
  - Add entries under `## **WORK IN PROGRESS**` section following AlCalzone release-script standard
  - Use format: `- (author) **TYPE**: Description of user-visible change (Fixes #XX)`
  - Types: **NEW** (features), **FIXED** (bugs), **ENHANCED** (improvements), **TESTING** (test additions), **CI/CD** (automation)
  - Focus on user impact, not technical implementation details
- **ALWAYS update README.md** - When adding new functionality, infrastructure, or changing how users interact with the repository, update the relevant sections of README.md
- PRs must update version numbers appropriately using the dynamic version management system
- Include detailed CHANGELOG.md entries for user-facing changes with specific details about what was added/changed/fixed
- Test changes against multiple ioBroker adapter projects when possible
- Update README.md if usage instructions, new features, or repository structure changes
- Verify dynamic version management system continues to work (`./scripts/manage-versions.sh check`)
- **Run the complete test suite** (`./tests/test-runner.sh`) to ensure all tests pass
- Reference the specific issue number in both commit messages and changelog entries
- **Document new testing requirements** in TESTING.md when adding new scripts or functionality

### Release Process
- Use dynamic version management: `./scripts/manage-versions.sh update X.Y.Z`
- Update CHANGELOG.md with comprehensive change description
- Verify all changes with: `./scripts/manage-versions.sh check`
- Test download URLs and integration scripts
- Announce significant changes to ioBroker community

## Quality Assurance

### Content Validation
- Ensure all URLs and links are functional
- Verify code examples compile and run correctly  
- Test integration instructions with fresh ioBroker adapter projects
- Validate dynamic version management system against current and previous versions
- Check that customization tags `[CUSTOMIZE]` are appropriately placed

### Documentation Consistency
- Maintain consistent formatting and style across all files
- Use the same terminology throughout (adapter vs. plugin, etc.)
- Keep examples realistic and based on actual adapter development scenarios
- Version numbers are automatically synchronized across all files via dynamic version management scripts

### Breaking Changes
- Document breaking changes clearly in CHANGELOG.md
- Provide migration guidance when template structure changes significantly  
- Consider deprecation warnings before removing functionality
- Test impact on existing adapter projects using previous versions