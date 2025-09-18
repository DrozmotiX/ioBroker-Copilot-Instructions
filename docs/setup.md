# GitHub Copilot Setup Guide

This guide walks you through setting up GitHub Copilot for ioBroker adapter development, from initial subscription to template integration.

## 📋 Table of Contents

- [Prerequisites and Basic GitHub Copilot Setup](#prerequisites-and-basic-github-copilot-setup)
- [Template Integration](#template-integration)
- [Validation and Testing](#validation-and-testing)
- [Organization-Specific Setup](#organization-specific-setup)

## Prerequisites and Basic GitHub Copilot Setup

Before using this template, ensure you have GitHub Copilot properly set up in your repository. If you're new to GitHub Copilot, follow these steps:

### Step 1: GitHub Copilot Subscription & Installation

1. **Subscribe to GitHub Copilot**
   - Visit [GitHub Copilot](https://github.com/features/copilot) and subscribe to GitHub Copilot Individual or Business
   - Ensure your subscription is active and includes your target repository

2. **Install GitHub Copilot Extension**
   - **VS Code**: Install the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
   - **JetBrains IDEs**: Install GitHub Copilot from the plugin marketplace
   - **Vim/Neovim**: Use the [copilot.vim](https://github.com/github/copilot.vim) plugin
   - **Other editors**: Check [GitHub Copilot documentation](https://docs.github.com/en/copilot) for your editor

3. **Authenticate GitHub Copilot**
   - Open your editor and sign in to GitHub Copilot when prompted
   - Verify authentication by typing code in any file - you should see Copilot suggestions

### Step 2: Repository Setup & Validation

1. **Enable Copilot for Your Repository**
   ```bash
   # Navigate to your ioBroker adapter repository
   cd your-iobroker-adapter
   
   # Ensure you're logged into GitHub CLI (optional but recommended)
   gh auth login
   ```

2. **Create Basic GitHub Copilot Structure**
   ```bash
   # Create .github directory if it doesn't exist
   mkdir -p .github
   
   # Verify Copilot can access your repository
   # Open any .js/.ts file and start typing - you should see suggestions
   ```

3. **Verify Copilot is Working**
   - Open a JavaScript or TypeScript file in your repository
   - Start typing a function or comment
   - You should see grayed-out suggestions from Copilot
   - Press `Tab` to accept suggestions or `Esc` to dismiss

### Step 3: Test Basic Functionality

Create a simple test to verify Copilot is working with your repository:

```javascript
// Create a file test-copilot.js and start typing this comment:
// Function to add two numbers

// Copilot should suggest a function implementation when you press Enter
```

**Expected behavior:** Copilot should suggest code completions as you type.

### Troubleshooting Basic Setup

| Problem | Solution |
|---------|----------|
| No suggestions appear | Check authentication and subscription status |
| Repository not accessible | Verify organization settings and permissions |
| Extension not working | Reinstall Copilot extension and restart editor |
| Authentication issues | Sign out and sign back in to GitHub Copilot |

**✅ Setup Complete!** Once you have Copilot working and showing suggestions in your repository, you can proceed to integrate the ioBroker template below.

### Quick Reference Checklist

For experienced GitHub Copilot users, here's a quick checklist:

- [ ] GitHub Copilot subscription is active
- [ ] Copilot extension installed in your editor
- [ ] Authentication completed (can see suggestions when typing)
- [ ] Repository permissions configured (for organizations)
- [ ] Basic functionality tested (suggestions appear in .js/.ts files)
- [ ] Ready to integrate ioBroker template

**New to GitHub Copilot?** Follow the detailed [Prerequisites & Basic Setup](#prerequisites-and-basic-github-copilot-setup) above.

## Template Integration

### Quick Start

> **⚠️ Prerequisites Required:** Before proceeding, ensure you've completed the [Basic GitHub Copilot Setup](#prerequisites-and-basic-github-copilot-setup) above.

1. **For Existing Copilot Users (Recommended)**
   - If you already have a `.github/copilot-instructions.md` file, merge the content from this template rather than replacing it
   - Use GitHub Copilot to help you merge the instructions: "Merge my existing copilot instructions with the template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions maintaining project-specific context"
   - Add the template version reference to track updates

2. **For New Copilot Users**
   - Download the latest version of [`template.md`](../template.md)
   - Save it as `.github/copilot-instructions.md` in your adapter repository's `.github/` folder
   - Customize sections marked with `[CUSTOMIZE]` for your specific adapter requirements

3. **Verification & Activation**
   - Verify GitHub Copilot is working in your repository (should show suggestions when typing)
   - The ioBroker-specific instructions will automatically be used by Copilot when working in your codebase
   - Test by opening a JavaScript file and typing ioBroker-related code - you should see relevant suggestions

### Integration Steps

> **⚠️ Important:** Ensure GitHub Copilot is working in your repository before proceeding. If you need setup help, see the [Prerequisites & Basic Setup](#prerequisites-and-basic-github-copilot-setup) section above.

**For repositories with existing Copilot instructions:**
```bash
# Navigate to your ioBroker adapter repository
cd your-iobroker-adapter

# Verify Copilot is working (should show suggestions when you type)
# Open any .js file and type: // Function to connect to ioBroker
# You should see Copilot suggestions appear

# Ask GitHub Copilot to merge the instructions
# Use the following prompt in your editor:
# "Merge my existing .github/copilot-instructions.md with the ioBroker template 
# from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md
# Keep project-specific content and add version: 0.4.0"
# NOTE: Exclude the HTML comment block at the top of the template"
```

**For new repositories (first-time Copilot setup):**
```bash
# Navigate to your ioBroker adapter repository
cd your-iobroker-adapter

# Verify basic Copilot setup is complete
# Open any .js file and start typing - you should see suggestions
# If no suggestions appear, complete the basic setup first

# Create .github directory if it doesn't exist
mkdir -p .github

# Download the latest template
curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md

# Remove the template comment block at the top (lines starting with <!--)
sed -i '/^<!--$/,/^-->$/d' .github/copilot-instructions.md

# Commit the changes
git add .github/copilot-instructions.md
git commit -m "Add GitHub Copilot instructions for ioBroker development"
git push
```

## Validation and Testing

After completing the integration, verify everything is working correctly:

```bash
# Test that Copilot uses the ioBroker instructions
# 1. Open any .js or .ts file in your adapter
# 2. Start typing ioBroker-related code:
#    Example: // Create new ioBroker adapter instance
#    Example: this.setState(
#    Example: // Handle device connection

# 3. Copilot should now provide ioBroker-specific suggestions
# 4. Check that suggestions follow the patterns from the template
```

**Expected Results:**
- Copilot suggestions should be more relevant to ioBroker development
- Error handling should follow ioBroker patterns
- Test suggestions should include `@iobroker/testing` framework usage
- README updates should follow ioBroker documentation standards

## Organization-Specific Setup

<details>
<summary>Click to expand organization setup instructions (only relevant if your repository is part of a GitHub organization)</summary>

### Step 4: Repository Permissions (For Organizations)

If your repository is part of an organization:

1. **Check Organization Settings**
   - Go to your GitHub organization settings
   - Navigate to "Copilot" in the left sidebar
   - Ensure your repository is included in the allowed repositories

2. **Verify Team Access**
   - Ensure your team has Copilot access enabled
   - Check that repository access policies allow Copilot usage

### Organization-Specific Troubleshooting

| Problem | Solution |
|---------|----------|
| Organization access denied | Contact organization admin to enable Copilot access |
| Repository not in allowed list | Add repository to organization's Copilot allowed repositories |
| Team access issues | Verify team has Copilot license allocation |
| Policy restrictions | Review organization Copilot policies and permissions |

### Organization Best Practices

- **Centralized Configuration**: Consider creating organization-level Copilot instruction templates
- **Access Management**: Use teams to manage Copilot access across repositories
- **Policy Compliance**: Ensure Copilot usage complies with organization security policies
- **Training**: Provide team training on Copilot best practices for ioBroker development

</details>

---

**Next Steps:** Return to the [main README](../README.md) to explore what's included in the template and see examples of how it enhances ioBroker development.