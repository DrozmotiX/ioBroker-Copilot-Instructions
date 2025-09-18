/**
 * Device Templates for ioBroker Adapters
 * 
 * This file contains template classes for common device types that are
 * compatible with the ioBroker type detector. Use these as base classes
 * or examples for creating device objects in your adapter.
 */

'use strict';

/**
 * Base Device Template
 * Common functionality for all device types
 */
class BaseDevice {
    constructor(adapter, deviceId, deviceName, deviceConfig = {}) {
        this.adapter = adapter;
        this.deviceId = deviceId;
        this.deviceName = deviceName;
        this.config = deviceConfig;
        this.states = new Map();
    }

    /**
     * Create the basic device object structure
     */
    async createDeviceObject() {
        await this.adapter.setObjectNotExistsAsync(`devices.${this.deviceId}`, {
            type: 'device',
            common: {
                name: this.deviceName,
                statusStates: {
                    onlineId: `devices.${this.deviceId}.info.online`
                }
            },
            native: {
                ...this.config,
                deviceType: this.constructor.name.toLowerCase()
            }
        });

        // Create info channel
        await this.adapter.setObjectNotExistsAsync(`devices.${this.deviceId}.info`, {
            type: 'channel',
            common: {
                name: 'Information'
            },
            native: {}
        });

        // Create online status
        await this.createState('info.online', {
            name: 'Online',
            type: 'boolean',
            role: 'indicator.reachable',
            read: true,
            write: false
        }, true);
    }

    /**
     * Helper method to create states
     */
    async createState(stateKey, common, initialValue = null) {
        const fullId = `devices.${this.deviceId}.${stateKey}`;
        
        await this.adapter.setObjectNotExistsAsync(fullId, {
            type: 'state',
            common: {
                ...common,
                read: common.read !== false,
                write: common.write === true
            },
            native: {}
        });

        this.states.set(stateKey, common);

        if (initialValue !== null) {
            await this.adapter.setStateAsync(fullId, { val: initialValue, ack: true });
        }
    }

    /**
     * Update device state value
     */
    async setState(stateKey, value, ack = true) {
        const fullId = `devices.${this.deviceId}.${stateKey}`;
        await this.adapter.setStateAsync(fullId, { val: value, ack });
    }

    /**
     * Get device state value
     */
    async getState(stateKey) {
        const fullId = `devices.${this.deviceId}.${stateKey}`;
        return await this.adapter.getStateAsync(fullId);
    }

    /**
     * Handle state changes for this device
     */
    async handleStateChange(stateKey, value) {
        // Override in subclasses for device-specific logic
        this.adapter.log.debug(`State change for ${this.deviceId}: ${stateKey} = ${value}`);
    }
}

/**
 * Thermostat Device Template
 * For heating/cooling control devices
 */
class ThermostatDevice extends BaseDevice {
    async createDeviceStates() {
        await this.createDeviceObject();

        // Current temperature (sensor)
        await this.createState('temperature', {
            name: 'Current Temperature',
            type: 'number',
            role: 'value.temperature',
            unit: '°C',
            read: true,
            write: false
        });

        // Target temperature (control)
        await this.createState('targetTemperature', {
            name: 'Target Temperature',
            type: 'number',
            role: 'level.temperature',
            unit: '°C',
            min: 5,
            max: 35,
            read: true,
            write: true
        });

        // Heating status
        await this.createState('heating', {
            name: 'Heating Active',
            type: 'boolean',
            role: 'indicator.working',
            read: true,
            write: false
        });

        // Cooling status (for AC units)
        await this.createState('cooling', {
            name: 'Cooling Active',
            type: 'boolean',
            role: 'indicator.working',
            read: true,
            write: false
        });

        // Mode control
        await this.createState('mode', {
            name: 'Operation Mode',
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
        });

        // Fan mode
        await this.createState('fanMode', {
            name: 'Fan Mode',
            type: 'string',
            role: 'text',
            states: {
                'auto': 'Auto',
                'low': 'Low',
                'medium': 'Medium',
                'high': 'High'
            },
            read: true,
            write: true
        });
    }

    async handleStateChange(stateKey, value) {
        switch (stateKey) {
            case 'targetTemperature':
                return this.setTargetTemperature(value);
            case 'mode':
                return this.setMode(value);
            case 'fanMode':
                return this.setFanMode(value);
        }
    }

