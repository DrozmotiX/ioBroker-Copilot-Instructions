# Quick Template Update Guide

This guide shows you how to create a simple GitHub issue that will automatically update your Copilot instructions template. No copy/paste required - just reference this file and let GitHub Copilot read the requirements dynamically.

## Simple Issue Creation

### Title: 
```
🤖 Update ioBroker Copilot Instructions Template
```

### Issue Content:
```
GitHub Copilot: Please help me update my ioBroker Copilot instructions template to the latest version while preserving all custom sections.

Please use the requirements from: templates/copy-paste-template.md
```

## Template Update Requirements

**Prerequisites**: Ensure GitHub Copilot is active in your repository. If not set up yet, create an issue first: "🤖 Setup GitHub Copilot" with content "GitHub Copilot: Please help me set up GitHub Copilot for this repository."

### Update Requirements for GitHub Copilot:

When GitHub Copilot processes the update request, it should:

1. **Merge the latest template**: Fetch from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md
2. **Preserve ALL [CUSTOMIZE] sections exactly as they are**
3. **Keep all project-specific context** not already covered in the standard template
4. **Add latest ioBroker best practices** from the new template
5. **Update version** to match latest template version
6. **Maintain Template Source reference**
7. **REMOVE duplicate content** from [CUSTOMIZE] sections that already exists in the standard template
8. **Keep only truly unique, adapter-specific content** in [CUSTOMIZE] sections
9. **Show changes before applying them**

## Validation Checklist

After the update, confirm:
- [ ] All [CUSTOMIZE] sections preserved
- [ ] Version updated to latest
- [ ] Custom content intact  
- [ ] Template structure complete
- [ ] No duplicate content between [CUSTOMIZE] sections and standard template

## Reference
**Template Repository**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions

---

**Instructions for Users**: Create a GitHub issue with the title and content shown above. GitHub Copilot will automatically read this file and apply all the requirements without you needing to copy/paste anything.