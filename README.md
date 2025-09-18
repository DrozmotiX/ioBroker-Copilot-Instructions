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

## 📋 How to Use This Template

### Quick Start

1. **Integrate Copilot Instructions (Recommended)**
   - If you already have a `.github/copilot-instructions.md` file, merge the content from this template rather than replacing it
   - Use GitHub Copilot to help you merge the instructions: "Merge my existing copilot instructions with the template from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions maintaining project-specific context"
   - Add the template version reference to track updates

2. **New Repository Setup**
   - Download the latest version of [`template.md`](template.md)
   - Save it as `.github/copilot-instructions.md` in your adapter repository's `.github/` folder
   - Customize sections marked with `[CUSTOMIZE]` for your specific adapter requirements

3. **Enable GitHub Copilot**
   - Ensure GitHub Copilot is enabled for your repository
   - The instructions will automatically be used by Copilot when working in your codebase

### Integration Steps

**For repositories with existing Copilot instructions:**
```bash
# Navigate to your ioBroker adapter repository
cd your-iobroker-adapter

# Ask GitHub Copilot to merge the instructions
# Use the following prompt in your editor:
# "Merge my existing .github/copilot-instructions.md with the ioBroker template 
# from https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/blob/main/template.md
# Keep project-specific content and add version: 0.3.0
# NOTE: Exclude the HTML comment block at the top of the template"
```

**For new repositories:**
```bash
# Navigate to your ioBroker adapter repository
cd your-iobroker-adapter

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

## 🔄 Template Versioning

To ensure you're using the latest best practices and that your local copy stays synchronized with improvements:

### Current Version
- **Latest Version:** v0.3.0
- **Template Location:** [`template.md`](template.md)
- **Last Updated:** January 2025

### Version Checking

You can validate your local template version by checking the version header in your `.github/copilot-instructions.md` file:

```markdown
**Version:** 0.3.0
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
4. Test with real ioBroker adapter development
5. Submit a pull request with a clear description of changes

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