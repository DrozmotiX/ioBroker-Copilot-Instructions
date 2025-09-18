# ioBroker Copilot Instructions

> A comprehensive template and best practices library for using GitHub Copilot in ioBroker adapter development

## 🎯 Goal of this Repository

This repository provides comprehensive guidance and best practices for leveraging GitHub Copilot in ioBroker adapter development. By using these standardized instructions, developers can:

- **Accelerate development** with AI-powered code suggestions tailored for ioBroker
- **Maintain consistency** across different adapter projects
- **Follow established patterns** and avoid common pitfalls
- **Improve code quality** through proven best practices
- **Reduce learning curve** for new ioBroker adapter developers

## 🚀 What is ioBroker?

[ioBroker](https://www.iobroker.net/) is a powerful integration platform for the Internet of Things (IoT), designed to connect various smart home devices, services, and systems into a unified automation platform. Adapters are the core components that enable ioBroker to communicate with different technologies and services.

## 📋 Quick Start

> **New to GitHub Copilot?** Start with the [detailed setup guide](docs/setup.md) to get GitHub Copilot working in your repository first.

**For experienced Copilot users:**

1. **Download the template**: Get the latest [`template.md`](template.md)
2. **Integrate**: Save as `.github/copilot-instructions.md` in your adapter repository  
3. **Customize**: Modify sections marked with `[CUSTOMIZE]`
4. **Verify**: Test that Copilot provides ioBroker-specific suggestions

**Current Version:** v0.4.0 | **Template:** [`template.md`](template.md) | **Last Updated:** September 2025

## 📚 Documentation

### 🛠️ For Developers
- **[Setup Guide](docs/setup.md)** - Complete GitHub Copilot setup and template integration
- **[Testing Guide](docs/testing.md)** - Validate your template integration and Copilot functionality

### 🔧 For Repository Maintainers  
- **[Maintenance Guide](docs/maintenance.md)** - Version management, testing infrastructure, and release processes
- **[Technical Testing](TESTING.md)** - Detailed testing infrastructure documentation (54+ automated tests)

## 🔄 Template Versioning & Updates

### Quick Version Check

Check if your template is up-to-date:

```bash
# Download and run the version check script
curl -s https://raw.githubusercontent.com/DrozmotiX/ioBroker-Copilot-Instructions/main/scripts/check-template-version.sh | bash
```

### Updating Your Template

To update to the latest version:

1. **Check for updates** in this repository
2. **Compare versions** between your local copy and the latest release
3. **Download the new template** and replace your local version
4. **Review changes** to understand what improvements were made
5. **Test** to ensure compatibility with your project

### Version Information

- **Latest Version:** v0.4.0
- **Template Location:** [`template.md`](template.md)  
- **Last Updated:** September 2025

You can validate your local template version by checking the version header in your `.github/copilot-instructions.md` file:

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