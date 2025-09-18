/**
 * Example usage of Device Templates
 * Version: 0.1.0
 * 
 * This file demonstrates how to use the device template classes
 * in your ioBroker adapter to create properly structured devices
 * that are compatible with the type detector.
 * 
 * @version 0.1.0
 * @since 0.1.0
 */

'use strict';

const utils = require('@iobroker/adapter-core');
const { 
    ThermostatDevice, 
    LightDevice, 
    SensorDevice, 
    MediaPlayerDevice, 
    BlindDevice 
} = require('./deviceTemplates');

class ExampleAdapter extends utils.Adapter {
    constructor(options = {}) {
        super({
            ...options,
            name: 'device-templates-example',
        });

        this.on('ready', this.onReady.bind(this));
        this.on('stateChange', this.onStateChange.bind(this));
        this.on('unload', this.onUnload.bind(this));

        // Store device instances
        this.devices = new Map();
    }

    async onReady() {
        try {
            this.log.info('Creating example devices using templates...');

            // Create different device types
            await this.createThermostatExample();
            await this.createLightExample();
            await this.createSensorExample();
            await this.createMediaPlayerExample();
            await this.createBlindExample();

            // Subscribe to state changes
            this.subscribeStates('*');

            // Start simulated data updates
            this.startSimulation();

            this.log.info('All example devices created successfully');

        } catch (error) {
            this.log.error(`Failed to initialize adapter: ${error.message}`);
        }
    }

    async createThermostatExample() {
        const thermostat = new ThermostatDevice(
            this, 
            'livingroom_thermostat', 
            'Living Room Thermostat',
            {
                model: 'TH-2000',
                manufacturer: 'Example Corp',
                room: 'Living Room'
            }
        );

        await thermostat.createDeviceStates();
        this.devices.set('livingroom_thermostat', thermostat);

        // Set initial values
        await thermostat.setState('temperature', 21.5);
        await thermostat.setState('targetTemperature', 22.0);
        await thermostat.setState('mode', 'heat');
        await thermostat.setState('heating', true);

        this.log.info('Created thermostat device');
    }

    async createLightExample() {
        // Create a dimmable RGB light
        const light = new LightDevice(
            this,
            'bedroom_light',
            'Bedroom Light',
            {
                dimmable: true,
                colorControl: true,
                model: 'RGB-100',
                manufacturer: 'Example Lights'
            }
        );

        await light.createDeviceStates();
        this.devices.set('bedroom_light', light);

        // Set initial values
        await light.setState('power', false);
        await light.setState('level', 0);
        await light.setState('color', '#FF0000');
        await light.setState('colorTemperature', 3000);

        this.log.info('Created light device');
    }

    async createSensorExample() {
        // Create a multi-sensor
        const sensor = new SensorDevice(
            this,
            'outdoor_sensor',
            'Outdoor Weather Sensor',
            ['temperature', 'humidity', 'pressure', 'brightness'],
            {
                hasBattery: true,
                hasSignalStrength: true,
                model: 'WS-300',
                manufacturer: 'WeatherTech'
            }
        );

        await sensor.createDeviceStates();
        this.devices.set('outdoor_sensor', sensor);

        // Set initial values
        await sensor.setState('temperature', 18.3);
        await sensor.setState('humidity', 65);
        await sensor.setState('pressure', 1013.25);
        await sensor.setState('brightness', 450);
        await sensor.setState('battery', 87);
        await sensor.setState('signal', -45);

        this.log.info('Created sensor device');
    }

    async createMediaPlayerExample() {
        const mediaPlayer = new MediaPlayerDevice(
            this,
            'living_room_player',
            'Living Room Media Player',
            {
                model: 'MP-500',
                manufacturer: 'AudioCorp'
            }
        );

        await mediaPlayer.createDeviceStates();
        this.devices.set('living_room_player', mediaPlayer);

        // Set initial values
        await mediaPlayer.setState('power', true);
        await mediaPlayer.setState('state', 'stopped');
        await mediaPlayer.setState('volume', 45);
        await mediaPlayer.setState('mute', false);

        this.log.info('Created media player device');
    }

    async createBlindExample() {
        const blind = new BlindDevice(
            this,
            'window_blind_1',
            'Living Room Window Blind',
            {
                model: 'BL-Auto',
                manufacturer: 'SmartHome Inc.'
            }
        );

        await blind.createDeviceStates();
        this.devices.set('window_blind_1', blind);

        // Set initial values
        await blind.setState('position', 50);
        await blind.setState('direction', 'stop');
        await blind.setState('moving', false);

        this.log.info('Created blind device');
    }

    async onStateChange(id, state) {
        if (!state || state.ack) return;

        try {
            // Parse the state ID to find the device
            const idParts = id.replace(this.namespace + '.', '').split('.');
            if (idParts[0] !== 'devices') return;

            const deviceId = idParts[1];
            const stateKey = idParts.slice(2).join('.');

            // Find the device instance
            const device = this.devices.get(deviceId);
            if (device) {
                await device.handleStateChange(stateKey, state.val);
            }

        } catch (error) {
            this.log.error(`Error handling state change: ${error.message}`);
        }
    }

