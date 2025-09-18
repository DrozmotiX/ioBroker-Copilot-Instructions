# Quick Copy-Paste Template for Template Updates

Copy and paste this content when creating a new issue in your ioBroker adapter repository to automatically update your Copilot instructions template:

---

## Title: 🤖 Update ioBroker Copilot Instructions Template

## Issue Content:

```markdown
**Prerequisites**: Ensure GitHub Copilot is active in your repository. If not set up yet, create an issue first: "🤖 Setup GitHub Copilot" with content "GitHub Copilot: Please help me set up GitHub Copilot for this repository."

**GitHub Copilot**: Please help me update my ioBroker Copilot instructions template to the latest version while preserving all custom sections.

## Task
Update `.github/copilot-instructions.md` using this prompt:

```
"Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md with my existing .github/copilot-instructions.md. 

REQUIREMENTS:
1. Preserve ALL [CUSTOMIZE] sections exactly as they are
2. Keep all project-specific context not already covered in the standard template
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

---

**Instructions**: Copy the content above (including the markdown code blocks) and paste it when creating a new issue in your repository. GitHub Copilot will automatically process this and help you update your template.