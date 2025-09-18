# Type Detection Integration Guide

This document explains how to integrate your ioBroker adapter with the ioBroker type detector for automatic device recognition and enhanced user experience.

## Overview

The ioBroker type detector automatically recognizes device types based on object structures and naming patterns. This enables:
- Automatic device categorization in admin interfaces
- Consistent device representation across adapters
- Better user experience with recognized device types
- Integration with visualization tools and voice assistants

## Understanding Type Detection

### How Type Detection Works
The type detector analyzes:
1. **Object structure** - Hierarchy and relationships between objects
2. **Object properties** - Common names, roles, and types
3. **State roles** - Semantic meaning of states (e.g., `value.temperature`)
4. **Naming patterns** - Common device and channel naming conventions

### Supported Device Types
Common device types recognized by the detector:
- `thermostat` - Heating/cooling control devices
- `switch` - On/off switches and relays
- `dimmer` - Dimmable lights and controls
- `blind` - Window blinds and shutters
- `sensor` - Various sensor types (temperature, humidity, motion, etc.)
- `media` - Media players and audio devices
- `camera` - IP cameras and video devices
- `lock` - Smart locks and access control
- `weatherStation` - Weather monitoring devices

## Object Structure Best Practices

### Device Hierarchy
Create a clear hierarchical structure that the type detector can understand:

```javascript
// Good: Clear device structure
await this.setObjectNotExistsAsync('devices', {
    type: 'folder',
    common: {
        name: 'Devices'
    },
    native: {}
});

await this.setObjectNotExistsAsync('devices.thermostat1', {
    type: 'device',
    common: {
        name: 'Living Room Thermostat',
        statusStates: {
            onlineId: 'devices.thermostat1.info.online'
        }
    },
    native: {
        id: 'thermostat_001',
        type: 'thermostat'
    }
});

await this.setObjectNotExistsAsync('devices.thermostat1.info', {
    type: 'channel',
    common: {
        name: 'Information'
    },
    native: {}
});
```

### State Definitions
Use appropriate roles and properties that align with type detection patterns:

```javascript
// Temperature sensor states
await this.setObjectNotExistsAsync('devices.thermostat1.temperature', {
    type: 'state',
    common: {
        name: 'Current Temperature',
        type: 'number',
        role: 'value.temperature',
        unit: '°C',
        read: true,
        write: false,
        min: -50,
        max: 100
    },
    native: {}
});

// Thermostat set point
await this.setObjectNotExistsAsync('devices.thermostat1.targetTemperature', {
    type: 'state',
    common: {
        name: 'Target Temperature',
        type: 'number',
        role: 'level.temperature',
        unit: '°C',
        read: true,
        write: true,
        min: 5,
        max: 35
    },
    native: {}
});

// Heating state
await this.setObjectNotExistsAsync('devices.thermostat1.heating', {
    type: 'state',
    common: {
        name: 'Heating Active',
        type: 'boolean',
        role: 'indicator.working',
        read: true,
        write: false
    },
    native: {}
});
```

## Device Type Patterns

### Thermostat Pattern
```javascript
class ThermostatDevice {
    async createThermostatObjects(deviceId, deviceName) {
        // Device object
        await this.setObjectNotExistsAsync(`devices.${deviceId}`, {
            type: 'device',
            common: {
                name: deviceName,
                statusStates: {
                    onlineId: `devices.${deviceId}.info.online`
                }
            },
            native: {
                type: 'thermostat'
            }
        });

        // Current temperature (sensor)
        await this.setObjectNotExistsAsync(`devices.${deviceId}.temperature`, {
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

        // Target temperature (control)
        await this.setObjectNotExistsAsync(`devices.${deviceId}.targetTemperature`, {
            type: 'state',
            common: {
                name: 'Target Temperature',
                type: 'number',
                role: 'level.temperature',
                unit: '°C',
                read: true,
                write: true,
                min: 5,
                max: 35
            },
            native: {}
        });

        // Heating indicator
        await this.setObjectNotExistsAsync(`devices.${deviceId}.heating`, {
            type: 'state',
            common: {
                name: 'Heating',
                type: 'boolean',
                role: 'indicator.working',
                read: true,
                write: false
            },
            native: {}
        });

        // Mode selection
        await this.setObjectNotExistsAsync(`devices.${deviceId}.mode`, {
            type: 'state',
            common: {
                name: 'Mode',
                type: 'string',
                role: 'text',
                states: {
                    'off': 'Off',
                    'heat': 'Heat',
                    'cool': 'Cool',
                    'auto': 'Auto'
                },
                read: true,
                write: true
            },
            native: {}
        });
    }
}
```