    startSimulation() {
        // Simulate changing sensor values
        setInterval(() => {
            this.simulateWeatherData();
            this.simulateMediaPlayer();
        }, 30000); // Every 30 seconds

        this.log.info('Started simulation of device data');
    }

    async simulateWeatherData() {
        const sensor = this.devices.get('outdoor_sensor');
        if (sensor) {
            // Simulate realistic weather changes
            const currentTemp = await sensor.getState('temperature');
            const temp = currentTemp ? currentTemp.val : 20;
            const newTemp = temp + (Math.random() - 0.5) * 2; // ±1°C change

            const humidity = 40 + Math.random() * 40; // 40-80%
            const pressure = 1000 + Math.random() * 40; // 1000-1040 hPa
            const brightness = Math.random() * 1000; // 0-1000 lux

            await sensor.updateSensorValue('temperature', Math.round(newTemp * 10) / 10);
            await sensor.updateSensorValue('humidity', Math.round(humidity));
            await sensor.updateSensorValue('pressure', Math.round(pressure * 100) / 100);
            await sensor.updateSensorValue('brightness', Math.round(brightness));

            this.log.debug(`Updated weather sensor: T=${newTemp.toFixed(1)}°C, H=${humidity.toFixed(0)}%`);
        }
    }

    async simulateMediaPlayer() {
        const player = this.devices.get('living_room_player');
        if (player) {
            const powerState = await player.getState('power');
            const currentState = await player.getState('state');

            if (powerState && powerState.val && currentState && currentState.val === 'playing') {
                // Simulate track progression
                const position = await player.getState('position');
                const duration = await player.getState('duration');
                
                if (position && duration && position.val < duration.val) {
                    await player.setState('position', position.val + 30); // +30 seconds
                }

                // Occasionally change track info
                if (Math.random() < 0.1) { // 10% chance
                    const tracks = [
                        { title: 'Example Song 1', artist: 'Test Artist', album: 'Demo Album', duration: 240 },
                        { title: 'Sample Track', artist: 'Music Maker', album: 'Sound Collection', duration: 180 },
                        { title: 'Audio Test', artist: 'Sound Engineer', album: 'Test Suite', duration: 200 }
                    ];
                    
                    const track = tracks[Math.floor(Math.random() * tracks.length)];
                    await player.updateTrackInfo(track.title, track.artist, track.album, track.duration);
                    await player.setState('position', 0);
                }
            }
        }
    }

    onUnload(callback) {
        try {
            this.log.info('Device templates example adapter stopping...');
            this.devices.clear();
            callback();
        } catch {
            callback();
        }
    }
}

// Example of extending a device template for custom functionality
class CustomThermostat extends ThermostatDevice {
    constructor(adapter, deviceId, deviceName, deviceConfig = {}) {
        super(adapter, deviceId, deviceName, deviceConfig);
        this.schedules = new Map();
    }

    async createDeviceStates() {
        // Create standard thermostat states
        await super.createDeviceStates();

        // Add custom states
        await this.createState('schedule.enabled', {
            name: 'Schedule Enabled',
            type: 'boolean',
            role: 'switch.enable',
            read: true,
            write: true
        }, false);

        await this.createState('schedule.next', {
            name: 'Next Schedule Event',
            type: 'string',
            role: 'text',
            read: true,
            write: false
        });

        await this.createState('eco.mode', {
            name: 'Eco Mode',
            type: 'boolean',
            role: 'switch.enable',
            read: true,
            write: true
        }, false);

        await this.createState('eco.temperature', {
            name: 'Eco Temperature',
            type: 'number',
            role: 'level.temperature',
            unit: '°C',
            min: 5,
            max: 35,
            read: true,
            write: true
        }, 18);
    }

    async handleStateChange(stateKey, value) {
        // Handle custom states
        switch (stateKey) {
            case 'schedule.enabled':
                return this.toggleSchedule(value);
            case 'eco.mode':
                return this.toggleEcoMode(value);
            case 'eco.temperature':
                return this.setEcoTemperature(value);
            default:
                // Delegate to parent class
                return super.handleStateChange(stateKey, value);
        }
    }

    async toggleSchedule(enabled) {
        this.adapter.log.info(`Schedule ${enabled ? 'enabled' : 'disabled'} for ${this.deviceId}`);
        await this.setState('schedule.enabled', enabled);
        
        if (enabled) {
            await this.setState('schedule.next', '06:00 - 21°C');
        } else {
            await this.setState('schedule.next', 'None');
        }
    }

    async toggleEcoMode(enabled) {
        this.adapter.log.info(`Eco mode ${enabled ? 'enabled' : 'disabled'} for ${this.deviceId}`);
        await this.setState('eco.mode', enabled);
        
        if (enabled) {
            const ecoTemp = await this.getState('eco.temperature');
            await this.setState('targetTemperature', ecoTemp.val);
        }
    }

    async setEcoTemperature(temperature) {
        await this.setState('eco.temperature', temperature);
        
        const ecoMode = await this.getState('eco.mode');
        if (ecoMode && ecoMode.val) {
            await this.setState('targetTemperature', temperature);
        }
    }
}

if (require.main !== module) {
    module.exports = (options) => new ExampleAdapter(options);
} else {
    new ExampleAdapter();
}