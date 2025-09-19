---
name: Initial ioBroker Copilot Setup
about: Automated setup and validation of GitHub Copilot instructions for ioBroker adapters
title: "🤖 Setup ioBroker GitHub Copilot Instructions"
labels: ["copilot-setup", "automation"]
assignees: []
---

# 🤖 Automated ioBroker Copilot Instructions Setup

**GitHub Copilot**: Please help me set up GitHub Copilot instructions for my ioBroker adapter repository with full automation and validation.

## 🔍 Step 1: Current State Analysis

**GitHub Copilot**: Please analyze my repository and check:

1. **Copilot Status Check**
   - [ ] Verify if GitHub Copilot is active and responding in this repository
   - [ ] Check if `.github/copilot-instructions.md` already exists
   - [ ] Analyze existing content if present

2. **Repository Context Assessment**
   - [ ] Identify this as an ioBroker adapter repository
   - [ ] Detect adapter name and specific patterns
   - [ ] Find existing custom configuration or setup

## 🎯 Step 2: Setup Requirements

**GitHub Copilot**: Based on your analysis, please:

### If Copilot Instructions DON'T Exist:
Create a complete `.github/copilot-instructions.md` file by:

1. **Download and integrate the latest template**:
   ```
   Fetch the ioBroker Copilot template from:
   https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md
   
   Then create .github/copilot-instructions.md with:
   - Remove the template comment block (lines starting with <!-- to -->)
   - Add current date and latest version information
   - Customize [CUSTOMIZE] sections with adapter-specific context
   - Include Template Source reference
   ```

2. **Add adapter-specific context**:
   ```
   In the [CUSTOMIZE] Project-Specific Instructions section, add:
   - This adapter's specific API patterns
   - Unique authentication or connection handling
   - Custom error codes specific to this service
   - Adapter-specific device discovery patterns
   ```

### If Copilot Instructions DO Exist:
Update the existing file using the merge process:

```
"Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md with my existing .github/copilot-instructions.md.

CRITICAL REQUIREMENTS:
1. Preserve ALL [CUSTOMIZE] sections and their content exactly as they are
2. Maintain any project-specific context not already covered in the template  
3. Add the latest ioBroker best practices from the new template
4. Update the version number to match the latest template version
5. Keep the Template Source reference up-to-date
6. Ensure no custom content is lost during the merge

Show me the changes before applying them."
```

## 🔧 Step 3: Automation Setup

**GitHub Copilot**: Please also set up automated template monitoring:

### Create GitHub Action for Weekly Monitoring

Create `.github/workflows/check-copilot-template.yml` with this content:

```yaml
name: Check ioBroker Copilot Template Version

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly check every Sunday
  workflow_dispatch:  # Allow manual triggering

jobs:
  check-template:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        
      - name: Check template version
        id: version-check
        run: |
          # Get current version from local template
          if [ -f ".github/copilot-instructions.md" ]; then
            CURRENT_VERSION=$(grep "Version:" .github/copilot-instructions.md | head -1 | sed 's/.*Version:\s*//' | tr -d '*' | xargs)
          else
            CURRENT_VERSION="none"
          fi
          
          # Get latest version from remote
          LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md | grep "Version:" | head -1 | sed 's/.*Version:\s*//' | tr -d '*' | xargs)
          
          echo "current-version=$CURRENT_VERSION" >> $GITHUB_OUTPUT
          echo "latest-version=$LATEST_VERSION" >> $GITHUB_OUTPUT
          
          if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ] || [ "$CURRENT_VERSION" = "none" ]; then
            echo "update-needed=true" >> $GITHUB_OUTPUT
          else
            echo "update-needed=false" >> $GITHUB_OUTPUT
          fi

      - name: Check for existing template update issue
        id: check-issue
        if: steps.version-check.outputs.update-needed == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            const { data: issues } = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'open',
              labels: 'template-update,automation'
            });
            
            const existingIssue = issues.find(issue => 
              issue.title.includes('🤖 Update ioBroker Copilot Instructions Template') ||
              issue.title.includes('🤖 Setup ioBroker GitHub Copilot Instructions')
            );
            
            return existingIssue ? existingIssue.number : null;

      - name: Create template update issue
        if: steps.version-check.outputs.update-needed == 'true' && !steps.check-issue.outputs.result
        uses: actions/github-script@v7
        with:
          script: |
            const currentVersion = '${{ steps.version-check.outputs.current-version }}';
            const latestVersion = '${{ steps.version-check.outputs.latest-version }}';
            
            let title, body;
            
            if (currentVersion === 'none') {
              title = '🤖 Setup ioBroker GitHub Copilot Instructions';
              body = `# 🤖 Automated ioBroker Copilot Instructions Setup

