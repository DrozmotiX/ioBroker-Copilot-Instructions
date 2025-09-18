#!/bin/bash
#
# Update Documentation with Dynamic Versions
# 
# This script updates version references in documentation files to use
# dynamic values from the template instead of hardcoded values.
#
# Usage: ./scripts/update-versions.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
README_FILE="$REPO_ROOT/README.md"
EXTRACT_SCRIPT="$SCRIPT_DIR/extract-version.sh"

echo "🔄 Updating documentation versions..."

# Check if extract script exists
if [[ ! -f "$EXTRACT_SCRIPT" ]]; then
    echo "❌ Version extraction script not found: $EXTRACT_SCRIPT"
    exit 1
fi

# Get dynamic values
TEMPLATE_VERSION=$($EXTRACT_SCRIPT template)
CURRENT_DATE=$($EXTRACT_SCRIPT current-date)

if [[ -z "$TEMPLATE_VERSION" || "$TEMPLATE_VERSION" == "unknown" ]]; then
    echo "❌ Could not extract template version"
    exit 1
fi

echo "📄 Template version: $TEMPLATE_VERSION"
echo "📅 Current date: $CURRENT_DATE"

# Create a temporary file for updates
TEMP_README=$(mktemp)

# Update README.md with dynamic versions
sed \
    -e "s/# Keep project-specific content and add version: [0-9\.]*\"/# Keep project-specific content and add version: $TEMPLATE_VERSION\"/" \
    -e "s/- \*\*Latest Version:\*\* v[0-9\.]*$/- **Latest Version:** v$TEMPLATE_VERSION/" \
    -e "s/- \*\*Last Updated:\*\* [A-Za-z]* [0-9]*$/- **Last Updated:** $CURRENT_DATE/" \
    -e "s/\*\*Version:\*\* [0-9\.]*$/**Version:** $TEMPLATE_VERSION/" \
    "$README_FILE" > "$TEMP_README"

# Check if changes were made
if cmp -s "$README_FILE" "$TEMP_README"; then
    echo "ℹ️  No changes needed - versions already up to date"
    rm "$TEMP_README"
else
    # Apply changes
    mv "$TEMP_README" "$README_FILE"
    echo "✅ Updated version references in README.md"
    echo "   Version: $TEMPLATE_VERSION"
    echo "   Date: $CURRENT_DATE"
fi

echo ""
echo "🏁 Version update complete!"