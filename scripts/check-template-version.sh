#!/bin/bash
#
# Template Version Check Script for ioBroker Copilot Instructions
# 
# This script helps verify if your local copilot-instructions.md template
# is up-to-date with the latest version from the main repository.
#
# Usage: ./scripts/check-template-version.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
LOCAL_TEMPLATE="$REPO_ROOT/.github/copilot-instructions.md"
REMOTE_TEMPLATE_URL="https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md"

echo "🔍 Checking ioBroker Copilot template version..."

# Check if local template exists
if [[ ! -f "$LOCAL_TEMPLATE" ]]; then
    echo "❌ Local template not found at $LOCAL_TEMPLATE"
    echo "💡 Run the following command to download the template:"
    echo "   mkdir -p .github && curl -o .github/copilot-instructions.md $REMOTE_TEMPLATE_URL"
    exit 1
fi

# Extract local version
LOCAL_VERSION=$(grep "Version:" "$LOCAL_TEMPLATE" | head -1 | sed 's/.*Version:\s*//' | tr -d '*')
if [[ -z "$LOCAL_VERSION" ]]; then
    echo "⚠️  Could not detect version in local template"
    LOCAL_VERSION="unknown"
fi

echo "📄 Local template version: $LOCAL_VERSION"

# Check remote version
echo "🌐 Checking remote template version..."
REMOTE_VERSION=$(curl -s "$REMOTE_TEMPLATE_URL" | grep "Version:" | head -1 | sed 's/.*Version:\s*//' | tr -d '*' 2>/dev/null)

if [[ -z "$REMOTE_VERSION" ]]; then
    echo "⚠️  Could not fetch remote version (network issue or repository not available)"
    echo "📍 Template source: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions"
    exit 1
fi

echo "🌐 Remote template version: $REMOTE_VERSION"

# Compare versions
if [[ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]]; then
    echo "✅ Your template is up-to-date!"
elif [[ "$LOCAL_VERSION" == "unknown" ]]; then
    echo "⚠️  Could not verify local version - please check your template format"
else
    echo "🆙 Template update available!"
    echo "   Current: $LOCAL_VERSION"
    echo "   Latest:  $REMOTE_VERSION"
    echo ""
    echo "💡 To update your template, run:"
    echo "   curl -o .github/copilot-instructions.md $REMOTE_TEMPLATE_URL"
    echo ""
    echo "📚 For more information, visit:"
    echo "   https://github.com/DrozmotiX/ioBroker-Copilot-Instructions"
fi

echo ""
echo "🏁 Template check complete!"