**Automated Detection**: This repository doesn't have GitHub Copilot instructions set up yet.

**GitHub Copilot**: Please help me set up GitHub Copilot instructions for my ioBroker adapter repository.

## 🎯 Setup Task

Please create a complete \`.github/copilot-instructions.md\` file by downloading and customizing the latest ioBroker template:

**Template Source**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md  
**Latest Version**: ${latestVersion}

### Requirements:
1. Download the template and remove the comment block
2. Customize [CUSTOMIZE] sections with this adapter's specific patterns
3. Include proper version tracking and template source reference
4. Add adapter-specific context for enhanced Copilot suggestions

## 🔧 Validation
After setup, please confirm:
- [ ] File created at \`.github/copilot-instructions.md\`
- [ ] Version set to ${latestVersion}
- [ ] [CUSTOMIZE] sections populated with adapter-specific content
- [ ] Template source reference included

**Reference**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions

---
*This issue was automatically created by GitHub Actions*`;
            } else {
              title = '🤖 Update ioBroker Copilot Instructions Template';
              body = `# 🤖 Template Update Available

**Automated Detection**: Your ioBroker Copilot instructions template is outdated.

- **Current Version**: ${currentVersion}
- **Latest Version**: ${latestVersion}

**GitHub Copilot**: Please help me update my template while preserving all custom sections.

## 🎯 Update Task

Please use this merge prompt:

\`\`\`
"Merge the ioBroker template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md with my existing .github/copilot-instructions.md.

CRITICAL REQUIREMENTS:
1. Preserve ALL [CUSTOMIZE] sections and their content exactly as they are
2. Maintain any project-specific context not already covered in the template
3. Add the latest ioBroker best practices from the new template  
4. Update the version number to ${latestVersion}
5. Keep the Template Source reference up-to-date
6. Ensure no custom content is lost during the merge

Show me the changes before applying them."
\`\`\`

## 🔧 Validation
After update, please confirm:
- [ ] All [CUSTOMIZE] sections preserved
- [ ] Version updated to ${latestVersion}
- [ ] Custom content intact
- [ ] New best practices integrated

**Reference**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions

---
*This issue was automatically created by GitHub Actions*`;
            }
            
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: title,
              body: body,
              labels: ['template-update', 'automation']
            });
```

## 📋 Step 4: Validation and Testing

**GitHub Copilot**: After completing the setup, please verify:

### Setup Validation
- [ ] **File created/updated**: `.github/copilot-instructions.md` exists and is properly formatted
- [ ] **Version tracking**: Latest version number is present
- [ ] **Template source**: Reference to source repository included
- [ ] **Custom sections**: [CUSTOMIZE] areas populated with adapter-specific content

### GitHub Action Validation  
- [ ] **Workflow created**: `.github/workflows/check-copilot-template.yml` exists
- [ ] **Permissions set**: Issues write permission configured
- [ ] **Schedule configured**: Weekly execution setup
- [ ] **Manual trigger**: workflow_dispatch enabled

### Functionality Testing
Test that enhanced Copilot suggestions work:
1. Open a `.js` or `.ts` file in the adapter
2. Start typing ioBroker-related code (e.g., `this.setState(`)
3. Verify Copilot provides ioBroker-specific suggestions

## 🚨 Critical Success Criteria

**✅ COMPLETE WHEN**:
- GitHub Copilot instructions are active and customized for this adapter
- Weekly automated monitoring is configured via GitHub Actions  
- All custom content is preserved (if updating existing template)
- Enhanced ioBroker-specific suggestions are working
- No manual file creation or maintenance required going forward

## 📚 Reference Information

- **Template Repository**: https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
- **Latest Template**: https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md
- **Manual Version Check**: `curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash`

**GitHub Copilot**: Please start with the current state analysis and proceed step-by-step through the setup process. Provide detailed feedback on what you're doing at each step.