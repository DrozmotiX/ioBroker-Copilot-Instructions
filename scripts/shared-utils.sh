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
        jq -r "$key" "$METADATA_FILE" 2>/dev/null || echo ""
    else
        # Fallback without jq
        case "$key" in
            ".version") 
                grep '"version"' "$METADATA_FILE" 2>/dev/null | sed 's/.*"version": *"//;s/".*//' || echo "0.4.0"
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