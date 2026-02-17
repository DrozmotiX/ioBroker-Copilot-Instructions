#!/bin/bash
#
# Release Notes Generator Script for ioBroker Copilot Instructions
# 
# This script generates human-readable release notes from CHANGELOG.md
# with automatic aggregation for minor and major releases.
#
# Usage: 
#   ./scripts/generate-release-notes.sh <version>
#
# Example:
#   ./scripts/generate-release-notes.sh 0.5.3  # Generates notes for patch release
#   ./scripts/generate-release-notes.sh 0.6.0  # Generates notes with all patches since 0.5.x
#   ./scripts/generate-release-notes.sh 1.0.0  # Generates notes with all minors since 0.x.x

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
    local version="$1"
    local in_version=false
    local entries=""
    
    while IFS= read -r line; do
        # Check if we're starting the target version section
        if [[ "$line" =~ ^\#\#[[:space:]]\[?${version}\]? ]]; then
            in_version=true
            continue
        fi
        
        # Stop if we hit the next version section
        if [[ "$in_version" == true ]] && [[ "$line" =~ ^\#\#[[:space:]]\[?[0-9]+\.[0-9]+\.[0-9]+\]? ]]; then
            break
        fi
        
        # Collect entries
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
    local range_type="$3"  # "patch" or "minor"
    
    local versions=()
    local in_range=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\#\#[[:space:]]\[([0-9]+\.[0-9]+\.[0-9]+)\] ]]; then
            local ver="${BASH_REMATCH[1]}"
            
            # Start collecting when we hit the end version
            if [[ "$ver" == "$end_version" ]]; then
                in_range=true
                continue  # Don't include the end version itself
            fi
            
            if [[ "$in_range" == true ]]; then
                read -r v_major v_minor v_patch <<< $(parse_version "$ver")
                read -r s_major s_minor s_patch <<< $(parse_version "$start_version")
                
                # For minor releases, collect all patches from previous minor versions
                if [[ "$range_type" == "patch" ]]; then
                    if [[ "$v_major" == "$s_major" && "$v_minor" == "$s_minor" ]]; then
                        versions+=("$ver")
                    else
                        break  # Stop when major or minor changes
                    fi
                # For major releases, collect all minor releases from previous major versions
                elif [[ "$range_type" == "minor" ]]; then
                    if [[ "$v_major" == "$s_major" ]]; then
                        # Only include versions that represent minor releases (x.y.0)
                        if [[ "$v_patch" == "0" ]]; then
                            versions+=("$ver")
                        fi
                    else
                        break  # Stop when major changes
                    fi
                fi
            fi
        fi
    done < "$CHANGELOG_FILE"
    
    printf '%s\n' "${versions[@]}"
}

# Function to categorize and count changelog entries
categorize_changes() {
    local entries="$1"
    local new_count=0
    local enhanced_count=0
    local fixed_count=0
    local testing_count=0
    local ci_cd_count=0
    local other_count=0
    
    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            continue
        fi
        
        if [[ "$line" =~ \*\*NEW\*\* ]]; then
            ((new_count++))
        elif [[ "$line" =~ \*\*ENHANCED\*\* ]]; then
            ((enhanced_count++))
        elif [[ "$line" =~ \*\*FIXED\*\* ]]; then
            ((fixed_count++))
        elif [[ "$line" =~ \*\*TESTING\*\* ]]; then
            ((testing_count++))
        elif [[ "$line" =~ \*\*CI/CD\*\* ]]; then
            ((ci_cd_count++))
        else
            ((other_count++))
        fi
    done <<< "$entries"
    
    echo "new=$new_count enhanced=$enhanced_count fixed=$fixed_count testing=$testing_count cicd=$ci_cd_count other=$other_count"
}

# Function to generate a human-readable summary
generate_summary() {
    local stats="$1"
    local summary=""
    
    # Parse stats
    eval "$stats"
    
    local total=$((new + enhanced + fixed + testing + cicd + other))
    
    if [[ $total -eq 0 ]]; then
        echo "No changes documented for this release."
        return
    fi
    
    summary="This release includes **$total changes**:"
    
    [[ $new -gt 0 ]] && summary+=" 🎉 $new new feature"
    [[ $new -gt 1 ]] && summary+="s"
    
    if [[ $enhanced -gt 0 ]]; then
        [[ $new -gt 0 ]] && summary+=","
        summary+=" ✨ $enhanced enhancement"
        [[ $enhanced -gt 1 ]] && summary+="s"
    fi
    
    if [[ $fixed -gt 0 ]]; then
        [[ $((new + enhanced)) -gt 0 ]] && summary+=","
        summary+=" 🐛 $fixed bug fix"
        [[ $fixed -gt 1 ]] && summary+="es"
    fi
    
    if [[ $testing -gt 0 ]]; then
        [[ $((new + enhanced + fixed)) -gt 0 ]] && summary+=","
        summary+=" 🧪 $testing testing improvement"
        [[ $testing -gt 1 ]] && summary+="s"
    fi
    
    if [[ $cicd -gt 0 ]]; then
        [[ $((new + enhanced + fixed + testing)) -gt 0 ]] && summary+=","
        summary+=" 🔧 $ci_cd_count CI/CD update"
        [[ $ci_cd_count -gt 1 ]] && summary+="s"
    fi
    
    summary+="."
    
    echo "$summary"
}

# Function to generate aggregated notes for minor releases
generate_minor_release_notes() {
    local version="$1"
    local previous_version="$2"
    
    echo "## 📦 Version $version - Minor Release"
    echo ""
    
    # Get current version changelog
    local current_entries=$(extract_version_changelog "$version")
    
    if [[ -n "$current_entries" ]]; then
        local stats=$(categorize_changes "$current_entries")
        local summary=$(generate_summary "$stats")
        
        echo "$summary"
        echo ""
        echo "### What's New in $version"
        echo ""
        echo "$current_entries"
    fi
    
    # Get all patch versions since last minor
    read -r curr_major curr_minor curr_patch <<< $(parse_version "$version")
    local prev_minor_version="${curr_major}.$((curr_minor - 1)).0"
    
    local patch_versions=$(get_versions_in_range "$prev_minor_version" "$version" "patch")
    
    if [[ -n "$patch_versions" ]]; then
        echo ""
        echo "### 📝 Summary of Patches Since Last Minor Release"
        echo ""
        
        while IFS= read -r patch_ver; do
            if [[ -n "$patch_ver" ]]; then
                echo "#### Version $patch_ver"
                local patch_entries=$(extract_version_changelog "$patch_ver")
                if [[ -n "$patch_entries" ]]; then
                    local patch_stats=$(categorize_changes "$patch_entries")
                    echo "$(generate_summary "$patch_stats")"
                    echo ""
                fi
            fi
        done <<< "$patch_versions"
    fi
}

# Function to generate aggregated notes for major releases
generate_major_release_notes() {
    local version="$1"
    local previous_version="$2"
    
    echo "## 🚀 Version $version - Major Release"
    echo ""
    
    # Get current version changelog
    local current_entries=$(extract_version_changelog "$version")
    
    if [[ -n "$current_entries" ]]; then
        local stats=$(categorize_changes "$current_entries")
        local summary=$(generate_summary "$stats")
        
        echo "$summary"
        echo ""
        echo "### 🎯 Major Changes in $version"
        echo ""
        echo "$current_entries"
    fi
    
    # Get all minor versions since last major
    read -r curr_major curr_minor curr_patch <<< $(parse_version "$version")
    local prev_major_version="$((curr_major - 1)).0.0"
    
    local minor_versions=$(get_versions_in_range "$prev_major_version" "$version" "minor")
    
    if [[ -n "$minor_versions" ]]; then
        echo ""
        echo "### 📝 Summary of Minor Releases Since Last Major Release"
        echo ""
        
        while IFS= read -r minor_ver; do
            if [[ -n "$minor_ver" ]]; then
                echo "#### Version $minor_ver"
                local minor_entries=$(extract_version_changelog "$minor_ver")
                if [[ -n "$minor_entries" ]]; then
                    local minor_stats=$(categorize_changes "$minor_entries")
                    echo "$(generate_summary "$minor_stats")"
                    echo ""
                fi
            fi
        done <<< "$minor_versions"
    fi
}

# Function to generate patch release notes
generate_patch_release_notes() {
    local version="$1"
    
    echo "## 🔧 Version $version - Patch Release"
    echo ""
    
    local entries=$(extract_version_changelog "$version")
    
    if [[ -n "$entries" ]]; then
        local stats=$(categorize_changes "$entries")
        local summary=$(generate_summary "$stats")
        
        echo "$summary"
        echo ""
        echo "### Changes"
        echo ""
        echo "$entries"
    else
        echo "No changes documented for this release."
    fi
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
        echo "Usage: $0 <version>"
        echo "Example: $0 0.5.3"
        exit 1
    fi
    
    # Remove 'v' prefix if present
    version="${version#v}"
    
    # Check if CHANGELOG.md exists
    if [[ ! -f "$CHANGELOG_FILE" ]]; then
        echo "Error: CHANGELOG.md not found at $CHANGELOG_FILE"
        exit 1
    fi
    
    # Get previous version
    local previous_version=$(get_previous_version "$version")
    
    # Determine version type
    local version_type=$(get_version_type "$version" "$previous_version")
    
    # Generate appropriate release notes
    case "$version_type" in
        "major")
            generate_major_release_notes "$version" "$previous_version"
            ;;
        "minor")
            generate_minor_release_notes "$version" "$previous_version"
            ;;
        "patch"|"initial")
            generate_patch_release_notes "$version"
            ;;
    esac
    
    # Add footer
    echo ""
    echo "---"
    echo ""
    echo "📖 **Full Changelog**: See [CHANGELOG.md](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/CHANGELOG.md) for complete details."
    
    if [[ "$previous_version" != "unknown" ]]; then
        echo ""
        echo "**Previous version**: $previous_version"
    fi
}

main "$@"
