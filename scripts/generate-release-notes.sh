#!/bin/bash
#
# Release Notes Data Extractor for ioBroker Copilot Instructions
# 
# This script extracts changelog data from CHANGELOG.md for processing.
# Human-readable summarization is handled by Copilot.
#
# Usage: 
#   ./scripts/generate-release-notes.sh <version>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"

# Function to parse version components
parse_version() {
    local version="$1"
    echo "$version" | sed 's/^v//' | tr '.' ' '
}

# Function to get version type (patch, minor, major)
get_version_type() {
    local current_version="$1"
    local previous_version="$2"
    
    if [[ -z "$previous_version" || "$previous_version" == "unknown" ]]; then
        echo "initial"
        return
    fi
    
    read -r curr_major curr_minor curr_patch <<< $(parse_version "$current_version")
    read -r prev_major prev_minor prev_patch <<< $(parse_version "$previous_version")
    
    if [[ "$curr_major" -gt "$prev_major" ]]; then
        echo "major"
    elif [[ "$curr_minor" -gt "$prev_minor" ]]; then
        echo "minor"
    else
        echo "patch"
    fi
}

# Function to extract changelog entries for a specific version
extract_version_changelog() {
    # Escape regex metacharacters in version so it is treated literally in the regex
    local escaped_version
    escaped_version="$(printf '%s\n' "$version" | sed 's/[][\.^$*+?{}|()]/\\&/g')"
    local in_version=false
    local entries=""
    
    while IFS= read -r line; do
        # Check if we're starting the target version section
        if [[ "$line" =~ ^\#\#[[:space:]]\[?${escaped_version}\]? ]]; then
            in_version=true
            continue
        fi
        
        if [[ "$in_version" == true ]] && [[ "$line" =~ ^\#\#[[:space:]]\[?[0-9]+\.[0-9]+\.[0-9]+\]? ]]; then
            break
        fi
        
        if [[ "$in_version" == true ]] && [[ "$line" =~ ^-[[:space:]]\( ]]; then
            entries+="$line"$'\n'
        fi
    done < "$CHANGELOG_FILE"
    
    echo "$entries"
}

# Function to get all versions in a range
get_versions_in_range() {
    local start_version="$1"
    local end_version="$2"
    local range_type="$3"
    
    local versions=()
    local in_range=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\#\#[[:space:]]\[([0-9]+\.[0-9]+\.[0-9]+)\] ]]; then
            local ver="${BASH_REMATCH[1]}"
            
            if [[ "$ver" == "$end_version" ]]; then
                in_range=true
                continue
            fi
            
            if [[ "$in_range" == true ]]; then
                read -r v_major v_minor v_patch <<< $(parse_version "$ver")
                read -r s_major s_minor s_patch <<< $(parse_version "$start_version")
                
                if [[ "$range_type" == "patch" ]]; then
                    if [[ "$v_major" == "$s_major" && "$v_minor" == "$s_minor" ]]; then
                        versions+=("$ver")
                    else
                        break
                    fi
                elif [[ "$range_type" == "minor" ]]; then
                    if [[ "$v_major" == "$s_major" ]]; then
                        if [[ "$v_patch" == "0" ]]; then
                            versions+=("$ver")
                        fi
                    else
                        break
                    fi
                fi
            fi
        fi
    done < "$CHANGELOG_FILE"
    
    printf '%s\n' "${versions[@]}"
}

# Function to get previous version from CHANGELOG
get_previous_version() {
    local current_version="$1"
    local found_current=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\#\#[[:space:]]\[([0-9]+\.[0-9]+\.[0-9]+)\] ]]; then
            local ver="${BASH_REMATCH[1]}"
            
            if [[ "$found_current" == true ]]; then
                echo "$ver"
                return
            fi
            
            if [[ "$ver" == "$current_version" ]]; then
                found_current=true
            fi
        fi
    done < "$CHANGELOG_FILE"
    
    echo "unknown"
}

# Main script logic
main() {
    local version="${1}"
    
    if [[ -z "$version" ]]; then
        echo "Error: Version parameter required"
        exit 1
    fi
    
    version="${version#v}"
    
    if [[ ! -f "$CHANGELOG_FILE" ]]; then
        echo "Error: CHANGELOG.md not found"
        exit 1
    fi
    
    local previous_version=$(get_previous_version "$version")
    local version_type=$(get_version_type "$version" "$previous_version")
    
    # Output data for processing
    case "$version_type" in
        "major")
            echo "## Version $version - Major Release"
            echo ""
            echo "### Changes in $version"
            echo ""
            extract_version_changelog "$version"
            echo ""
            
            read -r curr_major curr_minor curr_patch <<< $(parse_version "$version")
            local prev_major_version="$((curr_major - 1)).0.0"
            local minor_versions=$(get_versions_in_range "$prev_major_version" "$version" "minor")
            
            if [[ -n "$minor_versions" ]]; then
                echo "### All Minor Releases Since v$prev_major_version"
                echo ""
                while IFS= read -r minor_ver; do
                    if [[ -n "$minor_ver" ]]; then
                        echo "#### Version $minor_ver"
                        echo ""
                        extract_version_changelog "$minor_ver"
                        echo ""
                    fi
                done <<< "$minor_versions"
            fi
            ;;
            
        "minor")
            echo "## Version $version - Minor Release"
            echo ""
            echo "### Changes in $version"
            echo ""
            extract_version_changelog "$version"
            echo ""
            
            read -r curr_major curr_minor curr_patch <<< $(parse_version "$version")
            local prev_minor_version="${curr_major}.$((curr_minor - 1)).0"
            local patch_versions=$(get_versions_in_range "$prev_minor_version" "$version" "patch")
            
            if [[ -n "$patch_versions" ]]; then
                echo "### All Patch Releases Since v$prev_minor_version"
                echo ""
                while IFS= read -r patch_ver; do
                    if [[ -n "$patch_ver" ]]; then
                        echo "#### Version $patch_ver"
                        echo ""
                        extract_version_changelog "$patch_ver"
                        echo ""
                    fi
                done <<< "$patch_versions"
            fi
            ;;
            
        "patch"|"initial")
            echo "## Version $version - Patch Release"
            echo ""
            echo "Patch releases do not require GitHub releases."
            ;;
    esac
}

main "$@"
