# Automated Template Updates with GitHub Copilot

This guide provides fully automated methods to validate and update your ioBroker Copilot instructions template using GitHub Copilot, ensuring all custom sections are preserved.

## 🚀 Quick Start (Simple Reference Method)

**Prerequisites**: Ensure GitHub Copilot is active in your repository first. If you haven't set up GitHub Copilot yet, create an issue in your repository with the title "🤖 Setup GitHub Copilot" and content "GitHub Copilot: Please help me set up GitHub Copilot for this repository and create initial .github/copilot-instructions.md file."

The fastest way to update your template:

### Step 1: Create an Issue in Your Repository

1. Go to your ioBroker adapter repository on GitHub
2. Click "Issues" → "New Issue"  
3. Use title: **🤖 Update ioBroker Copilot Instructions Template**
4. Use this simple content:

```
GitHub Copilot: Please help me update my ioBroker Copilot instructions template using the guide from:
docs/automated-updates.md

Reference the copy-paste template for specific requirements:
templates/copy-paste-template.md
```

### Step 2: Let GitHub Copilot Handle the Update

GitHub Copilot will automatically:
- Analyze your current template
- Fetch the latest template version
- Merge while preserving ALL `[CUSTOMIZE]` sections
- Provide a summary of changes
- Generate the updated file

### Step 3: Review and Apply Changes

Review the proposed changes to ensure:
- All your custom sections are intact
- Version is updated correctly
- New best practices are included
- No project-specific context is lost

## 🔄 Version Check Before Update

Check if your template needs updating:

```bash
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

This script will:
- Compare your local template version with the latest available
- Provide update guidance if your template is outdated
- Show you what's changed in newer versions

## 🛠️ Advanced Automated Method

For repositories with existing automation workflows, use the full template:

### Template File Location
Reference: [`templates/automated-template-update.md`](../templates/automated-template-update.md)

Create an issue with this simple content:
```
Title: 🤖 Update ioBroker Copilot Instructions Template

GitHub Copilot: Please help me update my template using the detailed guide from:
templates/automated-template-update.md
```

This provides:
- Detailed step-by-step automation  
- Comprehensive validation checks
- Progress tracking with checkboxes
- Complete reference information

## 🔍 Custom Section Management

Your custom sections are automatically preserved when using the automation prompts. These include:

### Automatically Preserved Content
- All sections marked with `[CUSTOMIZE]`
- Project-specific adapter context not covered by template
- Custom service integrations and authentication patterns
- Unique error handling specific to your adapter's requirements
- Adapter-specific testing scenarios beyond standard patterns

### Example Custom Section
```markdown
## [CUSTOMIZE] Project-Specific Instructions

### My Adapter Specific Patterns
- Custom authentication flow for [YourService] API
- Adapter-specific device discovery patterns
- Unique error codes and recovery procedures specific to your service

**Note:** This section is preserved during template updates and should contain only content not already covered in the standard template
```

## ✅ Validation Steps

After any automated update, verify:

1. **Version Check**: Compare version number with latest available
2. **Custom Content**: Confirm all `[CUSTOMIZE]` sections are intact
3. **Project Context**: Verify adapter-specific instructions remain  
4. **Template Structure**: Ensure all standard sections are present
5. **Functionality**: Test that Copilot provides enhanced suggestions

## 🚨 Troubleshooting

### If Custom Sections Are Lost
Use this recovery prompt:
```
"Restore my custom sections from the previous version of .github/copilot-instructions.md. I need all [CUSTOMIZE] sections and project-specific context to be added back to the current template while keeping the new version and best practices."
```

### If Template Structure Is Incomplete
```
"Please verify my .github/copilot-instructions.md has all required sections from the ioBroker template at https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md and add any missing sections while preserving my custom content."
```

## 📋 Success Criteria

A successful automated update includes:
- ✅ Latest template version number
- ✅ All `[CUSTOMIZE]` sections preserved exactly
- ✅ Project-specific context maintained
- ✅ New best practices integrated  
- ✅ Template source reference updated
- ✅ Valid markdown structure
- ✅ No loss of custom functionality

---

**Benefits of Automated Updates:**
- 🕒 **Time Saving**: No manual comparison or merging
- 🛡️ **Safe**: Custom content is automatically preserved
- 🎯 **Accurate**: Uses exact merge prompts tested for reliability
- 🔄 **Consistent**: Same process works across all repositories
- 🤖 **Smart**: Leverages GitHub Copilot's understanding of your codebase