    async setTargetTemperature(temperature) {
        // Implement device-specific logic here
        this.adapter.log.info(`Setting target temperature for ${this.deviceId}: ${temperature}°C`);
        // Update the state to confirm the change
        await this.setState('targetTemperature', temperature);
    }

    async setMode(mode) {
        this.adapter.log.info(`Setting mode for ${this.deviceId}: ${mode}`);
        await this.setState('mode', mode);
    }

    async setFanMode(fanMode) {
        this.adapter.log.info(`Setting fan mode for ${this.deviceId}: ${fanMode}`);
        await this.setState('fanMode', fanMode);
    }
}

/**
 * Light/Switch Device Template
 * For simple on/off switches and dimmable lights
 */
class LightDevice extends BaseDevice {
    constructor(adapter, deviceId, deviceName, deviceConfig = {}) {
        super(adapter, deviceId, deviceName, deviceConfig);
        this.isDimmable = deviceConfig.dimmable || false;
        this.hasColorControl = deviceConfig.colorControl || false;
    }

    async createDeviceStates() {
        await this.createDeviceObject();

        // Power state
        await this.createState('power', {
            name: 'Power',
            type: 'boolean',
            role: 'switch.light',
            read: true,
            write: true
        }, false);

        // Brightness (for dimmable lights)
        if (this.isDimmable) {
            await this.createState('level', {
                name: 'Brightness',
                type: 'number',
                role: 'level.dimmer',
                unit: '%',
                min: 0,
                max: 100,
                read: true,
                write: true
            }, 0);
        }

        // Color control (for RGB lights)
        if (this.hasColorControl) {
            await this.createState('color', {
                name: 'Color',
                type: 'string',
                role: 'level.color.rgb',
                read: true,
                write: true
            });

            await this.createState('colorTemperature', {
                name: 'Color Temperature',
                type: 'number',
                role: 'level.color.temperature',
                unit: 'K',
                min: 2000,
                max: 6500,
                read: true,
                write: true
            });

            await this.createState('hue', {
                name: 'Hue',
                type: 'number',
                role: 'level.color.hue',
                min: 0,
                max: 360,
                read: true,
                write: true
            });

            await this.createState('saturation', {
                name: 'Saturation',
                type: 'number',
                role: 'level.color.saturation',
                unit: '%',
                min: 0,
                max: 100,
                read: true,
                write: true
            });
        }
    }

    async handleStateChange(stateKey, value) {
        switch (stateKey) {
            case 'power':
                return this.setPower(value);
            case 'level':
                return this.setLevel(value);
            case 'color':
                return this.setColor(value);
            case 'colorTemperature':
                return this.setColorTemperature(value);
            case 'hue':
                return this.setHue(value);
            case 'saturation':
                return this.setSaturation(value);
        }
    }

    async setPower(power) {
        this.adapter.log.info(`Setting power for ${this.deviceId}: ${power}`);
        await this.setState('power', power);
        
        // If turning off, set level to 0
        if (!power && this.isDimmable) {
            await this.setState('level', 0);
        }
    }

    async setLevel(level) {
        this.adapter.log.info(`Setting level for ${this.deviceId}: ${level}%`);
        await this.setState('level', level);
        
        // Auto-turn on/off based on level
        await this.setState('power', level > 0);
    }

    async setColor(color) {
        this.adapter.log.info(`Setting color for ${this.deviceId}: ${color}`);
        await this.setState('color', color);
    }

    async setColorTemperature(temperature) {
        this.adapter.log.info(`Setting color temperature for ${this.deviceId}: ${temperature}K`);
        await this.setState('colorTemperature', temperature);
    }

    async setHue(hue) {
        await this.setState('hue', hue);
    }

    async setSaturation(saturation) {
        await this.setState('saturation', saturation);
    }
}

/**
 * Sensor Device Template
 * For various sensor types (temperature, humidity, motion, etc.)
 */
class SensorDevice extends BaseDevice {
    constructor(adapter, deviceId, deviceName, sensorTypes = [], deviceConfig = {}) {
        super(adapter, deviceId, deviceName, deviceConfig);
        this.sensorTypes = sensorTypes;
    }

