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
PACKAGE_FILE="$REPO_ROOT/package.json"
COPILOT_INSTRUCTIONS="$REPO_ROOT/.github/copilot-instructions.md"
METADATA_FILE="$REPO_ROOT/config/metadata.json"
EXTRACT_SCRIPT="$SCRIPT_DIR/extract-version.sh"
UPDATE_SCRIPT="$SCRIPT_DIR/update-versions.sh"

# Source shared utilities
source "$SCRIPT_DIR/shared-utils.sh"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to compare versions (returns 0 if v1 > v2, 1 if v1 <= v2)
version_greater_than() {
    local v1="$1"
    local v2="$2"
    
    # Handle empty versions
    if [[ -z "$v1" || -z "$v2" ]]; then
        return 1
    fi
    
    # Split versions into arrays
    IFS='.' read -ra V1 <<< "$v1"
    IFS='.' read -ra V2 <<< "$v2"
    
    # Compare each part
    for i in {0..2}; do
        local part1=${V1[i]:-0}
        local part2=${V2[i]:-0}
        
        if [[ $part1 -gt $part2 ]]; then
            return 0
        elif [[ $part1 -lt $part2 ]]; then
            return 1
        fi
    done
    
    # Versions are equal
    return 1
}

# Function to show current versions
show_versions() {
    echo -e "${BLUE}📋 Current Version Status:${NC}"
    echo ""
    
    # Main version information
    echo -e "${YELLOW}🏗️  Main Package Version:${NC}"
    MAIN_VER=$(get_version)
    echo "   Main version: $MAIN_VER"
    
    if [[ -f "$TEMPLATE_FILE" ]]; then
        TEMPLATE_VER=$(grep "^**Version:**" "$TEMPLATE_FILE" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
        echo "   Template version: $TEMPLATE_VER"
        
        if [[ "$MAIN_VER" != "$TEMPLATE_VER" ]]; then
            echo -e "   ${RED}⚠️  Main version should match template version${NC}"
        fi
    else
        echo -e "   ${RED}❌ Template file not found${NC}"
    fi
    
    if [[ -f "$PACKAGE_FILE" ]]; then
        PACKAGE_VER=$(grep '"version":' "$PACKAGE_FILE" | head -1 | sed 's/.*"version": *"//;s/",\?.*$//' | tr -d ' ')
        echo "   Package.json version: $PACKAGE_VER"
    else
        echo -e "   ${YELLOW}⚠️  Package.json not found${NC}"
    fi
    
    # Component versions
    echo ""
    echo -e "${YELLOW}🔧 Component Versions:${NC}"
    
    if command -v jq >/dev/null 2>&1 && [[ -f "$METADATA_FILE" ]]; then
        # GitHub Actions
        echo -e "${BLUE}  GitHub Actions:${NC}"
        jq -r '.components.github_actions | to_entries[] | "    \(.key): \(.value.version) (\(.value.description))"' "$METADATA_FILE" 2>/dev/null || echo "    No GitHub Actions found"
        
        # Templates  
        echo -e "${BLUE}  Templates:${NC}"
        jq -r '.components.templates | to_entries[] | "    \(.key): \(.value.version) (\(.value.description))"' "$METADATA_FILE" 2>/dev/null || echo "    No templates found"
        
        # Snippets
        echo -e "${BLUE}  Snippets:${NC}"
        jq -r '.components.snippets | to_entries[] | "    \(.key): \(.value.version) (\(.value.description))"' "$METADATA_FILE" 2>/dev/null || echo "    No snippets found"
    else
        echo "    Cannot display component versions (jq not available or metadata missing)"
    fi
    
    # Additional status information
    echo ""
    if [[ -f "$COPILOT_INSTRUCTIONS" ]]; then
        COPILOT_VER=$(grep "^**Version:**" "$COPILOT_INSTRUCTIONS" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
        echo "🤖 Repository instructions version: $COPILOT_VER"
    else
        echo -e "${YELLOW}⚠️  Repository instructions not found${NC}"
    fi
    
    if [[ -f "$README_FILE" ]]; then
        # Attempt to extract version from README badge or version string
        README_VER=$(grep -Eo 'version-[0-9]+\.[0-9]+\.[0-9]+' "$README_FILE" | head -1 | sed 's/version-//')
        if [[ -n "$README_VER" ]]; then
            echo "📖 README version (from badge): $README_VER"
        else
            echo "📖 README uses GitHub badge for version display (auto-updated)"
        fi
    fi
    
    # Show metadata version
    METADATA_VER=$(get_version)
    echo "⚙️  Centralized metadata version: $METADATA_VER"
    
    echo "📅 Current date: $($EXTRACT_SCRIPT current-date)"
}

# Function to check version consistency
check_consistency() {
    echo -e "${BLUE}🔍 Checking Version Consistency:${NC}"
    echo ""
    
    TEMPLATE_VER=$(grep "^**Version:**" "$TEMPLATE_FILE" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' ')
    METADATA_VER=$(get_version)
    
    if [[ -f "$PACKAGE_FILE" ]]; then
        PACKAGE_VER=$(grep '"version":' "$PACKAGE_FILE" | head -1 | sed 's/.*"version": *"//;s/",\?.*$//' | tr -d ' ')
    fi
    
    INCONSISTENT=false
    
    # Check template vs metadata consistency
    if [[ "$TEMPLATE_VER" != "$METADATA_VER" ]]; then
        echo -e "${RED}❌ Version mismatch: Template ($TEMPLATE_VER) vs Metadata ($METADATA_VER)${NC}"
        INCONSISTENT=true
    else
        echo -e "${GREEN}✅ Template and metadata versions match ($TEMPLATE_VER)${NC}"
    fi
    
    # Check package.json version consistency
    if [[ -f "$PACKAGE_FILE" && -n "$PACKAGE_VER" ]]; then
        if [[ "$TEMPLATE_VER" != "$PACKAGE_VER" ]]; then
            echo -e "${RED}❌ Version mismatch: Template ($TEMPLATE_VER) vs Package.json ($PACKAGE_VER)${NC}"
            INCONSISTENT=true
        else
            echo -e "${GREEN}✅ Template and package.json versions match ($TEMPLATE_VER)${NC}"
        fi
    fi
    
    # NOTE: README uses GitHub badge for version display, no manual date maintenance required
    echo -e "${GREEN}📖 README uses auto-updating GitHub badge${NC}"
    
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

# Function to update metadata file version
update_metadata_version() {
    local NEW_VERSION="$1"
    
    if [[ -f "$METADATA_FILE" ]]; then
        if command -v jq >/dev/null 2>&1; then
            # Use jq for precise JSON updates
            local TEMP_FILE=$(mktemp)
            # Update both main version and template version together
            jq ".version = \"$NEW_VERSION\" | .template.version = \"$NEW_VERSION\"" "$METADATA_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$METADATA_FILE"
            echo "✅ Updated metadata.json (main and template version)"
        else
            # Fallback sed replacement for both versions
            sed -i "s/\"version\": \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/\"version\": \"$NEW_VERSION\"/" "$METADATA_FILE"
            echo "✅ Updated metadata.json (using sed)"
        fi
    else
        echo "⚠️  Metadata file not found: $METADATA_FILE"
    fi
}
# Function to update component version
update_component_version_cmd() {
    local COMPONENT_PATH="$1"
    local NEW_VERSION="$2"
    
    if [[ -z "$COMPONENT_PATH" || -z "$NEW_VERSION" ]]; then
        echo -e "${RED}❌ Usage: update-component <component_path> <new_version>${NC}"
        echo "Example: update-component github_actions.weekly_version_check 0.3.0"
        return 1
    fi
    
    # Validate version format
    if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}❌ Invalid version format. Use semantic versioning (e.g., 0.3.0)${NC}"
        return 1
    fi
    
    # Get current version for comparison
    local CURRENT_VERSION=$(get_component_version "$COMPONENT_PATH")
    if [[ -n "$CURRENT_VERSION" ]]; then
        if ! version_greater_than "$NEW_VERSION" "$CURRENT_VERSION"; then
            echo -e "${RED}❌ New version ($NEW_VERSION) must be higher than current version ($CURRENT_VERSION)${NC}"
            return 1
        fi
    fi
    
    # Update the component version
    if update_component_version "$COMPONENT_PATH" "$NEW_VERSION"; then
        echo -e "${GREEN}✅ Component $COMPONENT_PATH updated to $NEW_VERSION${NC}"
    else
        echo -e "${RED}❌ Failed to update component version${NC}"
        return 1
    fi
}

# Function to list all component versions
list_component_versions() {
    echo -e "${BLUE}📦 Component Version Listing:${NC}"
    echo ""
    
    if list_components; then
        echo ""
        echo -e "${YELLOW}💡 To update a component version:${NC}"
        echo "   $0 update-component <component_path> <new_version>"
        echo "   Example: $0 update-component github_actions.weekly_version_check 0.3.0"
    else
        echo -e "${RED}❌ Failed to list components${NC}"
        return 1
    fi
}

# Function to validate version increment policy
validate_version_increment() {
    local COMPONENT_TYPE="$1"  # main, template, or component_path
    local OLD_VERSION="$2"
    local NEW_VERSION="$3"
    
    if [[ -z "$OLD_VERSION" || -z "$NEW_VERSION" ]]; then
        echo -e "${YELLOW}⚠️  Cannot validate version increment - missing version information${NC}"
        return 0  # Allow if we can't validate
    fi
    
    if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
        echo -e "${YELLOW}⚠️  Version unchanged ($NEW_VERSION)${NC}"
        return 0
    fi
    
    if ! version_greater_than "$NEW_VERSION" "$OLD_VERSION"; then
        echo -e "${RED}❌ Version increment violation: $NEW_VERSION is not higher than $OLD_VERSION${NC}"
        echo -e "${RED}   Policy requires all version changes to be incremental${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Version increment valid: $OLD_VERSION → $NEW_VERSION${NC}"
    return 0
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
    
    # Get current version and validate increment
    local CURRENT_VERSION=$(get_version)
    if ! validate_version_increment "main" "$CURRENT_VERSION" "$NEW_VERSION"; then
        return 1
    fi
    
    echo -e "${BLUE}📦 Updating to version $NEW_VERSION:${NC}"
    echo ""
    
    # Update centralized metadata first (both main and template version)
    update_metadata_version "$NEW_VERSION"
    
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
    
    # Update package.json
    if [[ -f "$PACKAGE_FILE" ]]; then
        sed -i "s/\"version\": \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/\"version\": \"$NEW_VERSION\"/" "$PACKAGE_FILE"
        echo "✅ Updated package.json"
    fi
    
    # Sync documentation
    sync_documentation
    
    echo ""
    echo -e "${YELLOW}📝 Don't forget to update CHANGELOG.md with the changes for version $NEW_VERSION${NC}"
    echo -e "${YELLOW}📝 Consider creating a git tag: git tag v$NEW_VERSION${NC}"
    echo -e "${YELLOW}🚀 Main version change will trigger automated deployment workflow${NC}"
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
    "update-component")
        update_component_version_cmd "$2" "$3"
        ;;
    "list-components")
        list_component_versions
        ;;
    "validate-increment")
        validate_version_increment "$2" "$3" "$4"
        ;;
    *)
        echo "Usage: $0 {show|check|sync|update|update-component|list-components|validate-increment} [options]"
        echo ""
        echo "Commands:"
        echo "  show                                    - Show current versions across all files"
        echo "  check                                   - Check version consistency"
        echo "  sync                                    - Sync documentation with current template version"
        echo "  update <version>                        - Update main version (e.g., update 0.3.2)"
        echo "  update-component <component> <version>  - Update component version"
        echo "  list-components                         - List all components with versions"
        echo "  validate-increment <type> <old> <new>  - Validate version increment policy"
        echo ""
        echo "Examples:"
        echo "  $0 show"
        echo "  $0 check"
        echo "  $0 sync"
        echo "  $0 update 0.3.2"
        echo "  $0 update-component github_actions.weekly_version_check 0.3.0"
        echo "  $0 list-components"
        exit 1
        ;;
esac