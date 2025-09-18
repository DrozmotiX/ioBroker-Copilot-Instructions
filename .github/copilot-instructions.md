# ioBroker Adapter Development Instructions

You are an expert ioBroker adapter developer. Follow these guidelines when generating code, suggestions, and solutions for ioBroker adapters.

## ioBroker Architecture Knowledge

### Core Concepts
- **Adapters**: Software modules that connect ioBroker to external systems, devices, or services
- **States**: Data points in the ioBroker object tree (e.g., `adapter.0.device.temperature`)
- **Objects**: Metadata describing states, including type, role, unit, etc.
- **Instances**: Running copies of adapters with specific configurations
- **Admin Interface**: Web-based configuration interface using JSON-Config

### State Management
- Always use `await this.setStateAsync()` for setting states
- Use `await this.getStateAsync()` for reading states
- Create states with proper object definitions using `await this.setObjectNotExistsAsync()`
- Handle state changes in `onStateChange()` callback
- Use proper state acknowledgment (ack: true/false)

```javascript
// Good: Proper state creation and management
await this.setObjectNotExistsAsync('device.temperature', {
    type: 'state',
    common: {
        name: 'Temperature',
        type: 'number',
        role: 'value.temperature',
        unit: '°C',
        read: true,
        write: false
    },
    native: {}
});

await this.setStateAsync('device.temperature', { val: 23.5, ack: true });
```

### Object Structure
- Follow ioBroker naming conventions: `adapter.instance.device.channel.state`
- Use appropriate roles from the ioBroker role definitions
- Set correct types: boolean, number, string, array, object
- Include proper units for physical values
- Use meaningful names and descriptions

### Error Handling
- Always use try-catch blocks for async operations
- Log errors appropriately using `this.log.error()`
- Handle adapter termination gracefully in `onUnload()`
- Implement proper cleanup procedures

```javascript
// Good: Proper error handling
try {
    await this.setStateAsync('device.status', { val: 'connected', ack: true });
} catch (error) {
    this.log.error(`Failed to set state: ${error.message}`);
}
```

## Configuration Management

### JSON-Config
- Use JSON-Config for admin interface configuration
- Implement proper validation and default values
- Use appropriate input types: text, number, checkbox, select, etc.
- Group related settings using panels and tabs
- Implement conditional visibility with dependencies

```json
{
    "type": "panel",
    "label": "Connection Settings",
    "items": {
        "host": {
            "type": "text",
            "label": "Host Address",
            "default": "localhost",
            "required": true
        },
        "port": {
            "type": "number",
            "label": "Port",
            "default": 80,
            "min": 1,
            "max": 65535
        }
    }
}
```

### Native Configuration Access
- Access configuration via `this.config`
- Validate configuration on adapter start
- Handle configuration changes appropriately
- Use encryption for sensitive data

## Testing Best Practices

### Unit Testing
- Use Jest or Mocha for testing
- Mock ioBroker adapter functionality
- Test state management operations
- Test configuration validation
- Test error scenarios

```javascript
// Good: Unit test example
describe('Adapter Tests', () => {
    it('should create temperature state correctly', async () => {
        const adapter = new MockAdapter();
        await adapter.createTemperatureState('device1');
        
        expect(adapter.objects['device1.temperature']).toBeDefined();
        expect(adapter.objects['device1.temperature'].common.role).toBe('value.temperature');
    });
});
```

### Integration Testing
- Test with actual ioBroker installation when possible
- Use adapter-specific test scenarios
- Test admin interface functionality
- Verify proper cleanup and termination

## Type Detection Integration

### Using ioBroker Type Detector
- Integrate with @iobroker/type-detector for device recognition
- Use proper device patterns and state structures
- Follow type detector conventions for automatic device detection

```javascript
// Good: Type detector compatible structure
await this.setObjectNotExistsAsync('devices.thermostat1', {
    type: 'device',
    common: {
        name: 'Living Room Thermostat'
    },
    native: {}
});

await this.setObjectNotExistsAsync('devices.thermostat1.temperature', {
    type: 'state',
    common: {
        name: 'Current Temperature',
        type: 'number',
        role: 'value.temperature',
        unit: '°C',
        read: true,
        write: false
    },
    native: {}
});
```

## Development Workflow

### Code Structure
- Extend `utils.Adapter` class
- Implement required lifecycle methods: `onReady()`, `onUnload()`, `onStateChange()`
- Use TypeScript for better type safety and IDE support
- Follow ESLint rules and formatting standards

### Dependencies
- Use `@iobroker/adapter-core` for adapter base functionality
- Include necessary testing dependencies in devDependencies
- Keep dependencies up to date and secure
- Use semantic versioning

### Documentation
- Maintain comprehensive README.md
- Document all configuration options
- Provide usage examples
- Include troubleshooting guides

## Common Patterns

### Device Connection Management
```javascript
class MyAdapter extends utils.Adapter {
    constructor(options) {
        super({ ...options, name: 'my-adapter' });
        this.on('ready', this.onReady.bind(this));
        this.on('stateChange', this.onStateChange.bind(this));
        this.on('unload', this.onUnload.bind(this));
    }

    async onReady() {
        // Initialize connection
        await this.connectToDevice();
        
        // Create states
        await this.createStates();
        
        // Start polling or event listening
        this.startDataCollection();
    }

    async onUnload(callback) {
        try {
            // Cleanup connections and intervals
            this.disconnect();
            callback();
        } catch (error) {
            callback();
        }
    }
}
```

### State Change Handling
```javascript
async onStateChange(id, state) {
    if (!state || state.ack) return;
    
    try {
        const idParts = id.split('.');
        const command = idParts[idParts.length - 1];
        
        switch (command) {
            case 'power':
                await this.setPowerState(state.val);
                break;
            case 'temperature':
                await this.setTemperature(state.val);
                break;
        }
        
        // Acknowledge the command
        await this.setStateAsync(id, { val: state.val, ack: true });
    } catch (error) {
        this.log.error(`Error handling state change: ${error.message}`);
    }
}
```

## Security Considerations
- Never log sensitive information (passwords, tokens)
- Use encrypted storage for credentials when possible
- Validate all external inputs
- Implement proper authentication for network connections
- Follow secure coding practices

## Performance Guidelines
- Use efficient polling intervals
- Implement proper connection pooling
- Cache frequently accessed data appropriately
- Use bulk operations when possible
- Monitor memory usage and prevent leaks

## Debugging
- Use meaningful log levels: silly, debug, info, warn, error
- Include context information in log messages
- Use adapter debugging features
- Implement health check mechanisms

Remember to always follow ioBroker community standards and contribute back to the ecosystem when possible. Generate code that is maintainable, well-documented, and follows these established patterns and best practices.