    async createDeviceStates() {
        await this.createDeviceObject();

        // Create states for each sensor type
        for (const sensorType of this.sensorTypes) {
            await this.createSensorState(sensorType);
        }

        // Battery level (for battery-powered sensors)
        if (this.config.hasBattery) {
            await this.createState('battery', {
                name: 'Battery Level',
                type: 'number',
                role: 'value.battery',
                unit: '%',
                min: 0,
                max: 100,
                read: true,
                write: false
            });
        }

        // Signal strength (for wireless sensors)
        if (this.config.hasSignalStrength) {
            await this.createState('signal', {
                name: 'Signal Strength',
                type: 'number',
                role: 'value.signal',
                unit: 'dBm',
                read: true,
                write: false
            });
        }
    }

    async createSensorState(sensorType) {
        const sensorConfigs = {
            temperature: {
                name: 'Temperature',
                type: 'number',
                role: 'value.temperature',
                unit: '°C'
            },
            humidity: {
                name: 'Humidity',
                type: 'number',
                role: 'value.humidity',
                unit: '%',
                min: 0,
                max: 100
            },
            pressure: {
                name: 'Pressure',
                type: 'number',
                role: 'value.pressure',
                unit: 'hPa'
            },
            motion: {
                name: 'Motion',
                type: 'boolean',
                role: 'sensor.motion'
            },
            door: {
                name: 'Door/Window',
                type: 'boolean',
                role: 'sensor.door'
            },
            water: {
                name: 'Water Leak',
                type: 'boolean',
                role: 'sensor.water'
            },
            smoke: {
                name: 'Smoke',
                type: 'boolean',
                role: 'sensor.smoke'
            },
            brightness: {
                name: 'Brightness',
                type: 'number',
                role: 'value.brightness',
                unit: 'lux'
            },
            uv: {
                name: 'UV Index',
                type: 'number',
                role: 'value.uv'
            },
            co2: {
                name: 'CO2',
                type: 'number',
                role: 'value.co2',
                unit: 'ppm'
            },
            noise: {
                name: 'Noise Level',
                type: 'number',
                role: 'value.noise',
                unit: 'dB'
            }
        };

        const config = sensorConfigs[sensorType];
        if (config) {
            await this.createState(sensorType, config);
        }
    }

    async updateSensorValue(sensorType, value) {
        await this.setState(sensorType, value);
        
        // Update last update timestamp
        await this.setState('info.lastUpdate', new Date().toISOString());
    }
}

/**
 * Media Player Device Template
 * For audio/video devices and media players
 */
class MediaPlayerDevice extends BaseDevice {
    async createDeviceStates() {
        await this.createDeviceObject();

        // Power state
        await this.createState('power', {
            name: 'Power',
            type: 'boolean',
            role: 'switch.power',
            read: true,
            write: true
        });

        // Playback control
        await this.createState('play', {
            name: 'Play',
            type: 'boolean',
            role: 'button.play',
            read: true,
            write: true
        });

        await this.createState('pause', {
            name: 'Pause',
            type: 'boolean',
            role: 'button.pause',
            read: true,
            write: true
        });

        await this.createState('stop', {
            name: 'Stop',
            type: 'boolean',
            role: 'button.stop',
            read: true,
            write: true
        });

        await this.createState('next', {
            name: 'Next Track',
            type: 'boolean',
            role: 'button.next',
            read: true,
            write: true
        });

        await this.createState('previous', {
            name: 'Previous Track',
            type: 'boolean',
            role: 'button.prev',
            read: true,
            write: true
        });

        // Volume control
        await this.createState('volume', {
            name: 'Volume',
            type: 'number',
            role: 'level.volume',
            unit: '%',
            min: 0,
            max: 100,
            read: true,
            write: true
        });

        await this.createState('mute', {
            name: 'Mute',
            type: 'boolean',
            role: 'media.mute',
            read: true,
            write: true
        });

        // Track information
        await this.createState('title', {
            name: 'Track Title',
            type: 'string',
            role: 'media.title',
            read: true,
            write: false
        });

        await this.createState('artist', {
            name: 'Artist',
            type: 'string',
            role: 'media.artist',
            read: true,
            write: false
        });

        await this.createState('album', {
            name: 'Album',
            type: 'string',
            role: 'media.album',
            read: true,
            write: false
        });

        // Playback state
        await this.createState('state', {
            name: 'Playback State',
            type: 'string',
            role: 'media.state',
            states: {
                'playing': 'Playing',
                'paused': 'Paused',
                'stopped': 'Stopped'
            },
            read: true,
            write: false
        });

        // Position and duration
        await this.createState('position', {
            name: 'Position',
            type: 'number',
            role: 'media.seek',
            unit: 's',
            read: true,
            write: true
        });

        await this.createState('duration', {
            name: 'Duration',
            type: 'number',
            role: 'media.duration',
            unit: 's',
            read: true,
            write: false
        });
    }

