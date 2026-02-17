# ioBroker Copilot Instructions Template Repository

**Version:** 0.5.4

This file contains instructions for maintaining this template repository.

## Quick Reference

**Key Files:**
- `template.md` - Main template for ioBroker adapters
- `CHANGELOG.md` - Version history
- `config/metadata.json` - Version registry
- `scripts/manage-versions.sh` - Version management

**Common Commands:**
```bash
./scripts/manage-versions.sh update X.Y.Z  # Update version
./scripts/manage-versions.sh check          # Verify consistency
./tests/test-runner.sh                      # Run tests
```

## PR Requirements (Mandatory)

Every PR MUST include:

1. **Version Bump** - Use `./scripts/manage-versions.sh update X.Y.Z`
   - PATCH (X.Y.Z+1): Bug fixes, docs, minor changes
   - MINOR (X.Y+1.0): New features (backwards compatible)
   - MAJOR (X+1.0.0): Breaking changes

2. **CHANGELOG.md Entry** - Add under `## **WORK IN PROGRESS**`
   - Format: `- (author) **TYPE**: Description (Fixes #XX)`
   - Types: NEW, ENHANCED, FIXED, TESTING, CI/CD

3. **Test Suite** - Run `./tests/test-runner.sh` before committing

4. **Documentation** - Update README.md if user-facing changes

## Development Guidelines

**Template Updates:**
- Focus on ioBroker adapter development needs
- Use proven patterns from real projects
- Include practical examples with code
- Test with actual adapter projects

**Code Standards:**
- Modern JavaScript/TypeScript (ES2020+)
- Follow ioBroker conventions
- Include error handling

**Testing:**
- Add tests for new functionality
- Cover success, error, and edge cases
- Update TESTING.md if needed

## Version Management

- Main version tied to template version
- Component versions managed independently
- All version changes must increment (no downgrades)
- Changes trigger automated deployment to main

## Quality Checks

Before submitting PR:
- [ ] Version bumped
- [ ] CHANGELOG.md updated with issue reference
- [ ] Tests pass (`./tests/test-runner.sh`)
- [ ] Consistency verified (`./scripts/manage-versions.sh check`)
- [ ] Documentation updated if needed

## Release Process
For minor/major releases:
1. System creates issue with changelog data
2. Assign to @copilot to create human-readable notes
3. @copilot creates GitHub release
4. minor releases must contain a summary of all patch version release notes
5. major release must contain a summary of all minor realease notes
6. thise summary should not be a copy/paste of the changelog, but reviews and himan friendly summarized by copilot

For patch releases:
1. Patch releases don't require an automatically created issue, but can be initated manually using the template
2. Patch release notes must have a summary of changelog items between last release notes and all version bumps starting from last major/minor release (can be multiple merges/tags) made. 
3. Thise summary should not be a copy/paste of the changelog, but reviews and himan friendly summarized by copilot
4. Conflicts in summary items ahould be avoided, as version 0.2.4 potentially solves an issue/removes functionality introduced in 0.2.2 before without having release in between
