# Device Templates

This directory contains ready-to-use device template classes for common ioBroker device types. These templates are designed to be compatible with the ioBroker type detector and follow best practices for object structure and naming conventions.

## Available Templates

### BaseDevice
The base class that all other device templates extend. Provides common functionality like:
- Device object creation
- State management helpers
- Common device properties (online status, info channel)

### ThermostatDevice
Template for heating/cooling control devices featuring:
- Current and target temperature
- Heating/cooling status indicators
- Operation mode control (off, heat, cool, auto)
- Fan mode control
- Type detector compatible structure

```javascript
const thermostat = new ThermostatDevice(
    adapter, 
    'living_room_thermostat', 
    'Living Room Thermostat'
);
await thermostat.createDeviceStates();
```

### LightDevice
Template for switches and dimmable lights with optional features:
- Basic on/off control
- Brightness control (for dimmable lights)
- Color control (RGB, HSV, color temperature)
- Configurable features (dimmable, colorControl)

```javascript
const light = new LightDevice(
    adapter,
    'bedroom_light',
    'Bedroom Light',
    { dimmable: true, colorControl: true }
);
await light.createDeviceStates();
```

### SensorDevice
Template for various sensor types:
- Flexible sensor type configuration
- Support for multiple sensor values per device
- Battery level and signal strength (for wireless sensors)
- Common sensor types: temperature, humidity, motion, door, etc.

```javascript
const sensor = new SensorDevice(
    adapter,
    'weather_sensor',
    'Weather Station',
    ['temperature', 'humidity', 'pressure'],
    { hasBattery: true }
);
await sensor.createDeviceStates();
```

### MediaPlayerDevice
Template for audio/video devices:
- Playback controls (play, pause, stop, next, previous)
- Volume and mute control
- Track information display
- Position/seek functionality
- Playback state management

```javascript
const player = new MediaPlayerDevice(
    adapter,
    'living_room_player',
    'Living Room Player'
);
await player.createDeviceStates();
```

### BlindDevice
Template for motorized window coverings:
- Position control (0-100%)
- Direction control (up, down, stop)
- Convenience commands (open, close)
- Movement status indicator

```javascript
const blind = new BlindDevice(
    adapter,
    'window_blind',
    'Living Room Blind'
);
await blind.createDeviceStates();
```

## Usage Examples

### Basic Usage
```javascript
const { ThermostatDevice } = require('./deviceTemplates');

// In your adapter's onReady method
const thermostat = new ThermostatDevice(
    this,           // adapter instance
    'device_id',    // unique device identifier
    'Device Name',  // human-readable device name
    { /* config */ } // optional device configuration
);

// Create all device states
await thermostat.createDeviceStates();

// Store device instance for state change handling
this.devices.set('device_id', thermostat);
```

### Handling State Changes
```javascript
async onStateChange(id, state) {
    if (!state || state.ack) return;

    // Parse device ID from state ID
    const idParts = id.replace(this.namespace + '.', '').split('.');
    const deviceId = idParts[1];
    const stateKey = idParts.slice(2).join('.');

    // Find device instance and handle the change
    const device = this.devices.get(deviceId);
    if (device) {
        await device.handleStateChange(stateKey, state.val);
    }
}
```

### Extending Templates
```javascript
class CustomThermostat extends ThermostatDevice {
    async createDeviceStates() {
        // Create standard states
        await super.createDeviceStates();
        
        // Add custom states
        await this.createState('schedule.enabled', {
            name: 'Schedule Enabled',
            type: 'boolean',
            role: 'switch.enable',
            read: true,
            write: true
        });
    }

    async handleStateChange(stateKey, value) {
        if (stateKey === 'schedule.enabled') {
            // Handle custom state
            return this.toggleSchedule(value);
        }
        
        // Delegate to parent for standard states
        return super.handleStateChange(stateKey, value);
    }
}
```

### Dynamic Device Creation
```javascript
async createDevicesFromConfig() {
    const devices = this.config.devices || [];
    
    for (const deviceConfig of devices) {
        let device;
        
        switch (deviceConfig.type) {
            case 'thermostat':
                device = new ThermostatDevice(
                    this,
                    deviceConfig.id,
                    deviceConfig.name,
                    deviceConfig
                );
                break;
                
            case 'light':
                device = new LightDevice(
                    this,
                    deviceConfig.id,
                    deviceConfig.name,
                    deviceConfig
                );
                break;
                
            // ... other device types
        }
        
        if (device) {
            await device.createDeviceStates();
            this.devices.set(deviceConfig.id, device);
        }
    }
}
```

## Type Detection Compatibility

All templates are designed to work seamlessly with the ioBroker type detector:

- **Correct Object Hierarchy**: Device → Channel → State structure
- **Standard Roles**: Uses established role conventions
- **Proper Metadata**: Includes all necessary common properties
- **Status States**: Implements statusStates for device health monitoring
- **Naming Conventions**: Follows ioBroker naming patterns

## Testing Templates

Each template includes basic validation and error handling:

```javascript
// Test device creation
const device = new ThermostatDevice(adapter, 'test_device', 'Test Device');
await device.createDeviceStates();

// Verify objects were created
const deviceObj = await adapter.getObjectAsync('devices.test_device');
expect(deviceObj).toBeDefined();
expect(deviceObj.type).toBe('device');

// Test state updates
await device.setState('temperature', 22.5);
const tempState = await adapter.getStateAsync('devices.test_device.temperature');
expect(tempState.val).toBe(22.5);
```

## Best Practices

1. **Use Appropriate Templates**: Choose the template that best matches your device type
2. **Extend When Needed**: Create custom classes for device-specific features
3. **Handle State Changes**: Implement proper state change handling in your adapter
4. **Validate Configuration**: Check device configuration before creating devices
5. **Error Handling**: Wrap device operations in try-catch blocks
6. **Consistent Naming**: Use descriptive and consistent device IDs
7. **Documentation**: Document any custom extensions or modifications

## Contributing

When adding new device templates:

1. Extend the BaseDevice class
2. Follow existing naming conventions
3. Include comprehensive state definitions
4. Implement handleStateChange method
5. Add usage examples
6. Test with the type detector
7. Update this documentation

## Files

- `deviceTemplates.js` - Main template classes
- `usage-example.js` - Complete usage examples
- `README.md` - This documentation

These templates provide a solid foundation for creating well-structured, type-detector-compatible devices in your ioBroker adapters.