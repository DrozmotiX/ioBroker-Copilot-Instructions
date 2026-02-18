# ioBroker Copilot Instructions Template Repository

**Version:** 0.5.5

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

### Overview
- **Automated**: Minor/major releases trigger automated issue creation via `create-release.yml` workflow
- **Manual**: All release types can be initiated via `.github/ISSUE_TEMPLATE/release_creation.yml`
- **Handler**: @copilot processes all release requests following the steps below

### Step-by-Step Instructions for @copilot

When assigned a release issue (either automated or manual), follow these steps:

#### Step 1: Detect Version and Type
1. Check the latest merged tags to main branch:
   ```bash
   git tag --sort=-v:refname | head -5
   ```
2. Check existing GitHub releases to identify unreleased versions:
   ```bash
   gh release list --limit 10
   ```
3. Identify the most recent version tag
4. Determine version type by parsing the version number:
   - **Patch release** (x.y.Z): Third number incremented
   - **Minor release** (x.Y.0): Middle number incremented, third is 0
   - **Major release** (X.0.0): First number incremented, others are 0
5. **For patch releases**: Identify ALL patch versions since last GitHub release
   - Example: If tags show v0.5.3, v0.5.2, v0.5.1, v0.5.0 but only v0.5.0 has a GitHub release, you need to summarize v0.5.1 + v0.5.2 + v0.5.3 combined

#### Step 2: Extract Changelog Data
Run the changelog extraction script to get all relevant entries:
```bash
./scripts/generate-release-notes.sh [DETECTED_VERSION]
```
This script automatically:
- Extracts changelog entries for the target version
- For minor releases: includes all patch releases since last minor
- For major releases: includes all minor releases since last major

#### Step 3: Create Human-Readable Summary (CRITICAL REQUIREMENTS)

**Mandatory Guidelines:**

##### For Minor Releases:
- ✅ MUST contain a summary of ALL changelog items from ALL patch version bumps since last minor, including merges without a release
- ❌ Do NOT copy/paste the changelog entries verbatim
- ✅ Review and create human-friendly summarized content
- ⚠️ Avoid conflicts: If v0.5.4 solves an issue introduced in v0.5.2, consolidate appropriately (don't mention both)
- ⚠️ Avoid conflicts: If v0.5.4 solves an issue introduced in v0.5.2, consolidate appropriately (don't mention both)
- 📊 Group related changes into themes/categories
- 🎯 Focus on user impact, not technical implementation details

##### For Major Releases:
- ✅ MUST contain a summary of ALL minor/patch release notes since last major
- ✅ MUST contain a summary of ALL changelog items of minor/patch version bumps, also for merges without a release
- ❌ Do NOT copy/paste the changelog entries verbatim
- ✅ Review and create human-friendly summarized content
- ⚠️ Consolidate related changes across minors into coherent themes
- 🎯 Highlight breaking changes and migration guidance
- 📊 Emphasize major improvements and new capabilities

##### For Patch Releases:
- ✅ Summarize changelog items from ALL patch versions since last GitHub release (not just the current patch)
- ⚠️ **IMPORTANT**: Multiple patch tags may exist without releases - you MUST combine all their changelog items
  - Example: If v0.5.1, v0.5.2, v0.5.3 all exist as tags but v0.5.0 was the last GitHub release, summarize changes from ALL three patches
  - Check `gh release list` to identify which versions have GitHub releases
  - Combine all changelog entries from unreleased patch versions
- ❌ Do NOT copy/paste the changelog entries verbatim
- ⚠️ Handle conflicts properly: If later patches fix issues from earlier patches, consolidate appropriately
- 🎯 Note: Patch releases can be manually initiated but typically don't get GitHub releases unless significant
- 📋 When multiple patches are combined, organize by theme rather than chronologically

#### Step 4: Format Release Notes

Use this format for all releases:

```markdown
## What's New in v[VERSION]

[2-3 paragraph human-readable summary that explains the overall theme,
purpose, and impact of this release. Write for non-technical users.]

### Key Improvements
- [Summarized theme 1: consolidate related features/fixes with user impact]
- [Summarized theme 2: group similar enhancements with benefits]
- [Summarized theme 3: highlight important changes with value proposition]

### Version Range
This release includes changes from v[START_VERSION] through v[END_VERSION].

---
Full changelog: [CHANGELOG.md](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/CHANGELOG.md)
```

#### Step 5: Create GitHub Release
Execute the release creation command:
```bash
gh release create v[VERSION] --title "Release [VERSION]" --notes "[formatted_summary]"
```

#### Step 6: Report Completion
Reply to the release issue with:
- ✅ Version number and type
- 🔗 Link to the created GitHub release
- 📋 Brief summary of included version range
- ✔️ Confirmation of guideline compliance

### Quality Standards

**Every release summary MUST:**
1. Be written in clear, simple language for non-technical users
2. Group related changes into meaningful themes
3. Explain the impact and value, not just what changed
4. Be 3-5 key points maximum (concise)
5. Handle conflicts intelligently (consolidate related changes)
6. Reference the full CHANGELOG.md for technical details

**Every release summary MUST NOT:**
1. Copy/paste raw changelog entries
2. Use technical jargon without explanation
3. List every minor detail
4. Mention issues that were introduced and fixed in the same release cycle
5. Exceed reasonable length (keep it scannable)
