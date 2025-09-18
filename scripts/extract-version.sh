#!/bin/bash
#
# Version Extraction Script for ioBroker Copilot Instructions
# 
# This script extracts version and date information from the template
# for use in documentation generation and validation.
#
# Usage: ./scripts/extract-version.sh [template|current-year|current-month]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_FILE="$REPO_ROOT/template.md"

# Function to extract template version
get_template_version() {
    if [[ -f "$TEMPLATE_FILE" ]]; then
        grep "^**Version:**" "$TEMPLATE_FILE" | head -1 | sed 's/.*Version:\*\* *//' | tr -d ' '
    else
        echo "unknown"
    fi
}

# Function to get current year
get_current_year() {
    date +"%Y"
}

# Function to get current month name
get_current_month() {
    date +"%B"
}

# Function to get current date in format "Month YYYY"
get_current_date() {
    date +"%B %Y"
}

# Main script logic
case "${1:-template}" in
    "template")
        get_template_version
        ;;
    "current-year")
        get_current_year
        ;;
    "current-month")
        get_current_month
        ;;
    "current-date")
        get_current_date
        ;;
    *)
        echo "Usage: $0 [template|current-year|current-month|current-date]"
        echo "  template     - Extract version from template.md"
        echo "  current-year - Get current year"
        echo "  current-month - Get current month name"
        echo "  current-date - Get current date in 'Month YYYY' format"
        exit 1
        ;;
esac