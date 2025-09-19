<!-- Version Management Commands Snippet -->
## Available Commands

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

## What the Scripts Do

These scripts ensure that:
- Version numbers are dynamically pulled from the template
- Documentation dates stay current
- All cross-references remain consistent
- Manual version updates are no longer needed