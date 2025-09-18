# ioBroker Copilot Instructions

> A track & traceable library of best practices for using GitHub Copilot to support ioBroker adapter development

## 🎯 Goal of this Repository

This repository provides comprehensive guidance and best practices for leveraging GitHub Copilot in ioBroker adapter development. By using these standardized instructions, developers can:

- **Accelerate development** with AI-powered code suggestions tailored for ioBroker
- **Maintain consistency** across different adapter projects
- **Follow established patterns** and avoid common pitfalls
- **Improve code quality** through proven best practices
- **Reduce learning curve** for new ioBroker adapter developers

## 🚀 What is ioBroker?

[ioBroker](https://www.iobroker.net/) is a powerful integration platform for the Internet of Things (IoT), designed to connect various smart home devices, services, and systems into a unified automation platform. Adapters are the core components that enable ioBroker to communicate with different technologies and services.

## Prerequisites and Basic GitHub Copilot Setup

Before using this template, ensure you have GitHub Copilot properly set up in your repository. If you're new to GitHub Copilot, follow these steps:

### Step 1: GitHub Copilot Subscription & Installation

1. **Subscribe to GitHub Copilot**
   - Visit [GitHub Copilot](https://github.com/features/copilot) and subscribe to GitHub Copilot Individual or Business
   - Ensure your subscription is active and includes your target repository

2. **Install GitHub Copilot Extension**
   - **VS Code**: Install the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
   - **JetBrains IDEs**: Install GitHub Copilot from the plugin marketplace
   - **Vim/Neovim**: Use the [copilot.vim](https://github.com/github/copilot.vim) plugin
   - **Other editors**: Check [GitHub Copilot documentation](https://docs.github.com/en/copilot) for your editor

3. **Authenticate GitHub Copilot**
   - Open your editor and sign in to GitHub Copilot when prompted
   - Verify authentication by typing code in any file - you should see Copilot suggestions

### Step 2: Repository Setup & Validation

1. **Enable Copilot for Your Repository**
   ```bash
   # Navigate to your ioBroker adapter repository
   cd your-iobroker-adapter
   
   # Ensure you're logged into GitHub CLI (optional but recommended)
   gh auth login
   ```

2. **Create Basic GitHub Copilot Structure**
   ```bash
   # Create .github directory if it doesn't exist
   mkdir -p .github
   
   # Verify Copilot can access your repository
   # Open any .js/.ts file and start typing - you should see suggestions
   ```

3. **Verify Copilot is Working**
   - Open a JavaScript or TypeScript file in your repository
   - Start typing a function or comment
   - You should see grayed-out suggestions from Copilot
   - Press `Tab` to accept suggestions or `Esc` to dismiss

### Step 3: Test Basic Functionality

Create a simple test to verify Copilot is working with your repository:

```javascript
// Create a file test-copilot.js and start typing this comment:
// Function to add two numbers

// Copilot should suggest a function implementation when you press Enter
```

**Expected behavior:** Copilot should suggest code completions as you type.

### Step 4: Repository Permissions (For Organizations)

If your repository is part of an organization:

1. **Check Organization Settings**
   - Go to your GitHub organization settings
   - Navigate to "Copilot" in the left sidebar
   - Ensure your repository is included in the allowed repositories

2. **Verify Team Access**
   - Ensure your team has Copilot access enabled
   - Check that repository access policies allow Copilot usage

### Troubleshooting Basic Setup

| Problem | Solution |
|---------|----------|
| No suggestions appear | Check authentication and subscription status |
| Repository not accessible | Verify organization settings and permissions |
| Extension not working | Reinstall Copilot extension and restart editor |
| Authentication issues | Sign out and sign back in to GitHub Copilot |

**✅ Setup Complete!** Once you have Copilot working and showing suggestions in your repository, you can proceed to integrate the ioBroker template below.

### Quick Reference Checklist

For experienced GitHub Copilot users, here's a quick checklist:

- [ ] GitHub Copilot subscription is active
- [ ] Copilot extension installed in your editor
- [ ] Authentication completed (can see suggestions when typing)
- [ ] Repository permissions configured (for organizations)
- [ ] Basic functionality tested (suggestions appear in .js/.ts files)
- [ ] Ready to integrate ioBroker template

**New to GitHub Copilot?** Follow the detailed [Prerequisites & Basic Setup](#🛠️-prerequisites--basic-github-copilot-setup) above.

## 📋 How to Use This Template

### Quick Start

> **⚠️ Prerequisites Required:** Before proceeding, ensure you've completed the [Basic GitHub Copilot Setup](#🛠️-prerequisites--basic-github-copilot-setup) above.

1. **For Existing Copilot Users (Recommended)**
   - If you already have a `.github/copilot-instructions.md` file, merge the content from this template rather than replacing it
   - Use GitHub Copilot to help you merge the instructions: "Merge my existing copilot instructions with the template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions maintaining project-specific context"
   - Add the template version reference to track updates

2. **For New Copilot Users**
   - Download the latest version of [`template.md`](template.md)
   - Save it as `.github/copilot-instructions.md` in your adapter repository's `.github/` folder
   - Customize sections marked with `[CUSTOMIZE]` for your specific adapter requirements

3. **Verification & Activation**
   - Verify GitHub Copilot is working in your repository (should show suggestions when typing)
   - The ioBroker-specific instructions will automatically be used by Copilot when working in your codebase
   - Test by opening a JavaScript file and typing ioBroker-related code - you should see relevant suggestions

### Integration Steps

> **⚠️ Important:** Ensure GitHub Copilot is working in your repository before proceeding. If you need setup help, see the [Prerequisites & Basic Setup](#🛠️-prerequisites--basic-github-copilot-setup) section above.

**For repositories with existing Copilot instructions:**
```bash
# Navigate to your ioBroker adapter repository
cd your-iobroker-adapter

# Verify Copilot is working (should show suggestions when you type)
# Open any .js file and type: // Function to connect to ioBroker
# You should see Copilot suggestions appear

# Ask GitHub Copilot to merge the instructions
# Use the following prompt in your editor:
# "Merge my existing .github/copilot-instructions.md with the ioBroker template 
# from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md
# Keep project-specific content and add version: 0.4.0"
# NOTE: Exclude the HTML comment block at the top of the template"
```

**For new repositories (first-time Copilot setup):**
```bash
# Navigate to your ioBroker adapter repository
cd your-iobroker-adapter

# Verify basic Copilot setup is complete
# Open any .js file and start typing - you should see suggestions
# If no suggestions appear, complete the basic setup first

# Create .github directory if it doesn't exist
mkdir -p .github

# Download the latest template
curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/template.md

# Remove the template comment block at the top (lines starting with <!--)
sed -i '/^<!--$/,/^-->$/d' .github/copilot-instructions.md

# Commit the changes
git add .github/copilot-instructions.md
git commit -m "Add GitHub Copilot instructions for ioBroker development"
git push
```

### Validation & Testing

After completing the integration, verify everything is working correctly:

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

**Expected Results:**
- Copilot suggestions should be more relevant to ioBroker development
- Error handling should follow ioBroker patterns
- Test suggestions should include `@iobroker/testing` framework usage
- README updates should follow ioBroker documentation standards

## 🔄 Template Versioning

To ensure you're using the latest best practices and that your local copy stays synchronized with improvements:

### Current Version
- **Latest Version:** v0.4.0
- **Template Location:** [`template.md`](template.md)
- **Last Updated:** September 2025

### Version Checking

You can validate your local template version by checking the version header in your `.github/copilot-instructions.md` file:

```markdown
**Version:** 0.4.0
**Template Source:** https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
```

### Updating Your Template

To update to the latest version:

1. **Check for updates** in this repository
2. **Compare versions** between your local copy and the latest release
3. **Download the new template** and replace your local version
4. **Review changes** to understand what improvements were made
5. **Test** to ensure compatibility with your project

### Automated Validation

#### Quick Version Check Script

You can use the provided script to check your template version:

```bash
# Download and run the version check script
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

#### Version Management for Repository Maintainers

This repository includes comprehensive version management scripts that automatically handle version consistency across all documentation:

```bash
# Show current versions across all files
./scripts/manage-versions.sh show

# Check for version inconsistencies
./scripts/manage-versions.sh check

# Sync documentation with current template version (updates dates and versions dynamically)
./scripts/manage-versions.sh sync

# Update to a new version across all files
./scripts/manage-versions.sh update 0.3.2
```

These scripts ensure that:
- Version numbers are dynamically pulled from the template
- Documentation dates stay current
- All cross-references remain consistent
- Manual version updates are no longer needed

### Automated Testing Infrastructure

This repository includes a comprehensive automated testing framework that ensures all scripts and automations work correctly:

```bash
# Run all tests (54 total tests)
./tests/test-runner.sh

# Run specific test file
./tests/test-runner.sh tests/test-extract-version.sh

# Tests are automatically run in CI/CD via GitHub Actions
```

**Test Coverage:**
- **Unit Tests**: Individual script functions and parameter validation
- **Integration Tests**: Cross-script workflows and end-to-end scenarios  
- **Error Handling Tests**: Missing files, invalid parameters, network failures
- **Consistency Tests**: Version synchronization and file state validation

**Key Features:**
- **Isolated Test Environments**: Each test run uses temporary directories to prevent interference
- **Comprehensive Reporting**: Color-coded output with detailed error messages and debugging information
- **CI/CD Integration**: Automated testing on all repository changes via `.github/workflows/test-scripts.yml`
- **Developer Friendly**: Simple commands with clear documentation in `TESTING.md`

All repository scripts are thoroughly tested to prevent regressions and ensure reliability for the ioBroker community.

#### GitHub Action for Continuous Monitoring

You can set up a GitHub Action to periodically check if your template is up-to-date:

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

## 📚 What's Included

The Copilot instruction template covers:

### 🧪 Testing Guidelines
- Unit testing with Jest framework
- **Official @iobroker/testing framework** - Complete integration testing patterns following official guidelines
- Mocking strategies for ioBroker adapters
- Error handling test scenarios
- **API testing with credentials** - Password encryption and demo credential patterns
- **Enhanced test failure handling** - Clear, actionable error messages for debugging
- **CI/CD integration** - Separate jobs for credential-based API testing

### 📖 README Standards
- Required documentation sections
- Multi-language support guidelines
- Configuration documentation patterns
- User-friendly examples and usage instructions
- **Mandatory PR documentation** - WORK IN PROGRESS section requirements
- **Standardized changelog format** - Consistent categorization and user-focused descriptions

### 📦 Dependency Management
- Best practices for npm package management
- Security and audit guidelines
- Preferred libraries and alternatives
- Version management strategies

### ⚙️ JSON-Config Admin Interface
- Modern admin interface development
- Configuration schema patterns
- Validation and error handling
- User experience guidelines

### 🔧 Dependency Best Practices
- Preference for native Node.js APIs (like `fetch` over `axios`)
- Minimal dependency strategies
- Performance considerations
- Security best practices

## 🤝 How This Supports ioBroker Development

By integrating GitHub Copilot with these specialized instructions, ioBroker adapter developers benefit from:

- **Context-aware suggestions** specific to ioBroker development patterns
- **Consistent code style** across the ioBroker ecosystem
- **Best practice enforcement** through AI-guided development
- **Reduced development time** with intelligent code completion
- **Knowledge transfer** from experienced to new developers
- **Quality assurance** through established patterns and practices

## 🌟 Contributing

We welcome contributions to improve these instructions! Please:

1. Fork this repository
2. Create a feature branch
3. Make your improvements
4. **Run the test suite**: `./tests/test-runner.sh` to ensure all tests pass
5. **Update documentation**: Add changelog entries and update README if needed
6. Test with real ioBroker adapter development
7. Submit a pull request with a clear description of changes

### Development Guidelines

- All new scripts must have corresponding tests in the `tests/` directory
- Changes to existing scripts require updating relevant test cases
- Follow the testing patterns documented in `TESTING.md`
- Ensure all 54 tests pass before submitting PRs

## 🙏 Acknowledgments

- **@ticaki** - For providing comprehensive lessons learned and best practices for ioBroker integration testing framework
- **ioBroker Community** - For continuous feedback and real-world testing scenarios
- **GitHub Copilot Team** - For enabling AI-powered development assistance

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Links

- [ioBroker Official Website](https://www.iobroker.net/)
- [ioBroker GitHub Organization](https://github.com/ioBroker)
- [ioBroker Developer Documentation](https://github.com/ioBroker/ioBroker.docs)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)

## 💬 Support

- **Issues**: Report bugs or request features in [GitHub Issues](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/issues)
- **Discussions**: Join conversations in [GitHub Discussions](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/discussions)
- **ioBroker Community**: Visit the [ioBroker Forum](https://forum.iobroker.net/)