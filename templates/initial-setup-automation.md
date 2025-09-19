---
name: Initial ioBroker Copilot Setup
about: Automated setup and validation of GitHub Copilot instructions for ioBroker adapters
title: "🤖 Setup ioBroker GitHub Copilot Instructions"
labels: ["copilot-setup", "automation"]
assignees: []
---

# 🤖 Automated ioBroker Copilot Instructions Setup

**GitHub Copilot**: Please help me set up GitHub Copilot instructions for my ioBroker adapter repository with full automation and validation.

## 🔍 Step 1: Repository Analysis and Status Detection

**GitHub Copilot**: Please analyze this repository using the centralized automation configuration:

**Configuration Reference**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/config/automation-setup.yml

1. **Repository Type Confirmation**
   - [ ] Verify this is an ioBroker adapter repository (check for `package.json` with "iobroker", `io-package.json`, `main.js` or `lib/` directory)
   - [ ] Identify adapter name and specific functionality
   - [ ] Assess current project structure and dependencies

2. **Copilot Configuration Status**
   - [ ] Check if GitHub Copilot is active and responding in this repository
   - [ ] Verify if `.github/copilot-instructions.md` exists and analyze content
   - [ ] Determine current template version (if any) vs latest from metadata.json
   - [ ] Assess existing customizations and configurations

3. **Setup Requirements Determination**
   - [ ] Classify status: `not_initialized`, `needs_update`, or `up_to_date`
   - [ ] Identify adapter-specific patterns that need customization
   - [ ] Plan integration strategy based on current state

## 🎯 Step 2: Automated Template Setup (Copilot-Driven)

**GitHub Copilot**: Please create or update the GitHub Copilot instructions using our centralized, automated approach:

**Configuration Reference**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/config/automation-setup.yml

### 2.1 Template Integration (No Manual Scripts Required)

