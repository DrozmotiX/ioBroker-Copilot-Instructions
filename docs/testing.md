# Testing Documentation for Users

This document provides testing information relevant to users of the ioBroker Copilot Instructions template. For detailed technical testing infrastructure, see [TESTING.md](../TESTING.md).

## 📋 Table of Contents

- [Testing Your Template Integration](#testing-your-template-integration)
- [Validating Copilot Instructions](#validating-copilot-instructions)
- [Automated Template Version Checking](#automated-template-version-checking)
- [Testing Best Practices](#testing-best-practices)

## Testing Your Template Integration

After integrating the ioBroker Copilot Instructions template into your adapter repository, use these tests to verify everything is working correctly.

### Basic Functionality Test

```bash
# Test that Copilot uses the ioBroker instructions
# 1. Open any .js or .ts file in your adapter
# 2. Start typing ioBroker-related code:
#    Example: // Create new ioBroker adapter instance
#    Example: this.setState(
#    Example: // Handle device connection

# 3. Copilot should now provide ioBroker-specific suggestions
# 4. Check that suggestions follow the patterns from the template
```

### Expected Results

After successful integration, you should observe:

- **Context-aware suggestions** specific to ioBroker development patterns
- **Error handling** that follows ioBroker best practices
- **Test suggestions** that include `@iobroker/testing` framework usage
- **README updates** that follow ioBroker documentation standards
- **Dependency management** suggestions aligned with ioBroker ecosystem

### Testing Scenarios

#### 1. Adapter Instance Creation
```javascript
// Type this comment in a JavaScript file:
// Create new ioBroker adapter instance

// Expected: Copilot should suggest ioBroker adapter initialization patterns
```

#### 2. State Management
```javascript
// Type this code:
this.setState(

// Expected: Copilot should suggest proper ioBroker state setting patterns
```

#### 3. Error Handling
```javascript
// Type this comment:
// Handle connection error

// Expected: Copilot should suggest ioBroker-appropriate error handling
```

#### 4. Testing Framework
```javascript
// Type this comment:
// Write integration test

// Expected: Copilot should suggest @iobroker/testing framework patterns
```

## Validating Copilot Instructions

### Template Version Verification

Check that your template includes the correct version information:

```bash
# Verify your local template version
grep "Version:" .github/copilot-instructions.md | head -1
```

Expected output should show the current version:
```
**Version:** 0.4.0
```

### Template Source Verification

Ensure your template references the correct source:

```bash
# Check template source reference
grep "Template Source:" .github/copilot-instructions.md | head -1
```

Expected output:
```
**Template Source:** https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
```

### Content Validation

Verify key sections are present in your template:

```bash
# Check for essential sections
grep -E "## (Testing|README Updates|Dependency Updates|JSON-Config|Error Handling)" .github/copilot-instructions.md
```

## Automated Template Version Checking

### Quick Version Check

Use the provided script to check if your template is up-to-date:

```bash
# Download and run the version check script
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

This script will:
- Compare your local template version with the latest available
- Provide update guidance if your template is outdated
- Show you what's changed in newer versions

### Setting Up Automated Checking

Add this GitHub Action to automatically monitor your template version:

```yaml
# .github/workflows/check-copilot-template.yml
name: Check Copilot Template Version
on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly check
  workflow_dispatch:

jobs:
  check-template:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check template version
        run: |
          CURRENT_VERSION=$(grep "Version:" .github/copilot-instructions.md | head -1 | sed 's/.*Version:\s*//')
          LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md | grep "Version:" | head -1 | sed 's/.*Version:\s*//')
          if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
            echo "Template is outdated. Current: $CURRENT_VERSION, Latest: $LATEST_VERSION"
            exit 1
          fi
```

## Testing Best Practices

### Regular Testing Schedule

- **Weekly**: Test basic Copilot functionality with ioBroker patterns
- **Monthly**: Check for template updates and validate suggestions quality
- **Before releases**: Ensure Copilot suggestions align with your adapter's specific patterns

### Documentation Testing

When updating your adapter documentation, verify that Copilot suggestions:

1. **Follow ioBroker standards**: Suggestions should match community conventions
2. **Include required sections**: Installation, Configuration, Usage, Changelog, License, Support
3. **Use proper formatting**: README entries should follow the `## **WORK IN PROGRESS**` pattern
4. **Reference issues**: Changelog entries should include issue references (fixes #XX)

### Code Quality Testing

Regularly verify that Copilot suggestions:

- Use `@iobroker/adapter-core` for base functionality
- Prefer built-in Node.js modules when possible
- Include proper error handling for ioBroker contexts
- Follow established ioBroker adapter patterns

### Integration Testing

Test Copilot suggestions for:

- **CI/CD integration**: GitHub Actions workflows for ioBroker adapters
- **Testing frameworks**: `@iobroker/testing` usage patterns
- **Dependency management**: npm best practices for ioBroker ecosystem
- **Security practices**: Credential handling and API testing patterns

### Performance Testing

Monitor Copilot performance with your template:

- **Response time**: Suggestions should appear promptly
- **Relevance**: Suggestions should be contextually appropriate
- **Accuracy**: Code suggestions should be syntactically correct
- **Consistency**: Similar contexts should produce similar suggestions

### Troubleshooting Common Issues

#### Copilot Not Using Template Instructions

**Symptoms**: Suggestions don't reflect ioBroker patterns
**Solutions**:
1. Verify `.github/copilot-instructions.md` exists and is properly formatted
2. Check that the template version is current
3. Restart your editor to reload Copilot instructions
4. Ensure the file is committed to your repository

#### Generic Suggestions Instead of ioBroker-Specific

**Symptoms**: Suggestions are too generic or don't match ioBroker conventions
**Solutions**:
1. Check template integration completeness
2. Verify customization sections marked with `[CUSTOMIZE]` are properly configured
3. Ensure your code context clearly indicates ioBroker development
4. Test with more specific ioBroker-related comments and code

#### Outdated Suggestions

**Symptoms**: Suggestions reference old patterns or deprecated methods
**Solutions**:
1. Update to the latest template version
2. Review changelog for breaking changes or new best practices
3. Clear Copilot cache if available in your editor
4. Verify your local template matches the latest repository version

---

**For setup instructions**, see the [setup guide](setup.md). **For technical testing details**, consult [TESTING.md](../TESTING.md). **Return to the [main README](../README.md)** for overview and navigation.