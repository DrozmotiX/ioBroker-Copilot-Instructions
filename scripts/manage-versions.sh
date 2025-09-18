#!/bin/bash
#
# Master Version Management Script for ioBroker Copilot Instructions
# 
# This script provides a unified way to manage versions across the repository.
# It can update template versions, sync documentation, and validate consistency.
#
# Usage: 
#   ./scripts/manage-versions.sh update [new_version]  - Update to new version
#   ./scripts/manage-versions.sh sync                  - Sync documentation with current template version
#   ./scripts/manage-versions.sh check                 - Check version consistency across files
#   ./scripts/manage-versions.sh show                  - Show current versions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_FILE="$REPO_ROOT/template.md"
README_FILE="$REPO_ROOT/README.md"
CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"
COPILOT_INSTRUCTIONS="$REPO_ROOT/.github/copilot-instructions.md"
EXTRACT_SCRIPT="$SCRIPT_DIR/extract-version.sh"
UPDATE_SCRIPT="$SCRIPT_DIR/update-versions.sh"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show current versions
show_versions() {
    echo -e "${BLUE}📋 Current Version Status:${NC}"
    echo ""
    
    if [[ -f "$TEMPLATE_FILE" ]]; then
        TEMPLATE_VER=$(grep "^**Version:**" "$TEMPLATE_FILE" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
        echo "📄 Template version: $TEMPLATE_VER"
    else
        echo -e "${RED}❌ Template file not found${NC}"
    fi
    
    if [[ -f "$COPILOT_INSTRUCTIONS" ]]; then
        COPILOT_VER=$(grep "^**Version:**" "$COPILOT_INSTRUCTIONS" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
        echo "🤖 Repository instructions version: $COPILOT_VER"
    else
        echo -e "${YELLOW}⚠️  Repository instructions not found${NC}"
    fi
    
    if [[ -f "$README_FILE" ]]; then
        README_VER=$(grep "Latest Version:" "$README_FILE" | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
        echo "📖 README documented version: $README_VER"
    fi
    
    echo "📅 Current date: $($EXTRACT_SCRIPT current-date)"
}

# Function to check version consistency
check_consistency() {
    echo -e "${BLUE}🔍 Checking Version Consistency:${NC}"
    echo ""
    
    TEMPLATE_VER=$(grep "^**Version:**" "$TEMPLATE_FILE" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
    README_VER=$(grep "Latest Version:" "$README_FILE" | head -1 | sed 's/.*Latest Version:\*\* v*//' | tr -d ' ')
    
    INCONSISTENT=false
    
    if [[ "$TEMPLATE_VER" != "$README_VER" ]]; then
        echo -e "${RED}❌ Version mismatch: Template ($TEMPLATE_VER) vs README ($README_VER)${NC}"
        INCONSISTENT=true
    else
        echo -e "${GREEN}✅ Template and README versions match ($TEMPLATE_VER)${NC}"
    fi
    
    # Check if dates are current
    CURRENT_DATE=$($EXTRACT_SCRIPT current-date)
    README_DATE=$(grep "Last Updated:" "$README_FILE" | head -1 | sed 's/.*Last Updated:\*\* *//')
    
    if [[ "$README_DATE" != "$CURRENT_DATE" ]]; then
        echo -e "${YELLOW}⚠️  Date may be outdated: README shows '$README_DATE', current is '$CURRENT_DATE'${NC}"
        INCONSISTENT=true
    else
        echo -e "${GREEN}✅ Documentation date is current${NC}"
    fi
    
    if [[ "$INCONSISTENT" == "true" ]]; then
        echo ""
        echo -e "${YELLOW}💡 Run './scripts/manage-versions.sh sync' to fix inconsistencies${NC}"
        return 1
    else
        echo -e "${GREEN}✅ All versions are consistent!${NC}"
        return 0
    fi
}

# Function to sync documentation with template version
sync_documentation() {
    echo -e "${BLUE}🔄 Syncing Documentation:${NC}"
    echo ""
    
    if [[ -f "$UPDATE_SCRIPT" ]]; then
        "$UPDATE_SCRIPT"
    else
        echo -e "${RED}❌ Update script not found: $UPDATE_SCRIPT${NC}"
        return 1
    fi
}

# Function to update to a new version
update_version() {
    local NEW_VERSION="$1"
    
    if [[ -z "$NEW_VERSION" ]]; then
        echo -e "${RED}❌ Please specify a new version (e.g., 0.3.2)${NC}"
        return 1
    fi
    
    # Validate version format
    if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}❌ Invalid version format. Use semantic versioning (e.g., 0.3.2)${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📦 Updating to version $NEW_VERSION:${NC}"
    echo ""
    
    # Update template
    if [[ -f "$TEMPLATE_FILE" ]]; then
        sed -i "s/^\*\*Version:\*\* [0-9\.]*/**Version:** $NEW_VERSION/" "$TEMPLATE_FILE"
        echo "✅ Updated template.md"
    fi
    
    # Update repository instructions 
    if [[ -f "$COPILOT_INSTRUCTIONS" ]]; then
        sed -i "s/^\*\*Version:\*\* [0-9\.]*/**Version:** $NEW_VERSION/" "$COPILOT_INSTRUCTIONS"
        echo "✅ Updated .github/copilot-instructions.md"
    fi
    
    # Sync documentation
    sync_documentation
    
    echo ""
    echo -e "${YELLOW}📝 Don't forget to update CHANGELOG.md with the changes for version $NEW_VERSION${NC}"
    echo -e "${YELLOW}📝 Consider creating a git tag: git tag v$NEW_VERSION${NC}"
}

# Main script logic
case "${1:-show}" in
    "show")
        show_versions
        ;;
    "check")
        check_consistency
        ;;
    "sync")
        sync_documentation
        ;;
    "update")
        update_version "$2"
        ;;
    *)
        echo "Usage: $0 {show|check|sync|update} [version]"
        echo ""
        echo "Commands:"
        echo "  show             - Show current versions across all files"
        echo "  check            - Check version consistency"
        echo "  sync             - Sync documentation with current template version"
        echo "  update <version> - Update to new version (e.g., update 0.3.2)"
        echo ""
        echo "Examples:"
        echo "  $0 show"
        echo "  $0 check"
        echo "  $0 sync"
        echo "  $0 update 0.3.2"
        exit 1
        ;;
esac