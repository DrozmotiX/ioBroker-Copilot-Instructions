# Changelog

All notable changes to the ioBroker Copilot Instructions template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
  Placeholder for the next version (at the beginning of the line):
  ## **WORK IN PROGRESS**
-->

## **WORK IN PROGRESS**
- (Apollon77) **ENHANCED**: Added new instructions how to handle proper Package updates and related lock file
- (copilot) **FIXED**: Apply lessons learned from PR #48 hanging - updated all GitHub issue templates to default assign @copilot for immediate automation (Fixes #58)
- (copilot) **ENHANCED**: Added clear instructions in README.md to assign issues to @copilot for automated processing (Fixes #58) 
- (copilot) **ENHANCED**: Added instruction in README.md about Copilot creating PRs and waiting for review completion (Fixes #58)
- (copilot) **FIXED**: Corrected capitalization consistency - all references now properly use "Copilot" instead of "copilot" (Fixes #58)
- (copilot) **ENHANCED**: Updated all issue templates (feature_request.yml, bug_report.yml, documentation_automation.yml) to include default @copilot assignee (Fixes #58)
- (copilot) **ENHANCED**: Updated template markdown files (initial-setup-automation.md, automated-template-update.md) to include default @copilot assignee (Fixes #58)
- (copilot) **ENHANCED**: Updated integration testing examples to match proven working patterns from ticaki's brightsky adapter (Fixes #15)
- (copilot) **FIXED**: Fixed Promise scope issues in integration testing examples - use proper `(resolve, reject)` parameters and error handling (Fixes #15)
- (copilot) **NEW**: Added fully automated ioBroker Copilot setup with zero manual steps (Fixes #26)
- (copilot) **NEW**: Created initial-setup-automation.md template for comprehensive automated setup and validation
- (copilot) **NEW**: Added weekly-version-check-action.yml GitHub Action for automated template monitoring
- (copilot) **ENHANCED**: Eliminated all manual file creation steps in favor of GitHub Copilot automation
- (copilot) **NEW**: Added duplicate prevention guidance for [CUSTOMIZE] sections across all automation templates
- (copilot) **ENHANCED**: Updated all templates to automatically remove duplicate content during merges
- (copilot) **ENHANCED**: Replaced date references with version-focused information in README.md
- (copilot) **FIXED**: Added missing test helper functions to all test scripts for standalone execution
- (copilot) **FIXED**: Corrected path references in test scripts from TEST_DIR to REPO_ROOT
- (copilot) **NEW**: Added 30+ comprehensive tests for automated setup templates and functionality
- (copilot) **NEW**: Created templates/README.md with complete automation guide and usage recommendations
- (copilot) **ENHANCED**: Updated setup.md to emphasize full automation over manual processes
- (copilot) **NEW**: Created GitHub issue templates for repository feedback and community collaboration (Fixes #29)
- (copilot) **NEW**: Added feature request template for exploring new functionality with structured community input
- (copilot) **NEW**: Added comprehensive bug report template with type selection (template issues, setup issues, bugs, questions)
- (copilot) **NEW**: Added documentation and automation improvement template for community-driven enhancements
- (copilot) **NEW**: Added issue template configuration with community links (discussions, forum, documentation)
- (copilot) **TESTING**: Extended automated test suite to validate GitHub issue template structure and YAML syntax
- (copilot) **NEW**: Added automated template update system using GitHub Copilot-powered issue templates (Fixes #24)
- (copilot) **NEW**: Created copy-paste template for quick automated template validation and updates
- (copilot) **NEW**: Added comprehensive automated updates documentation with step-by-step workflows
- (copilot) **ENHANCED**: Reorganized README into focused documentation files by an instruction type for better user experience (Fixes #22)
- (copilot) **NEW**: Created separate docs/ directory with setup.md, maintenance.md, and testing.md for clear audience targeting
- (copilot) **ENHANCED**: Promoted intelligent Copilot-assisted template merging instead of 1:1 copying for better version control
- (copilot) **NEW**: Added comprehensive community support section with forum and GitHub contribution guidelines
- (copilot) **ENHANCED**: Made organization-specific setup instructions collapsible to reduce clutter for individual users
- (copilot) **ENHANCED**: Standardized changelog format inconsistencies to align with AlCalzone release-script standard - fixed mixed WORK IN PROGRESS formatting and added comprehensive changelog management documentation (Fixes #20)

## [0.4.0] - 2025-09-XX - Automated Version handling & validation by GitHub actions

### Added
- **Dynamic Version Management System** - Comprehensive scripts for automated version handling across all documentation
- **Version Extraction Script** (`scripts/extract-version.sh`) - Dynamically extracts version from template and current dates
- **Documentation Update Script** (`scripts/update-versions.sh`) - Automatically updates version references in README.md  
- **Master Version Management** (`scripts/manage-versions.sh`) - Unified interface for version show/check/sync/update operations
- **Comprehensive GitHub Copilot Setup Guide** - New "Prerequisites & Basic GitHub Copilot Setup" section with step-by-step instructions (Fixes #18)
- **Multi-Editor Installation Guide** - Support for VS Code, JetBrains IDEs, Vim/Neovim, and other editors
- **Repository Setup Validation** - Clear validation steps and troubleshooting guidance
- **Organization Permissions Guide** - Detailed instructions for GitHub Copilot in organizational repositories
- **Quick Reference Checklist** - Condensed checklist for experienced GitHub Copilot users
- **Setup Validation & Testing** - Post-integration testing guidance to ensure proper functionality
- **Test Runner** (`tests/test-runner.sh`) - Main test execution framework with isolated environments and detailed reporting
- **Script-Specific Test Suites** - Dedicated test files for each script covering unit, integration, and error scenarios
- **GitHub Actions Workflow** (`.github/workflows/test-scripts.yml`) - Automated CI/CD testing on push, PRs, and scheduled runs
- **Testing Documentation** (`TESTING.md`) - Comprehensive guide for test framework usage and maintenance
- **Test Coverage** - 9 tests for extract-version.sh, 13 for manage-versions.sh, 11 for update-versions.sh, 11 for check-template-version.sh, 10 integration tests

### Changed
- **Separated Repository Instructions** - `.github/copilot-instructions.md` now contains repository-specific instructions for maintaining the template repository
- **Clarified Template Usage** - `template.md` remains the clean template for ioBroker adapter developers to copy
- **Updated Documentation** - README.md now correctly references `template.md` for adapter developers
- **Improved Repository Focus** - Repository-specific copilot instructions focus on template maintenance, quality assurance, and community contribution guidelines
- **Fixed Version Consistency** - Updated template.md from 0.3.0 to 0.3.1 to match repository development version
- **Enhanced Quick Start Section** - Added prerequisite warnings and clearer step descriptions with validation
- **Improved Integration Steps** - Added setup validation before template integration and comprehensive testing guidance
- **Better Documentation Flow** - Logical progression from basic setup through template integration to validation

### Fixed
- **GitHub Copilot Duplicate Execution** - Added HTML comment block to `template.md` to prevent GitHub Copilot from processing it as active instructions (Fixes #11)
- **Template Installation Process** - Updated README.md and version check script with sed commands to remove template comment block during installation
- **Copilot Processing Conflict** - Resolved issue where both `.github/copilot-instructions.md` and `template.md` were being detected as active instruction files

### Enhanced
- **Eliminated Static Version References** - All version numbers and dates are now dynamically generated from template source
- **Cross-Documentation Consistency** - Automated validation ensures all files reference the same version
- **Date Management** - Automatic current date insertion eliminates stale date references (e.g., "January 2025" → current month/year)
- **AlCalzone Release-Script Changelog Compliance** - Standardized all WORK IN PROGRESS references to use correct `## **WORK IN PROGRESS**` format and added comprehensive changelog management guidance (Fixes #20)
- **Automated Testing Requirements** - Updated Copilot instructions with mandatory testing guidelines for new functionality
- **Quality Assurance Through Testing** - Comprehensive test coverage prevents regressions and ensures script reliability
- **CI/CD Integration** - Automated testing on all repository changes maintains code quality
- Version checking script continues to work with new structure
- Clear separation between template maintenance (this repository) and adapter development (template usage)
- Better documentation workflow for template contributors vs adapter developers

### Documentation
- **Version Management Guide** - Added comprehensive section explaining the new dynamic version system
- README.md updated to reference correct template file (`template.md` instead of `.github/copilot-instructions.md`)
- Download URLs updated throughout documentation  
- Version checking script updated to reference correct remote template
- Detailed usage instructions for all new version management scripts

## [0.3.0] - 2025-01-XX

### Added
- **Comprehensive Integration Testing Framework** - Official `@iobroker/testing` framework guidelines based on lessons learned from @ticaki
- **Testing Both Success AND Failure Scenarios** - Added examples for testing error conditions and invalid configurations  
- **7 Key Integration Testing Rules** - Mandatory rules for proper adapter integration testing
- **CI/CD Workflow Dependencies** - Proper job sequencing for integration tests
- **What NOT to Do vs What TO Do** - Clear guidance sections with specific examples

### Enhanced
- Integration testing section completely rewritten with official framework requirements
- Added comprehensive examples for both positive and negative test scenarios
- Improved error handling validation in integration tests
- Added proper failure scenario testing patterns

### Credits
- **@ticaki** for providing comprehensive lessons learned and best practices for ioBroker integration testing
- Community feedback integration for enhanced testing methodology

## [0.2.0] - 2025-01-08

### Added
- **API Testing with Credentials** comprehensive section with password encryption methodology
- Password encryption implementation using ioBroker's XOR cipher with system secret
- Demo credentials testing patterns for API endpoint validation  
- Enhanced test failure handling with clear, actionable error messages
- Mandatory README update requirements for every PR/feature
- Standardized documentation workflow with WORK IN PROGRESS section format
- CI/CD integration patterns for separate credential testing jobs
- GitHub Actions workflow examples for API connectivity testing
- Extended timeout recommendations for API calls (120+ seconds)
- Package.json script integration guidance for credential testing

### Enhanced
- Integration testing section with detailed credential testing methodology
- Documentation standards with mandatory PR update requirements
- Error handling patterns with specific examples for API testing
- Testing framework guidance with practical code examples

### Documentation
- Comprehensive password encryption algorithm with step-by-step implementation
- Clear success/failure criteria patterns for API testing
- CI/CD best practices for external API dependencies
- Enhanced documentation workflow standards and requirements

## [0.1.0] - 2025-01-08

### Added
- Initial release of the ioBroker Copilot Instructions template for community review
- Comprehensive README.md with repository goals and usage instructions
- Template file (`.github/copilot-instructions.md`) with best practices for:
  - Testing guidelines using Jest framework (includes example data for offline API/device testing)
  - README standards and documentation patterns (includes WORK IN PROGRESS section handling)
  - Dependency management best practices (includes npm install sync requirement)
  - JSON-Config admin interface guidelines (includes translation requirements)
  - HTTP client recommendations (fetch over axios)
  - Error handling patterns (includes user-friendly error messages and timer cleanup)
  - Code style and standards
- Template example file (`template.md`) for easy copying
- Versioning system for template validation
- Integration instructions with merge recommendation instead of copy/paste
- GitHub Actions workflow example for automated template version checking
- Links to ioBroker project and community resources

### Documentation
- Complete setup and integration guide
- Version management instructions
- Contributing guidelines
- Support and community links

[0.3.0]: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/releases/tag/v0.3.0
[0.2.0]: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/releases/tag/v0.2.0
[0.1.0]: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/releases/tag/v0.1.0
