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

3. **Automated Initial Setup** (Recommended)
   
   **🤖 Fully Automated Process**: Use our comprehensive setup template that handles everything automatically:
   
   1. **Create Setup Issue**: Go to your repository's Issues and create a new issue
   2. **Use Automated Template**: Copy the content from [Initial Setup Automation Template](../templates/initial-setup-automation.md)
   3. **Let GitHub Copilot Handle Everything**: The template will:
      - ✅ Validate if Copilot is already working in your repository
      - 🔍 Check if copilot-instructions.md already exists
      - 📥 Download and customize the latest template automatically
      - 🎯 Add adapter-specific customizations to [CUSTOMIZE] sections
      - ⚙️ Set up weekly monitoring via GitHub Actions
      - 🛡️ Preserve any existing custom content during updates

   **Benefits of Automated Setup**:
   - 🕐 **No Manual Steps**: Everything is handled by GitHub Copilot
   - 🔄 **Future-Proof**: Automatic weekly version checking  
   - 🛡️ **Safe Updates**: Custom content is always preserved
   - 🎯 **Adapter-Specific**: Automatically tailored to your specific adapter
   
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
   If your existing config needs updates, the same [Initial Setup Automation Template](../templates/initial-setup-automation.md) handles this automatically. It will:
   - 🔍 Detect existing copilot-instructions.md
   - 🔄 Merge the latest template while preserving ALL [CUSTOMIZE] sections  
   - ✅ Update version numbers and references
   - 🛡️ Ensure no custom content is lost

5. **Ongoing Maintenance** 
   The automated setup also configures weekly monitoring via GitHub Actions that will:
   - 📅 Check for template updates every Sunday
   - 🎯 Create issues automatically when updates are available
   - 🔄 Handle version management without manual intervention
   - 🛡️ Always preserve your custom configurations during updates

## Automated Template Integration

**🤖 Fully Automated Process** - All template operations are now handled via GitHub Copilot automation with zero manual steps required.

### Primary Method: Issue-Based Automation (Recommended)

**Best for**: Both initial setup and ongoing maintenance

1. **For Initial Setup or Updates**
   - Create an issue with this simple content:
     ```
     Title: 🤖 Setup ioBroker GitHub Copilot Instructions
     
     GitHub Copilot: Please help me set up GitHub Copilot instructions using:
     templates/initial-setup-automation.md
     ```
   - Creates comprehensive setup with validation and monitoring
   - Handles both new installations and updates automatically
   - Preserves all custom content during updates

2. **For Quick Updates Only**  
   - Create an issue with this simple content:
     ```
     Title: 🤖 Update ioBroker Copilot Instructions Template
     
     GitHub Copilot: Please help me update my template using:
     templates/copy-paste-template.md
     ```
   - Focuses specifically on template merging
   - Ideal when you just need to update an existing template

### Automated Benefits

✅ **Zero Manual Steps**: No curl commands, sed operations, or file manipulation  
🛡️ **Safe Updates**: All [CUSTOMIZE] sections automatically preserved  
📅 **Continuous Monitoring**: Weekly checks via GitHub Actions  
🎯 **Adapter-Specific**: Automatically customized for your specific adapter  
🔄 **Future-Proof**: Automatically handles new template versions  
📋 **Audit Trail**: All changes tracked through GitHub issues

### Alternative: Direct Editor Integration

**For Advanced Users**: If you prefer working directly in your editor instead of using issues:

1. **Use the comprehensive automation template**
   Copy the full template from [`templates/automated-template-update.md`](../templates/automated-template-update.md)
   
2. **Or use this quick prompt in your editor**:
   ```
   "Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md 
   with my existing .github/copilot-instructions.md. Preserve all [CUSTOMIZE] sections and project-specific 
   context while adding the latest ioBroker best practices. Update the version to the latest available."
   ```

### Weekly Monitoring Setup

The [Initial Setup Automation Template](../templates/initial-setup-automation.md) automatically creates a GitHub Action that:
- 📅 Runs weekly to check for template updates  
- 🎯 Creates issues when updates are available
- 🛡️ Never overwrites existing custom content
- 🔍 Prevents duplicate issues from being created

**Manual GitHub Action Setup**: If you want to add monitoring to an existing setup without using the full automation template, copy [`templates/weekly-version-check-action.yml`](../templates/weekly-version-check-action.yml) to `.github/workflows/check-copilot-template.yml` in your repository.

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