**Important**: This process uses Copilot intelligence rather than manual validation scripts (avoiding approaches like DrozmotiX/ioBroker.discovergy#286).

1. **Fetch Latest Template and Version**:
   ```
   Template: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md
   Version: Extract from https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/config/metadata.json (field: "version")
   ```

2. **Process Template for This Repository**:
   - [ ] Remove template comment block (`<!-- TEMPLATE FILE -->` section)  
   - [ ] **Store version in `.github/copilot-instructions.md`** (format: `**Version:** X.Y.Z`)
   - [ ] **Do NOT store version in `package.json`** - this avoids package.json pollution
   - [ ] Add template source and metadata references

3. **Adapter-Specific Customization**:
   Customize ALL `[CUSTOMIZE]` sections with content unique to this adapter:
   - API authentication patterns specific to this service
   - Unique error codes and recovery procedures  
   - Custom device discovery or data processing workflows
   - Special configuration requirements beyond standard template
   - Testing scenarios specific to this adapter's functionality
   - **Remove any duplicate content** that already exists in the standard template

### 2.2 Centralized Version Management

Our approach stores template version information in the Copilot instructions file rather than package.json:
- ✅ **Version Location**: `.github/copilot-instructions.md` 
- ✅ **Version Source**: Dynamically fetched from `config/metadata.json`
- ✅ **Update Method**: Automated via centralized GitHub Action
- ❌ **Avoid**: Manual scripts in package.json or separate validation files
## 🔧 Step 3: Automated GitHub Action Setup

**GitHub Copilot**: Please create the weekly monitoring automation using our centralized action:

### 3.1 Create Weekly Monitoring Workflow

1. **Create Workflow File**: `.github/workflows/check-copilot-template.yml`

2. **Use Centralized Template**:
   ```
   Copy the complete workflow from:
   https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/templates/centralized-version-check-action.yml
   ```

3. **Workflow Features** (automatically included):
   - 📅 **Weekly Schedule**: Runs every Sunday to check for updates
   - 🔍 **Dynamic Version Detection**: Uses `config/metadata.json` for current version
   - 🤖 **Copilot-Driven Automation**: Creates intelligent setup/update issues
   - 🛡️ **Smart Issue Management**: Prevents duplicate issues
   - 📋 **Repository Status Detection**: Identifies setup vs. update scenarios

### 3.2 Centralized Automation Benefits

This centralized approach provides:
- ✅ **No Manual Scripts**: Replaces manual validation approaches (like DrozmotiX/ioBroker.discovergy#286)
- ✅ **Metadata-Driven**: Always uses latest version from centralized config
- ✅ **Copilot Intelligence**: Leverages GitHub Copilot for smart automation
- ✅ **Preservation Guarantee**: Automatically maintains all custom sections during updates
- ✅ **Dynamic Configuration**: Adapts to repository status and needs
## 📋 Step 4: Validation and Testing

**GitHub Copilot**: After completing the setup, please validate the integration:

### 4.1 Setup Validation

- [ ] **File Created**: `.github/copilot-instructions.md` exists and is properly formatted
- [ ] **Version Tracking**: Latest version number stored in copilot instructions (NOT package.json)  
- [ ] **Template Source**: Reference to source repository and metadata.json included
- [ ] **Custom Sections**: `[CUSTOMIZE]` areas populated with unique, adapter-specific content only
- [ ] **No Duplicates**: `[CUSTOMIZE]` sections contain only content not found in standard template
- [ ] **Workflow Created**: `.github/workflows/check-copilot-template.yml` exists and uses centralized template

### 4.2 GitHub Action Validation  

- [ ] **Workflow File**: Created from centralized template (templates/centralized-version-check-action.yml)
- [ ] **Permissions Set**: Issues write permission configured
- [ ] **Schedule Configured**: Weekly execution on Sundays
- [ ] **Manual Trigger**: workflow_dispatch enabled for manual runs
- [ ] **Metadata Integration**: Uses config/metadata.json for version detection

### 4.3 Functionality Testing

- [ ] **Enhanced Suggestions**: Test typing `this.setState(` in a .js file to verify improved suggestions
- [ ] **Template Recognition**: Verify Copilot recognizes ioBroker patterns and adapter-specific context
- [ ] **Custom Content**: Ensure `[CUSTOMIZE]` sections provide value beyond standard template
- [ ] **Version Accuracy**: Confirm version in copilot-instructions.md matches metadata.json
- [ ] **Workflow Syntax**: Validate GitHub Action YAML syntax is correct
## 🚨 Critical Success Criteria

A successful automated setup includes:

### ✅ Technical Implementation
- **File Creation**: `.github/copilot-instructions.md` created from latest template
- **Version Management**: Template version stored in copilot instructions (NOT package.json)  
- **Centralized Workflow**: GitHub Action created from centralized template
- **Dynamic Version Detection**: Workflow uses metadata.json for version checking
- **Custom Preservation**: All `[CUSTOMIZE]` sections populated with unique, adapter-specific content

### ✅ Functional Validation  
- **Enhanced Suggestions**: Improved Copilot suggestions for ioBroker patterns
- **Template Integration**: No duplicate content between `[CUSTOMIZE]` and standard sections
- **Automation Ready**: Weekly monitoring configured and tested
- **Issue Prevention**: Duplicate issue detection working
- **Metadata Driven**: Version detection using centralized config/metadata.json

### ✅ Process Verification
- **No Manual Scripts**: Avoided package.json validation scripts (like DrozmotiX/ioBroker.discovergy#286)
- **Copilot-Driven**: Used GitHub Copilot intelligence rather than manual processes
- **Preservation Guaranteed**: Custom sections maintained during updates
- **Dynamic Configuration**: System adapts to repository status automatically

## 📚 Reference Information

- **Template Repository**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
- **Latest Template**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md
- **Centralized Config**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/config/metadata.json
- **Automation Config**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/config/automation-setup.yml
- **Centralized Action**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/templates/centralized-version-check-action.yml

**GitHub Copilot**: Please start with the repository analysis and proceed step-by-step through the automated setup process. Provide detailed feedback on what you're doing at each step and confirm successful completion of all validation criteria.
