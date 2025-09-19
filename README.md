# ioBroker Copilot Instructions

> A comprehensive template and best practices library for using GitHub Copilot in ioBroker adapter development

## 🎯 About This Repository

This repository serves the ioBroker community by providing standardized GitHub Copilot instructions for adapter development. We maintain templates and best practices to help developers create better ioBroker adapters more efficiently.

**What this template provides:**
- **Standardized patterns** for consistent ioBroker adapter development
- **Proven best practices** from experienced community developers
- **GitHub Copilot integration** that understands ioBroker conventions
- **Community-driven improvements** based on real-world usage
- **Version-controlled templates** with automated updates

## 🤝 Join Our Community

**Help us improve ioBroker adapter development together!**

- **[ioBroker Community Forum](https://forum.iobroker.net/topic/82238/ki-trifft-iobroker-ein-gemeinsames-abenteuer)** - Share experiences and collaborate on improving adapter development
- **[Submit Issues](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/issues)** - Report bugs, suggest improvements, or request new features
- **[GitHub Discussions](https://github.com/DrozmotiX/ioBroker-Copilot-Instructions/discussions)** - Share ideas, ask questions, and collaborate on best practices

Your contributions help make adapter development better for the entire ioBroker community!

## 🚀 What is ioBroker?

[ioBroker](https://www.iobroker.net/) is a powerful integration platform for the Internet of Things (IoT), designed to connect various smart home devices, services, and systems into a unified automation platform. Adapters are the core components that enable ioBroker to communicate with different technologies and services.

## 📋 Quick Start

**🚀 Fully Automated Setup** (Recommended for all users):

### For New Repositories or Comprehensive Setup
1. **Create an automated setup issue** with this simple content:
   ```
   Title: 🤖 Setup ioBroker GitHub Copilot Instructions
   
   GitHub Copilot: Please help me set up GitHub Copilot instructions for my ioBroker adapter repository using the centralized automation template from:
   templates/initial-setup-automation.md
   ```
2. **Let GitHub Copilot handle everything** using our **centralized automation system**:
   - ✅ Validates existing setup and detects repository status
   - 📥 Downloads and customizes latest template using metadata.json
   - 🎯 Adds adapter-specific content with intelligent customization
   - ⚙️ Sets up weekly monitoring with centralized GitHub Action
   - 🛡️ Preserves any existing customizations automatically
   - 🚫 **Avoids manual scripts** (replaces approaches like validation scripts in package.json)

### For Quick Updates Only  
1. **Create a quick update issue** with this simple content:
   ```
   Title: 🤖 Update ioBroker Copilot Instructions Template
   
   GitHub Copilot: Please help me update my ioBroker Copilot instructions using the template from:
   templates/copy-paste-template.md
   ```
2. **GitHub Copilot will merge** the latest template while preserving your customizations

## 📚 Documentation

### 🛠️ For Developers
- **[Setup Guide](docs/setup.md)** - Automated GitHub Copilot setup and template integration 
- **[Automated Templates](templates/README.md)** - Complete guide to all automation templates
- **[Testing Guide](docs/testing.md)** - Validate your template integration and Copilot functionality

### 🔧 For Repository Maintainers  
- **[Maintenance Guide](docs/maintenance.md)** - Version management, testing infrastructure, and release processes
- **[Technical Testing](TESTING.md)** - Detailed testing infrastructure documentation (54+ automated tests)

## 🔄 Automated Template Management

### ⚡ Zero Manual Steps Required

All template operations are now fully automated:

- **✅ Setup**: Automated via [Initial Setup Template](templates/initial-setup-automation.md)
- **🔄 Updates**: Automated via GitHub Actions with issue creation  
- **🛡️ Customizations**: Always preserved during updates
- **📅 Monitoring**: Weekly checks with automatic notifications

### Automated Continuous Monitoring

The [Initial Setup Template](templates/initial-setup-automation.md) automatically configures:
- 📅 Weekly version checking via GitHub Actions
- 🎯 Automatic issue creation when updates are available  
- 🛡️ Safe updates that preserve all custom content
- 🚫 Prevention of duplicate update issues

## 💡 Key Features

### ⚡ **Full Automation**
- **Zero Manual Configuration**: All setup handled by GitHub Copilot
- **Smart Detection**: Automatically detects existing setups and customizations
- **Safe Updates**: Custom content always preserved during template updates

### 🛡️ **Customization Protection**  
- **[CUSTOMIZE] Sections**: Marked areas that are automatically preserved
- **Adapter-Specific Content**: Automatically added based on your repository context
- **Version Tracking**: Automatic version management and source references

### 📅 **Continuous Monitoring**
- **Weekly Checks**: GitHub Actions monitor for template updates
- **Automatic Issues**: Update notifications created automatically
- **No Maintenance**: Set once, works forever

### 🎯 **Enhanced Development**
- **ioBroker-Specific Suggestions**: Context-aware code completion
- **Best Practices**: Integrated patterns from experienced developers
- **Testing Integration**: Smart suggestions for `@iobroker/testing` framework

## 📊 Version Information

- **Current Template Version:** ![Version](https://img.shields.io/github/package-json/v/DrozmotiX/ioBroker-Copilot-Instructions?label=v)
- **Template Location:** [`template.md`](template.md)

Your template version is automatically tracked in your `.github/copilot-instructions.md` file:

```markdown
**Version:** 0.4.0
**Template Source:** https://github.com/DrozmotiX/ioBroker-Copilot-Instructions
```

## 📚 What's Included in the Template

The Copilot instruction template covers comprehensive guidance for:

### 🧪 Testing Guidelines
- Unit testing with Jest framework
- **Official @iobroker/testing framework** - Complete integration testing patterns following official guidelines
- Mocking strategies for ioBroker adapters
- Error handling test scenarios
- **API testing with credentials** - Password encryption and demo credential patterns
- **Enhanced test failure handling** - Clear, actionable error messages for debugging
- **CI/CD integration** - Separate jobs for credential-based API testing

### 📖 README Standards
- Required documentation sections for ioBroker adapters
- Multi-language support guidelines
- Configuration documentation patterns
- User-friendly examples and usage instructions
- **Mandatory PR documentation** - WORK IN PROGRESS section requirements
- **Standardized changelog format** - Consistent categorization and user-focused descriptions

### 📦 Dependency Management
- Best practices for npm package management
- Security and audit guidelines
- Preferred libraries and alternatives for ioBroker ecosystem
- Version management strategies

### ⚙️ JSON-Config Admin Interface
- Modern admin interface development patterns
- Configuration schema patterns
- Validation and error handling
- User experience guidelines

### 🔧 Best Practices
- Preference for native Node.js APIs (like `fetch` over `axios`)
- Minimal dependency strategies
- Performance considerations
- Security best practices for ioBroker adapters

## 🤝 How This Enhances ioBroker Development

By integrating GitHub Copilot with these specialized instructions, ioBroker adapter developers benefit from:

- **Context-aware suggestions** specific to ioBroker development patterns
- **Consistent code style** across the ioBroker ecosystem
- **Best practice enforcement** through AI-guided development
- **Reduced development time** with intelligent code completion
- **Knowledge transfer** from experienced to new developers
- **Quality assurance** through established patterns and practices

## 🔧 Advanced Usage

For advanced users who want more control over the template management process:

### Manual Version Check

For repository diagnostics or manual validation:

```bash
# Download and run the version check script
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

This script will:
- Compare your local template version with the latest available from metadata.json
- Provide update guidance if your template is outdated
- Show you what's changed in newer versions

**Note**: The centralized automation system eliminates the need for manual scripts in your repository (avoiding patterns like validation scripts in package.json).

### Repository Maintenance

For repository maintainers who want to contribute or customize the template system:

- **Version Management**: See the [maintenance guide](docs/maintenance.md) for version management scripts
- **Testing**: Run `./tests/test-runner.sh` for comprehensive testing
- **Custom Snippets**: Create reusable content in the `snippets/` directory
- **Centralized Configuration**: Modify `config/metadata.json` for repository-wide settings

## 🌟 Contributing

We welcome contributions to improve these instructions! Please:

1. Fork this repository
2. Create a feature branch  
3. Make your improvements
4. **Run the test suite**: `./tests/test-runner.sh` to ensure all tests pass
5. **Update documentation**: Add changelog entries and update README if needed
6. Test with real ioBroker adapter development
7. Submit a pull request with a clear description of changes

**For maintainers**: See the [maintenance guide](docs/maintenance.md) for detailed development guidelines and testing requirements.

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