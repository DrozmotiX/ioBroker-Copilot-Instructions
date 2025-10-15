# Issue Templates and Automation

This directory contains templates and automation files for setting up and maintaining ioBroker Copilot instructions using a standardized GitHub Action template structure.

## Templates

### 🚀 [initial-setup-automation.md](initial-setup-automation.md)
**Primary template for all new repositories and comprehensive setup**

- ✅ Validates if GitHub Copilot is already setup
- 🔍 Detects existing copilot-instructions.md files
- 📥 Uses standardized GitHub Action templates via HTTP references
- ⚙️ Sets up both initial setup and weekly monitoring workflows
- 🛡️ Preserves custom content during updates
- 🎯 Establishes adapter-specific context first

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

## Standardized GitHub Action Templates

### 🎯 [ghAction-InitialSetup.yml](ghAction-InitialSetup.yml)
**Initial setup automation for new repositories**

- 🚀 **Manual Trigger**: Run on-demand for initial setup
- 🔍 **Repository Analysis**: Automatically detects ioBroker adapter structure
- 📝 **Context-First Setup**: Creates adapter-specific context before template integration
- 🔄 **Follow-up Automation**: Creates enhancement issue after initial setup

**Usage**:
```bash
curl -o .github/workflows/initial-copilot-setup.yml \
  https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/templates/ghAction-InitialSetup.yml
```

### 📅 [ghAction-AutomatedVersionCheckAndUpdate.yml](ghAction-AutomatedVersionCheckAndUpdate.yml)
**Continuous monitoring and update automation**

- 📅 **Weekly Schedule**: Runs optimized for off-peak hours (3:23 AM UTC Sunday)
- 🔍 **Dynamic Version Detection**: Uses `config/metadata.json` for current version
- 🤖 **Copilot-Driven Automation**: Creates intelligent setup/update issues
- 🛡️ **Smart Issue Management**: Prevents duplicate issues
- 📋 **Repository Status Detection**: Identifies setup vs. update scenarios

**Usage**:
```bash
curl -o .github/workflows/check-copilot-template.yml \
  https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/templates/ghAction-AutomatedVersionCheckAndUpdate.yml
```

**Duplicate Issue Prevention**: This workflow automatically closes all existing Copilot-related issues before creating a new one, ensuring clean issue management. Issues are identified by:
- Creator: `github-actions[bot]` only
- Title pattern: Contains "copilot" and ("template" OR "setup" OR "update" OR "instructions")
- No dependency on labels

This prevents the problem where multiple identical issues are created when workflows run multiple times.

## Legacy Files (Deprecated)

### ⚠️ [weekly-version-check-action.yml](weekly-version-check-action.yml)
**Replaced by ghAction-AutomatedVersionCheckAndUpdate.yml**

### ⚠️ [centralized-version-check-action.yml](centralized-version-check-action.yml)
**Replaced by ghAction-AutomatedVersionCheckAndUpdate.yml**

## Standardized Template Structure

All GitHub Action templates follow the naming convention:
- **`ghAction-{Purpose}.yml`**: Clear, descriptive naming
- **HTTP References**: All templates are referenced via standardized GitHub URLs
- **Version Information**: Each template includes version headers
- **Self-Contained**: Templates include all necessary logic without external dependencies

### Benefits of Standardization

- ✅ **Always Current**: Templates are always the latest version
- ✅ **Centralized Maintenance**: Updates benefit all repositories automatically  
- ✅ **Consistent Behavior**: All repositories use identical automation logic
- ✅ **No Template Drift**: Prevents local modifications that cause inconsistencies
- ✅ **Clear Naming**: Easy to identify template purpose
- ✅ **HTTP-Accessible**: Can be directly downloaded via curl

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