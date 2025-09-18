# GitHub Copilot Setup Guide

This guide walks you through setting up GitHub Copilot for ioBroker adapter development, focusing on repository-level Copilot integration and automated template merging.

## 📋 Table of Contents

- [Repository Copilot Setup (Essential)](#repository-copilot-setup-essential)
- [Template Integration](#template-integration)
- [Advanced: IDE Setup](#advanced-ide-setup)
- [Validation and Testing](#validation-and-testing)
- [Organization-Specific Setup](#organization-specific-setup)

## Repository Copilot Setup (Essential)

**For existing ioBroker adapter repositories** - This section covers setting up GitHub Copilot at the repository level, which is essential for all users.

### Step 1: GitHub Copilot Subscription

1. **Subscribe to GitHub Copilot**
   - Visit [GitHub Copilot](https://github.com/features/copilot) and subscribe to GitHub Copilot Individual or Business
   - Ensure your subscription is active and includes your target repository

### Step 2: Repository Copilot Instructions Setup

1. **Navigate to your existing ioBroker adapter repository**
   ```bash
   cd your-existing-iobroker-adapter
   ```

2. **Ensure you have GitHub Copilot instructions file**
   ```bash
   # Create .github directory if it doesn't exist
   mkdir -p .github
   
   # Check if you already have Copilot instructions
   ls -la .github/copilot-instructions.md
   ```

3. **Initial template setup** 
   If you don't have a copilot-instructions.md file yet:
   
   **Option A: Use automated setup** (Recommended)
   - **First ensure GitHub Copilot is active**: Create an issue with title "🤖 Setup GitHub Copilot" and content "GitHub Copilot: Please help me set up GitHub Copilot for this repository."
   - After Copilot responds and is working, create another issue using the [copy-paste template](../templates/copy-paste-template.md)
   - GitHub Copilot will create the complete template for you
   
   **Option B: Manual template download**
   ```bash
   # Download the template
   curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md
   # Remove template comment block
   sed -i '/^<!--$/,/^-->$/d' .github/copilot-instructions.md
   ```
   
   **Important**: After initial setup, always add your project-specific content in `[CUSTOMIZE]` sections:
   ```markdown
   ## [CUSTOMIZE] Project-Specific Instructions
   
   ### My Adapter Specific Patterns
   - Custom authentication flow for [YourService] API
   - Adapter-specific device discovery patterns
   - Unique error codes specific to your service
   
   **Note:** This section is preserved during template updates and should contain only content not already covered in the standard template
   ```

4. **For existing configurations**
   If your existing config needs updates, use the automated update process instead of replacing the file

## Template Integration

**🤖 Fully Automated Updates** - Use GitHub Copilot to handle template updates automatically while preserving all custom sections.

### Option A: Automated Issue-Based Updates (Recommended)

**Best for**: Regular updates and team collaboration

1. **Create an automated update issue**
   - Go to your repository's Issues
   - Create new issue with title: "🤖 Update ioBroker Copilot Instructions Template"  
   - Use content from [`templates/copy-paste-template.md`](../templates/copy-paste-template.md)
   - GitHub Copilot will automatically handle the merge

2. **Benefits of issue-based automation**
   - Creates audit trail of template updates
   - Allows team review before applying changes
   - Preserves all `[CUSTOMIZE]` sections automatically
   - Tracks version history in issues

### Option B: Direct Editor Integration

**Best for**: Quick updates during development

1. **Prompt GitHub Copilot for smart merging**
   In your editor, use this prompt:
   ```
   "Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md 
   with my existing .github/copilot-instructions.md. Preserve all [CUSTOMIZE] sections and project-specific 
   context while adding the latest ioBroker best practices. Update the version to the latest available."
   ```

2. **For comprehensive automation**: Use the full template from [`templates/automated-template-update.md`](../templates/automated-template-update.md)

### Step 1: Prepare for Template Integration

1. **Ensure version tracking in your repository**
   Your `.github/copilot-instructions.md` should include:
   ```markdown
   **Version:** [current-version]
   **Template Source:** https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
   **Custom Sections:** [Preserve during updates]
   ```

2. **Identify your custom sections**
   - Mark any project-specific instructions with `[CUSTOMIZE]` tags
   - These will be preserved during template updates

### Step 2: Automated Template Merging

**Use GitHub Copilot to intelligently merge templates** - This preserves your custom content and maintains version control.

1. **Prompt GitHub Copilot for smart merging**
   In your editor, use this prompt:
   ```
   "Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md 
   with my existing .github/copilot-instructions.md. Preserve all [CUSTOMIZE] sections and project-specific 
   context while adding the latest ioBroker best practices. Update the version to the latest available."
   ```

2. **Verify version tracking**
   Ensure your updated file includes:
   - Current template version (latest available)
   - Template source reference
   - Your custom sections intact
   - Project-specific context preserved

3. **Commit with version control**
   ```bash
   git add .github/copilot-instructions.md
   git commit -m "Update Copilot instructions to latest template version, preserve custom sections"
   ```

### Step 3: Custom Section Management

**Keep customizations safe** - Always use the custom section approach:

1. **Structure your custom content**
   ```markdown
   ## [CUSTOMIZE] Project-Specific Instructions
   
   ### My Adapter Specific Patterns
   - Custom patterns for your adapter
   - Project-specific error handling
   - Unique API integrations
   
   **Note:** This section is preserved during template updates
   ```

2. **Version validation**
   Use the version check script to ensure you're up-to-date:
   ```bash
   curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
   ```

## Advanced: IDE Setup

**Optional IDE integration** - For developers who want to use Copilot directly in their development environment.

### IDE Installation & Configuration

1. **Install GitHub Copilot Extension**
   - **VS Code**: Install the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
   - **JetBrains IDEs**: Install GitHub Copilot from the plugin marketplace
   - **Vim/Neovim**: Use the [copilot.vim](https://github.com/github/copilot.vim) plugin
   - **Other editors**: Check [GitHub Copilot documentation](https://docs.github.com/en/copilot) for your editor

2. **Authenticate GitHub Copilot in IDE**
   - Open your editor and sign in to GitHub Copilot when prompted
   - Verify authentication by typing code in any file - you should see Copilot suggestions

3. **Test IDE Integration**
   ```javascript
   // Create a file test-copilot.js and start typing this comment:
   // Function to add two numbers
   
   // Copilot should suggest a function implementation when you press Enter
   ```

### IDE Troubleshooting

| Problem | Solution |
|---------|----------|
| No suggestions appear | Check authentication and subscription status |
| Extension not working | Reinstall Copilot extension and restart editor |
| Authentication issues | Sign out and sign back in to GitHub Copilot |

## Validation and Testing

After completing the template integration, verify everything is working correctly:

### Repository-Level Testing

```bash
# Test that Copilot instructions are properly integrated
# 1. Check your .github/copilot-instructions.md file exists
ls -la .github/copilot-instructions.md

# 2. Verify version information is present
grep "Version:" .github/copilot-instructions.md
grep "Template Source:" .github/copilot-instructions.md

# 3. Check for custom sections
grep "\[CUSTOMIZE\]" .github/copilot-instructions.md
```

### Development Testing

Test that Copilot provides ioBroker-specific suggestions:

1. **Open any .js or .ts file in your adapter**
2. **Start typing ioBroker-related code:**
   - Example: `// Create new ioBroker adapter instance`
   - Example: `this.setState(`
   - Example: `// Handle device connection`

3. **Verify enhanced suggestions:**
   - Copilot should provide ioBroker-specific patterns
   - Error handling should follow ioBroker best practices
   - Test suggestions should include `@iobroker/testing` framework usage

### Expected Results

After successful integration, you should observe:
- **Context-aware suggestions** specific to ioBroker development patterns
- **Error handling** that follows ioBroker best practices
- **Test suggestions** that include `@iobroker/testing` framework usage
- **README updates** that follow ioBroker documentation standards
- **Dependency management** suggestions aligned with ioBroker ecosystem

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