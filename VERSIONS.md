# Template and Example Versions

This file tracks the versions of all templates and examples in this repository following semantic versioning (semver) principles.

## Versioning Convention

All templates and examples follow semantic versioning (Major.Minor.Patch):
- **Major**: Breaking changes that require significant updates to existing implementations
- **Minor**: New features, enhancements, or non-breaking changes
- **Patch**: Bug fixes, documentation updates, or minor corrections

## Current Versions

### Examples

#### Basic Adapter Template
- **Version**: 0.1.0
- **Files**: 
  - `examples/basic-adapter/main.js`
  - `examples/basic-adapter/package.json`
  - `examples/basic-adapter/io-package.json`
  - `examples/basic-adapter/admin/jsonConfig.json`
  - `examples/basic-adapter/test/adapter.test.js`
- **Description**: Basic ioBroker adapter template with essential functionality
- **Release Date**: Initial release
- **Changes**: Initial template implementation

#### HTTP Client Example
- **Version**: 0.1.0
- **Files**: 
  - `examples/http-client/main.js`
- **Description**: HTTP/REST API client adapter example
- **Release Date**: Initial release
- **Changes**: Initial implementation with authentication, error handling, and data processing

#### MQTT Client Example
- **Version**: 0.1.0
- **Files**: 
  - `examples/mqtt-client/main.js`
- **Description**: MQTT broker client adapter example
- **Release Date**: Initial release  
- **Changes**: Initial implementation with auto-discovery and Home Assistant compatibility

#### Device Templates
- **Version**: 0.1.0
- **Files**: 
  - `examples/device-templates/deviceTemplates.js`
  - `examples/device-templates/usage-example.js`
- **Description**: Common device type template classes
- **Release Date**: Initial release
- **Changes**: Initial implementation with thermostat, light, sensor, media player, and blind templates

## Changelog Template

When updating versions, use this template in the respective file headers:

```javascript
/**
 * [Template/Example Name]
 * Version: X.Y.Z
 * 
 * [Description]
 * 
 * @version X.Y.Z
 * @since 0.1.0
 * @changelog
 * - X.Y.Z: [Changes made in this version]
 * - 0.1.0: Initial release
 */
```

## Version History

### 0.1.0 (Initial Release)
- **Date**: [Current Date]
- **Changes**: 
  - Initial implementation of all templates and examples
  - Basic adapter template with lifecycle management
  - HTTP client example with authentication
  - MQTT client example with auto-discovery
  - Device templates for common device types
  - Comprehensive testing examples
  - JSON configuration templates

## Usage Guidelines

1. **Check Version Compatibility**: Always check the version of templates you're using
2. **Update Tracking**: When modifying templates, increment versions appropriately
3. **Documentation**: Update this file when versions change
4. **Breaking Changes**: For major version changes, provide migration guides
5. **Backward Compatibility**: Minor versions should maintain backward compatibility

## References

For the latest versions and updates, refer to:
- Individual file headers for specific version information
- This version tracking file for complete overview
- Git commit history for detailed change tracking