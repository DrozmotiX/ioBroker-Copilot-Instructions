# Changelog

All notable changes to the ioBroker Copilot Instructions template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2025-01-XX

### Changed
- **Separated Repository Instructions** - `.github/copilot-instructions.md` now contains repository-specific instructions for maintaining the template repository
- **Clarified Template Usage** - `template.md` remains the clean template for ioBroker adapter developers to copy
- **Updated Documentation** - README.md now correctly references `template.md` for adapter developers
- **Improved Repository Focus** - Repository-specific copilot instructions focus on template maintenance, quality assurance, and community contribution guidelines

### Fixed
- **GitHub Copilot Duplicate Execution** - Added HTML comment block to `template.md` to prevent GitHub Copilot from processing it as active instructions (Fixes #11)
- **Template Installation Process** - Updated README.md and version check script with sed commands to remove template comment block during installation
- **Copilot Processing Conflict** - Resolved issue where both `.github/copilot-instructions.md` and `template.md` were being detected as active instruction files

### Enhanced
- Version checking script continues to work with new structure
- Clear separation between template maintenance (this repository) and adapter development (template usage)
- Better documentation workflow for template contributors vs adapter developers

### Documentation
- README.md updated to reference correct template file (`template.md` instead of `.github/copilot-instructions.md`)
- Download URLs updated throughout documentation
- Version checking script updated to reference correct remote template

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