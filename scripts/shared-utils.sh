#!/bin/bash
#
# Shared utility functions for reading metadata and generating content
# 
# This script provides functions for accessing centralized metadata and snippets.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
METADATA_FILE="$REPO_ROOT/config/metadata.json"
SNIPPETS_DIR="$REPO_ROOT/snippets"

# Function to read metadata value
get_metadata() {
    local key="$1"
    if [[ -f "$METADATA_FILE" ]] && command -v jq >/dev/null 2>&1; then
        local result=$(jq -r "$key" "$METADATA_FILE" 2>/dev/null)
        if [[ "$result" == "null" ]] || [[ -z "$result" ]]; then
            echo "❌ Error: Could not extract key '$key' from metadata file" >&2
            return 1
        fi
        echo "$result"
    else
        # Fallback without jq
        case "$key" in
            ".version") 
                if [[ -f "$METADATA_FILE" ]]; then
                    grep '"version"' "$METADATA_FILE" 2>/dev/null | sed 's/.*"version": *"//;s/".*//' || {
                        echo "❌ Error: Could not extract version from metadata file" >&2
                        return 1
                    }
                else
                    echo "❌ Error: Metadata file not found: $METADATA_FILE" >&2
                    return 1
                fi
                ;;
            ".repository.url")
                echo "https://github.com/DrozmotiX/ioBroker-Copilot-Instructions"
                ;;
            ".repository.raw_base")
                echo "https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main"
                ;;
            *)
                echo ""
                ;;
        esac
    fi
}

# Function to get repository URL
get_repo_url() {
    get_metadata ".repository.url"
}

# Function to get raw repository base URL
get_raw_base_url() {
    get_metadata ".repository.raw_base"
}

# Function to get version
get_version() {
    get_metadata ".version"
}

# Function to get snippet content
get_snippet() {
    local snippet_name="$1"
    local snippet_file="$SNIPPETS_DIR/${snippet_name}.md"
    
    if [[ -f "$snippet_file" ]]; then
        cat "$snippet_file"
    else
        echo "<!-- Snippet '$snippet_name' not found -->"
    fi
}

# Function to generate version check command
get_version_check_command() {
    local raw_url="$(get_raw_base_url)"
    echo "curl -s ${raw_url}/scripts/check-template-version.sh | bash"
}

# Function to get component version
get_component_version() {
    local component_path="$1"
    if [[ -z "$component_path" ]]; then
        echo "❌ Error: Component path required" >&2
        return 1
    fi
    
    get_metadata ".components.${component_path}.version"
}

# Function to list all components
list_components() {
    if [[ -f "$METADATA_FILE" ]] && command -v jq >/dev/null 2>&1; then
        jq -r '.components | to_entries[] | "\(.key).\(.value | to_entries[] | "\(.key): \(.value.version) - \(.value.description)")"' "$METADATA_FILE" 2>/dev/null
    else
        echo "❌ Error: Cannot list components without jq or metadata file" >&2
        return 1
    fi
}

# Function to get template version (separate from main version)
get_template_version() {
    get_metadata ".template.version"
}

# Function to get version policy
get_version_policy() {
    local policy_key="$1"
    get_metadata ".version_policy.${policy_key}"
}

# Function to update component version
update_component_version() {
    local component_path="$1"
    local new_version="$2"
    
    if [[ -z "$component_path" || -z "$new_version" ]]; then
        echo "❌ Error: Component path and version required" >&2
        return 1
    fi
    
    if [[ -f "$METADATA_FILE" ]] && command -v jq >/dev/null 2>&1; then
        local temp_file=$(mktemp)
        if jq ".components.${component_path}.version = \"$new_version\"" "$METADATA_FILE" > "$temp_file" && mv "$temp_file" "$METADATA_FILE"; then
            echo "✅ Updated component $component_path to version $new_version"
            return 0
        else
            rm -f "$temp_file"
            echo "❌ Error: Failed to update component version" >&2
            return 1
        fi
    else
        echo "❌ Error: Cannot update component version without jq" >&2
        return 1
    fi
}

# Function to validate metadata file
validate_metadata() {
    if [[ ! -f "$METADATA_FILE" ]]; then
        echo "❌ Metadata file not found: $METADATA_FILE"
        return 1
    fi
    
    if command -v jq >/dev/null 2>&1; then
        if ! jq empty "$METADATA_FILE" 2>/dev/null; then
            echo "❌ Invalid JSON in metadata file: $METADATA_FILE"
            return 1
        fi
        
        # Validate main version matches template version
        local main_version=$(get_version)
        local template_version=$(get_template_version)
        if [[ "$main_version" != "$template_version" ]]; then
            echo "❌ Main version ($main_version) must match template version ($template_version)"
            return 1
        fi
    fi
    
    echo "✅ Metadata file is valid"
    return 0
}

# Function to show all metadata
show_metadata() {
    echo "📋 Repository Metadata:"
    echo "  Version: $(get_version)"
    echo "  Repository URL: $(get_repo_url)"
    echo "  Raw Base URL: $(get_raw_base_url)"
    echo "  Metadata file: $METADATA_FILE"
    echo "  Snippets directory: $SNIPPETS_DIR"
}