### Switch/Dimmer Pattern
```javascript
class LightDevice {
    async createSwitchObjects(deviceId, deviceName, isDimmable = false) {
        // Device object
        await this.setObjectNotExistsAsync(`devices.${deviceId}`, {
            type: 'device',
            common: {
                name: deviceName,
                statusStates: {
                    onlineId: `devices.${deviceId}.info.online`
                }
            },
            native: {
                type: isDimmable ? 'dimmer' : 'switch'
            }
        });

        // Power state
        await this.setObjectNotExistsAsync(`devices.${deviceId}.power`, {
            type: 'state',
            common: {
                name: 'Power',
                type: 'boolean',
                role: 'switch.light',
                read: true,
                write: true
            },
            native: {}
        });

        // Dimmer level (only for dimmable lights)
        if (isDimmable) {
            await this.setObjectNotExistsAsync(`devices.${deviceId}.level`, {
                type: 'state',
                common: {
                    name: 'Brightness',
                    type: 'number',
                    role: 'level.dimmer',
                    unit: '%',
                    min: 0,
                    max: 100,
                    read: true,
                    write: true
                },
                native: {}
            });
        }
    }
}
```

### Sensor Pattern
```javascript
class SensorDevice {
    async createSensorObjects(deviceId, deviceName, sensorTypes = []) {
        // Device object
        await this.setObjectNotExistsAsync(`devices.${deviceId}`, {
            type: 'device',
            common: {
                name: deviceName,
                statusStates: {
                    onlineId: `devices.${deviceId}.info.online`
                }
            },
            native: {
                type: 'sensor'
            }
        });

        // Create states based on sensor types
        for (const sensorType of sensorTypes) {
            await this.createSensorState(deviceId, sensorType);
        }
    }

    async createSensorState(deviceId, sensorType) {
        const sensorConfigs = {
            temperature: {
                role: 'value.temperature',
                type: 'number',
                unit: '°C',
                min: -50,
                max: 100
            },
            humidity: {
                role: 'value.humidity',
                type: 'number',
                unit: '%',
                min: 0,
                max: 100
            },
            motion: {
                role: 'sensor.motion',
                type: 'boolean'
            },
            door: {
                role: 'sensor.door',
                type: 'boolean'
            },
            light: {
                role: 'value.brightness',
                type: 'number',
                unit: 'lux',
                min: 0
            },
            pressure: {
                role: 'value.pressure',
                type: 'number',
                unit: 'hPa'
            }
        };

        const config = sensorConfigs[sensorType];
        if (config) {
            await this.setObjectNotExistsAsync(`devices.${deviceId}.${sensorType}`, {
                type: 'state',
                common: {
                    name: sensorType.charAt(0).toUpperCase() + sensorType.slice(1),
                    type: config.type,
                    role: config.role,
                    unit: config.unit,
                    min: config.min,
                    max: config.max,
                    read: true,
                    write: false
                },
                native: {}
            });
        }
    }
}
```

### Media Player Pattern
```javascript
class MediaDevice {
    async createMediaPlayerObjects(deviceId, deviceName) {
        // Device object
        await this.setObjectNotExistsAsync(`devices.${deviceId}`, {
            type: 'device',
            common: {
                name: deviceName,
                statusStates: {
                    onlineId: `devices.${deviceId}.info.online`
                }
            },
            native: {
                type: 'media'
            }
        });

        // Power state
        await this.setObjectNotExistsAsync(`devices.${deviceId}.power`, {
            type: 'state',
            common: {
                name: 'Power',
                type: 'boolean',
                role: 'switch.power',
                read: true,
                write: true
            },
            native: {}
        });

        // Play/Pause
        await this.setObjectNotExistsAsync(`devices.${deviceId}.play`, {
            type: 'state',
            common: {
                name: 'Play',
                type: 'boolean',
                role: 'button.play',
                read: true,
                write: true
            },
            native: {}
        });

        // Volume
        await this.setObjectNotExistsAsync(`devices.${deviceId}.volume`, {
            type: 'state',
            common: {
                name: 'Volume',
                type: 'number',
                role: 'level.volume',
                unit: '%',
                min: 0,
                max: 100,
                read: true,
                write: true
            },
            native: {}
        });

        // Current track info
        await this.setObjectNotExistsAsync(`devices.${deviceId}.title`, {
            type: 'state',
            common: {
                name: 'Title',
                type: 'string',
                role: 'media.title',
                read: true,
                write: false
            },
            native: {}
        });

        await this.setObjectNotExistsAsync(`devices.${deviceId}.artist`, {
            type: 'state',
            common: {
                name: 'Artist',
                type: 'string',
                role: 'media.artist',
                read: true,
                write: false
            },
            native: {}
        });
    }
}
```

