# Centralized Configuration and Snippets

This directory contains the centralized configuration and reusable content snippets for the ioBroker Copilot Instructions repository.

## Directory Structure

```
config/
├── metadata.json          # Centralized repository metadata and configuration
└── README.md             # This file

snippets/
├── version-check-command.md          # Reusable version check command
├── github-action-version-check.yml   # GitHub Action template for version monitoring  
└── version-management-commands.md    # Version management script commands
```

## Metadata Configuration (metadata.json)

The `metadata.json` file serves as the single source of truth for:

- **Version Information**: Current template version
- **Repository URLs**: GitHub repository and raw content URLs
- **Script Paths**: Locations of management scripts
- **Automation Config**: GitHub Action settings and schedules

### Schema

```json
{
  "version": "X.Y.Z",                    // Current template version
  "repository": {
    "url": "https://github.com/...",     // Repository homepage URL
    "raw_base": "https://raw.github..." // Raw content base URL  
  },
  "template": {
    "file": "template.md",               // Template filename
    "target_path": ".github/..."        // Target installation path
  },
  "scripts": {
    "check_template_version": "scripts/...", // Version check script path
    "manage_versions": "scripts/..."         // Version management script path
  },
  "automation": {
    "workflow_file": ".github/workflows/...", // GitHub Action filename
    "cron_schedule": "23 3 * * 0",            // Optimized weekly schedule (off-peak hours)
    "labels": ["template-update", ...]       // Issue labels
  }
}
```

## Reusable Snippets

### Version Check Command (`version-check-command.md`)

Contains the standardized curl command for checking template versions. Referenced throughout documentation instead of duplicating the command.

**Usage in Documentation**:
```markdown
<!-- Include version check instructions -->
```

### GitHub Action Template (`github-action-version-check.yml`)

Complete GitHub Action workflow for automated template version monitoring. Used by templates and documentation instead of duplicating the YAML.

**Features**:
- Weekly automated checks
- Automatic issue creation
- Custom content preservation
- Both setup and update scenarios

### Version Management Commands (`version-management-commands.md`)

Standard documentation for the version management script commands and their functions.

## Integration with Scripts

The centralized metadata is used by:

- **`scripts/shared-utils.sh`**: Utility functions for accessing metadata
- **`scripts/extract-version.sh`**: Enhanced with metadata fallback
- **`scripts/manage-versions.sh`**: Updates metadata when versions change
- **`scripts/check-template-version.sh`**: Uses metadata for URL generation

## Benefits of Centralization

### Before (Duplicated Content)
- Version check curl command duplicated in 6+ files
- GitHub Action YAML duplicated in 3+ files
- Version management instructions repeated across docs
- Manual updates required in multiple locations

### After (Centralized System)
- **Single Source of Truth**: All metadata in one place
- **Automatic Consistency**: Scripts sync versions across files
- **Reusable Snippets**: Documentation references shared content
- **Easier Maintenance**: Update once, apply everywhere
- **Version Validation**: Automated consistency checking

## Validation and Testing

The centralized system includes:

- **JSON Schema Validation**: Metadata file structure validation
- **Consistency Checks**: Version synchronization across files
- **Integration Tests**: Script and documentation integration
- **GitHub Action**: Automated validation in CI/CD
- **Comprehensive Test Suite**: `tests/test-centralized-metadata.sh`

## Usage for Documentation

When writing documentation, reference snippets instead of duplicating content:

```markdown
### Version Check

Use our [version check command](https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/version-check-command.md).

### GitHub Action Setup  

For automated monitoring, see our [GitHub Action template](https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/github-action-version-check.yml).
```

## Updating the System

### Adding New Metadata
1. Update `config/metadata.json` with new fields
2. Update `scripts/shared-utils.sh` accessor functions
3. Add validation to `tests/test-centralized-metadata.sh`
4. Update this README with schema documentation

### Creating New Snippets
1. Create snippet file in `snippets/` directory
2. Update documentation to reference the snippet
3. Remove duplicated content from existing files
4. Add tests for snippet usage and content

### Version Updates
Use the centralized version management:
```bash
./scripts/manage-versions.sh update X.Y.Z
```

This automatically updates:
- `config/metadata.json`
- `template.md`
- `package.json`
- All derived documentation