    async handleStateChange(stateKey, value) {
        switch (stateKey) {
            case 'power':
                return this.setPower(value);
            case 'play':
                if (value) return this.play();
                break;
            case 'pause':
                if (value) return this.pause();
                break;
            case 'stop':
                if (value) return this.stop();
                break;
            case 'next':
                if (value) return this.next();
                break;
            case 'previous':
                if (value) return this.previous();
                break;
            case 'volume':
                return this.setVolume(value);
            case 'mute':
                return this.setMute(value);
            case 'position':
                return this.seek(value);
        }
    }

    async setPower(power) {
        await this.setState('power', power);
        if (!power) {
            await this.setState('state', 'stopped');
        }
    }

    async play() {
        await this.setState('state', 'playing');
        await this.setState('play', false); // Reset button
    }

    async pause() {
        await this.setState('state', 'paused');
        await this.setState('pause', false); // Reset button
    }

    async stop() {
        await this.setState('state', 'stopped');
        await this.setState('position', 0);
        await this.setState('stop', false); // Reset button
    }

    async next() {
        this.adapter.log.info(`Next track for ${this.deviceId}`);
        await this.setState('next', false); // Reset button
    }

    async previous() {
        this.adapter.log.info(`Previous track for ${this.deviceId}`);
        await this.setState('previous', false); // Reset button
    }

    async setVolume(volume) {
        await this.setState('volume', volume);
    }

    async setMute(mute) {
        await this.setState('mute', mute);
    }

    async seek(position) {
        await this.setState('position', position);
    }

    async updateTrackInfo(title, artist, album, duration = null) {
        await this.setState('title', title || '');
        await this.setState('artist', artist || '');
        await this.setState('album', album || '');
        if (duration !== null) {
            await this.setState('duration', duration);
        }
    }
}

/**
 * Blind/Shutter Device Template
 * For motorized window coverings
 */
class BlindDevice extends BaseDevice {
    async createDeviceStates() {
        await this.createDeviceObject();

        // Position control
        await this.createState('position', {
            name: 'Position',
            type: 'number',
            role: 'level.blind',
            unit: '%',
            min: 0,
            max: 100,
            read: true,
            write: true
        }, 0);

        // Direction control
        await this.createState('direction', {
            name: 'Direction',
            type: 'string',
            role: 'text',
            states: {
                'up': 'Up',
                'down': 'Down',
                'stop': 'Stop'
            },
            read: true,
            write: true
        });

        // Shortcut commands
        await this.createState('open', {
            name: 'Open',
            type: 'boolean',
            role: 'button.open',
            read: true,
            write: true
        });

        await this.createState('close', {
            name: 'Close',
            type: 'boolean',
            role: 'button.close',
            read: true,
            write: true
        });

        await this.createState('stop', {
            name: 'Stop',
            type: 'boolean',
            role: 'button.stop',
            read: true,
            write: true
        });

        // Status
        await this.createState('moving', {
            name: 'Moving',
            type: 'boolean',
            role: 'indicator.working',
            read: true,
            write: false
        }, false);
    }

    async handleStateChange(stateKey, value) {
        switch (stateKey) {
            case 'position':
                return this.setPosition(value);
            case 'direction':
                return this.setDirection(value);
            case 'open':
                if (value) return this.open();
                break;
            case 'close':
                if (value) return this.close();
                break;
            case 'stop':
                if (value) return this.stop();
                break;
        }
    }

    async setPosition(position) {
        await this.setState('position', position);
        await this.setState('moving', true);
        
        // Simulate movement completion after delay
        setTimeout(async () => {
            await this.setState('moving', false);
        }, 5000);
    }

    async setDirection(direction) {
        await this.setState('direction', direction);
        if (direction !== 'stop') {
            await this.setState('moving', true);
        } else {
            await this.setState('moving', false);
        }
    }

    async open() {
        await this.setPosition(100);
        await this.setState('open', false); // Reset button
    }

    async close() {
        await this.setPosition(0);
        await this.setState('close', false); // Reset button
    }

    async stop() {
        await this.setState('moving', false);
        await this.setState('direction', 'stop');
        await this.setState('stop', false); // Reset button
    }
}

module.exports = {
    BaseDevice,
    ThermostatDevice,
    LightDevice,
    SensorDevice,
    MediaPlayerDevice,
    BlindDevice
};