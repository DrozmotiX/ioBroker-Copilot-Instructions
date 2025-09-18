# Automated Template Updates with GitHub Copilot

This guide provides fully automated methods to validate and update your ioBroker Copilot instructions template using GitHub Copilot, ensuring all custom sections are preserved.

## 🚀 Quick Start (Copy-Paste Method)

The fastest way to update your template:

### Step 1: Create an Issue in Your Repository

1. Go to your ioBroker adapter repository on GitHub
2. Click "Issues" → "New Issue"  
3. Use title: **🤖 Update ioBroker Copilot Instructions Template**
4. Copy and paste this content:

```markdown
**GitHub Copilot**: Please help me update my ioBroker Copilot instructions template to the latest version while preserving all custom sections.

## Task
Update `.github/copilot-instructions.md` using this prompt:

```
"Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md with my existing .github/copilot-instructions.md. 

REQUIREMENTS:
1. Preserve ALL [CUSTOMIZE] sections exactly as they are
2. Keep all project-specific context and custom instructions  
3. Add latest ioBroker best practices from the new template
4. Update version to match latest template version
5. Maintain Template Source reference

Show me the changes before applying them."
```

## Validation
After update, confirm:
- [ ] All [CUSTOMIZE] sections preserved
- [ ] Version updated to latest  
- [ ] Custom content intact
- [ ] Template structure complete

**Reference**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
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

## 🛠️ Advanced Automated Method

For repositories with existing automation workflows, use the full template:

### Template File Location
Copy from: [`templates/automated-template-update.md`](../templates/automated-template-update.md)

This provides:
- Detailed step-by-step automation  
- Comprehensive validation checks
- Progress tracking with checkboxes
- Complete reference information

## 🔍 Custom Section Management

Your custom sections are automatically preserved when using the automation prompts. These include:

### Automatically Preserved Content
- All sections marked with `[CUSTOMIZE]`
- Project-specific adapter context
- Custom error handling patterns
- Unique API integration instructions
- Adapter-specific testing requirements

### Example Custom Section
```markdown
## [CUSTOMIZE] Project-Specific Instructions

### My Adapter Specific Patterns
- Custom authentication flow for MyService API
- Specific error codes handling for device XYZ
- Project-specific logging patterns

**Note:** This section is preserved during template updates
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