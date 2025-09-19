# Issue Templates and Automation

This directory contains templates and automation files for setting up and maintaining ioBroker Copilot instructions.

## Templates

### 🚀 [initial-setup-automation.md](initial-setup-automation.md)
**Primary template for all new repositories and comprehensive updates**

- ✅ Validates if GitHub Copilot is already setup
- 🔍 Detects existing copilot-instructions.md files
- 📥 Automatically downloads and customizes latest template
- ⚙️ Sets up weekly monitoring via GitHub Actions
- 🛡️ Preserves custom content during updates
- 🎯 Adds adapter-specific customizations

**Use this for**: New repositories or when you want full automation including monitoring

### 📋 [copy-paste-template.md](copy-paste-template.md)
**Quick update template for existing setups**

- 🔄 Focuses on template merging only
- 🛡️ Preserves [CUSTOMIZE] sections
- ⚡ Fast update process

**Use this for**: Quick updates when you already have monitoring setup

### 🔧 [automated-template-update.md](automated-template-update.md)  
**Comprehensive update template with detailed validation**

- 📊 Includes detailed analysis steps
- 🔍 Comprehensive validation requirements
- 📋 Detailed deliverables checklist

**Use this for**: Complex updates or when you need detailed change tracking

## Automation Files

### 🤖 [weekly-version-check-action.yml](weekly-version-check-action.yml)
**GitHub Action for automated monitoring**

- 📅 Weekly template version checking
- 🎯 Automatic issue creation when updates are available
- 🚫 Prevents duplicate issues
- 🛡️ Safe update process with preservation of custom content

**Use this**: Copy to `.github/workflows/check-copilot-template.yml` in your repository for weekly monitoring

## Usage Recommendations

### For New Repositories
1. Create an issue with this simple content:
   ```
   Title: 🤖 Setup ioBroker GitHub Copilot Instructions
   
   GitHub Copilot: Please help me set up using: templates/initial-setup-automation.md
   ```
2. Let GitHub Copilot handle everything automatically

### For Existing Repositories  
1. **With monitoring needed**: Create an issue:
   ```
   Title: 🤖 Setup ioBroker GitHub Copilot Instructions
   
   GitHub Copilot: Please help using: templates/initial-setup-automation.md
   ```
2. **Quick updates only**: Create an issue:
   ```
   Title: 🤖 Update ioBroker Copilot Instructions Template
   
   GitHub Copilot: Please help using: templates/copy-paste-template.md
   ```
3. **Complex updates**: Create an issue:
   ```
   Title: 🤖 Update ioBroker Copilot Instructions Template
   
   GitHub Copilot: Please help using: templates/automated-template-update.md
   ```

### For Manual GitHub Action Setup
Copy [weekly-version-check-action.yml](weekly-version-check-action.yml) to `.github/workflows/check-copilot-template.yml`

## Benefits of Automation

- 🕐 **Zero Manual Steps**: No curl, sed, or file manipulation required
- 🛡️ **Safety**: Custom content always preserved  
- 📅 **Maintenance**: Automatic weekly update checks
- 🎯 **Customization**: Adapter-specific content added automatically
- 📋 **Tracking**: Full audit trail through GitHub issues