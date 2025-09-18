# ioBroker Copilot Instructions Template Repository

**Repository Purpose:** This repository maintains the template and best practices for GitHub Copilot instructions used in ioBroker adapter development.

**Version:** 0.3.1

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
- `scripts/check-template-version.sh` - Version checking utility for users
- `.github/copilot-instructions.md` - THIS file - repository-specific instructions

## Template Development Guidelines

### Version Management
- Always update version numbers in both `template.md` and this file when making changes
- Document all changes in `CHANGELOG.md` with detailed descriptions
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Update version references in README.md and scripts

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
- Ensure version check script works correctly
- Verify download URLs and curl commands in documentation

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
- **ALWAYS update CHANGELOG.md** - Every PR that introduces new functionality, fixes issues, or makes changes must include a detailed changelog entry with issue references (e.g., "Fixes #11")
- PRs must update version numbers appropriately
- Include detailed CHANGELOG.md entries for user-facing changes
- Test changes against multiple ioBroker adapter projects when possible
- Update README.md if usage instructions change
- Verify version check script continues to work
- Reference the specific issue number in both commit messages and changelog entries

### Release Process
- Increment version number in template.md and this file
- Update CHANGELOG.md with comprehensive change description
- Update README.md version references
- Test download URLs and integration scripts
- Announce significant changes to ioBroker community

## Quality Assurance

### Content Validation
- Ensure all URLs and links are functional
- Verify code examples compile and run correctly  
- Test integration instructions with fresh ioBroker adapter projects
- Validate version check script against current and previous versions
- Check that customization tags `[CUSTOMIZE]` are appropriately placed

### Documentation Consistency
- Maintain consistent formatting and style across all files
- Use the same terminology throughout (adapter vs. plugin, etc.)
- Keep examples realistic and based on actual adapter development scenarios
- Ensure version numbers are synchronized across all files

### Breaking Changes
- Document breaking changes clearly in CHANGELOG.md
- Provide migration guidance when template structure changes significantly  
- Consider deprecation warnings before removing functionality
- Test impact on existing adapter projects using previous versions