## Testing Type Detection

### Manual Testing
```javascript
// Test helper to verify type detection
class TypeDetectionTester {
    async testDeviceRecognition(adapterId, devicePath) {
        try {
            const { detectType } = require('@iobroker/type-detector');
            
            // Get all objects for the device
            const objects = await this.getObjectsAsync(`${adapterId}.${devicePath}.*`);
            
            // Run type detection
            const detectedTypes = detectType(objects, `${adapterId}.${devicePath}`);
            
            this.log.info(`Detected types for ${devicePath}:`, JSON.stringify(detectedTypes, null, 2));
            
            return detectedTypes;
        } catch (error) {
            this.log.error(`Type detection test failed: ${error.message}`);
            return null;
        }
    }
}
```

### Automated Testing
```javascript
const { detectType } = require('@iobroker/type-detector');

describe('Type Detection', () => {
    it('should detect thermostat correctly', () => {
        const objects = {
            'adapter.0.devices.thermostat1': {
                type: 'device',
                common: { name: 'Thermostat' },
                native: { type: 'thermostat' }
            },
            'adapter.0.devices.thermostat1.temperature': {
                type: 'state',
                common: { 
                    role: 'value.temperature',
                    type: 'number',
                    unit: '°C'
                }
            },
            'adapter.0.devices.thermostat1.targetTemperature': {
                type: 'state',
                common: { 
                    role: 'level.temperature',
                    type: 'number',
                    unit: '°C',
                    write: true
                }
            }
        };

        const result = detectType(objects, 'adapter.0.devices.thermostat1');
        expect(result).toContain('thermostat');
    });
});
```

## Common Roles and Their Usage

### Temperature Related
- `value.temperature` - Current temperature reading
- `level.temperature` - Target/set temperature
- `value.min.temperature` - Minimum temperature
- `value.max.temperature` - Maximum temperature

### Humidity Related
- `value.humidity` - Current humidity reading
- `level.humidity` - Target humidity level

### Power and Control
- `switch.power` - Main power switch
- `switch.light` - Light switch
- `button.play` - Play button
- `button.pause` - Pause button
- `button.stop` - Stop button

### Indicators
- `indicator.working` - Device working indicator
- `indicator.connected` - Connection status
- `indicator.maintenance` - Maintenance required
- `indicator.lowbat` - Low battery

### Sensors
- `sensor.motion` - Motion detection
- `sensor.door` - Door/window sensor
- `sensor.water` - Water leak sensor
- `sensor.smoke` - Smoke detection

## Advanced Features

### Custom Device Types
```javascript
// Define custom device type patterns
const customDevicePatterns = {
    'smart-sprinkler': {
        requiredStates: [
            { role: 'switch.power', write: true },
            { role: 'level.timer', write: true }
        ],
        optionalStates: [
            { role: 'value.humidity' },
            { role: 'sensor.rain' }
        ]
    }
};

// Register custom patterns with type detector
// Note: This would need to be implemented in the type detector itself
```

### Device Groups and Relationships
```javascript
async createDeviceGroup(groupId, devices) {
    await this.setObjectNotExistsAsync(`groups.${groupId}`, {
        type: 'folder',
        common: {
            name: `Group ${groupId}`,
            desc: 'Device group for type detection'
        },
        native: {
            devices: devices
        }
    });
}
```

## Best Practices Summary

1. **Use Standard Roles**: Follow established role conventions for consistent detection
2. **Proper Hierarchy**: Create clear device/channel/state hierarchies
3. **Complete Metadata**: Include all relevant common properties (type, unit, min/max)
4. **Status Information**: Always include online/offline status states
5. **Semantic Naming**: Use meaningful names that reflect device function
6. **Native Information**: Store device-specific data in native properties
7. **Test Detection**: Regularly test your objects with the type detector
8. **Update Documentation**: Keep device patterns documented for maintenance

By following these patterns and guidelines, your ioBroker adapter will be fully compatible with the type detection system, providing users with a better experience through automatic device recognition and consistent representation across the ioBroker ecosystem.