---
name: Automated Template Update Request
about: Use this template to automatically validate and update ioBroker Copilot Instructions template
title: "🤖 Validate and Update ioBroker Copilot Instructions Template"
labels: ["template-update", "automation"]
assignees: []
---

# Automated ioBroker Copilot Template Update Request

**Prerequisites**: This assumes GitHub Copilot is already active in your repository. If not, first create an issue with title "🤖 Setup GitHub Copilot" and content "GitHub Copilot: Please help me set up GitHub Copilot for this repository."

**GitHub Copilot**: Please help me validate and update my ioBroker adapter's Copilot instructions template while preserving all custom sections.

## 🔍 Current State Analysis

**GitHub Copilot**: Please analyze my current `.github/copilot-instructions.md` file and:

1. **Check version status** - Compare my current template version with the latest available
2. **Identify custom sections** - Find all `[CUSTOMIZE]` sections and project-specific content
3. **Assess template health** - Verify the template structure and completeness

## 🎯 Update Requirements

**GitHub Copilot**: I need you to:

### Primary Tasks
- [ ] **Merge latest template** from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md
- [ ] **Preserve ALL custom sections** marked with `[CUSTOMIZE]` tags 
- [ ] **Maintain project-specific context** not covered by standard template
- [ ] **Update version tracking** to the latest template version
- [ ] **Validate template structure** ensures all required sections are present

### Template Integration Prompt
Use this exact prompt for the merge operation:

```
"Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md with my existing .github/copilot-instructions.md. 

CRITICAL REQUIREMENTS:
1. Preserve ALL [CUSTOMIZE] sections and their content exactly as they are
2. Maintain any project-specific context not already covered in the template
3. Add the latest ioBroker best practices from the new template
4. Update the version number to match the latest template version
5. Keep the Template Source reference up-to-date
6. Ensure no custom content is lost during the merge
7. REMOVE any duplicate content from [CUSTOMIZE] sections that already exists in the standard template
8. Keep only truly unique, adapter-specific content in [CUSTOMIZE] sections

Show me what changes will be made before applying them."
```

## 🔧 Validation Steps

**GitHub Copilot**: After completing the update, please verify:

- [ ] **Version consistency** - Template version matches the latest available
- [ ] **Custom content preserved** - All `[CUSTOMIZE]` sections remain intact
- [ ] **Project context maintained** - Adapter-specific instructions are preserved  
- [ ] **Template completeness** - All standard sections are present and up-to-date
- [ ] **Syntax validation** - Markdown formatting is correct
- [ ] **No duplicates** - [CUSTOMIZE] sections contain only unique content not found in standard template

## 📋 Expected Deliverables

**GitHub Copilot**: Please provide:

1. **Change summary** - List of what was updated, added, or preserved
2. **Updated file** - The complete new `.github/copilot-instructions.md` content
3. **Validation report** - Confirmation that custom sections were preserved
4. **Version information** - New version number and source reference
5. **Commit message** - Suggested commit message for the changes

## 🚨 Critical Requirements

**⚠️ IMPORTANT**: This update must preserve:
- All `[CUSTOMIZE]` sections and their exact content
- Project-specific adapter context not already in the standard template
- Any custom configuration or setup instructions unique to your adapter
- Existing version tracking information structure

**✅ SUCCESS CRITERIA**: 
- Template is updated to the latest version
- All custom content remains exactly as it was
- New best practices are integrated without affecting existing customizations
- Template structure is complete and valid

---

## 📚 Reference Information

- **Template Source**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
- **Latest Template**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md
- **Version Check Script**: Use our [version check command](https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/snippets/version-check-command.md)

**GitHub Copilot**: Start by running the version check and analyzing my current template, then proceed with the merge using the provided prompt.