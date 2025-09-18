/**
 * Basic ioBroker Adapter Template
 * 
 * This example demonstrates the fundamental structure and patterns
 * for creating an ioBroker adapter with proper error handling,
 * state management, and lifecycle management.
 */

'use strict';

const utils = require('@iobroker/adapter-core');

class BasicAdapter extends utils.Adapter {
    constructor(options = {}) {
        super({
            ...options,
            name: 'basic-adapter',
        });

        // Bind context for callback methods
        this.on('ready', this.onReady.bind(this));
        this.on('stateChange', this.onStateChange.bind(this));
        this.on('unload', this.onUnload.bind(this));

        // Internal state
        this.connected = false;
        this.updateInterval = null;
    }

    /**
     * Called when adapter is ready to start
     */
    async onReady() {
        try {
            this.log.info('Basic adapter starting...');

            // Validate configuration
            if (!this.validateConfig()) {
                this.log.error('Invalid configuration, stopping adapter');
                return;
            }

            // Initialize adapter
            await this.initializeAdapter();

            // Subscribe to state changes
            this.subscribeStates('*');

            // Create initial states
            await this.createStates();

            // Start data collection
            this.startDataCollection();

            this.connected = true;
            await this.setStateAsync('info.connection', { val: true, ack: true });

            this.log.info('Basic adapter started successfully');

        } catch (error) {
            this.log.error(`Failed to start adapter: ${error.message}`);
            this.terminate();
        }
    }

    /**
     * Called when adapter receives state changes
     */
    async onStateChange(id, state) {
        try {
            // Ignore deleted states and acknowledged states
            if (!state || state.ack) {
                return;
            }

            this.log.debug(`State change: ${id} = ${state.val}`);

            // Parse state ID to get device and property
            const idParts = id.replace(this.namespace + '.', '').split('.');
            const deviceId = idParts[0];
            const property = idParts[idParts.length - 1];

            // Handle different state changes
            switch (property) {
                case 'power':
                    await this.handlePowerChange(deviceId, state.val);
                    break;
                case 'level':
                    await this.handleLevelChange(deviceId, state.val);
                    break;
                default:
                    this.log.debug(`Unhandled state change: ${property}`);
            }

            // Acknowledge the state change
            await this.setStateAsync(id, { val: state.val, ack: true });

        } catch (error) {
            this.log.error(`Error handling state change: ${error.message}`);
        }
    }

    /**
     * Called when adapter is being stopped
     */
    onUnload(callback) {
        try {
            this.log.info('Basic adapter stopping...');

            // Clear intervals
            if (this.updateInterval) {
                clearInterval(this.updateInterval);
                this.updateInterval = null;
            }

            // Cleanup connections
            this.cleanup();

            // Set connection status
            this.setState('info.connection', { val: false, ack: true });

            this.log.info('Basic adapter stopped');
            callback();

        } catch (error) {
            this.log.error(`Error during cleanup: ${error.message}`);
            callback();
        }
    }

    /**
     * Validate adapter configuration
     */
    validateConfig() {
        if (!this.config.host) {
            this.log.error('Host configuration is missing');
            return false;
        }

        if (!this.config.port || this.config.port < 1 || this.config.port > 65535) {
            this.log.error('Invalid port configuration');
            return false;
        }

        return true;
    }

    /**
     * Initialize adapter-specific functionality
     */
    async initializeAdapter() {
        // Create info channel
        await this.setObjectNotExistsAsync('info', {
            type: 'channel',
            common: {
                name: 'Information'
            },
            native: {}
        });

        // Create connection state
        await this.setObjectNotExistsAsync('info.connection', {
            type: 'state',
            common: {
                name: 'Connection Status',
                type: 'boolean',
                role: 'indicator.connected',
                read: true,
                write: false
            },
            native: {}
        });

        this.log.debug('Adapter initialized');
    }

    /**
     * Create initial device states
     */
    async createStates() {
        // Example device states
        const devices = [
            { id: 'device1', name: 'First Device' },
            { id: 'device2', name: 'Second Device' }
        ];

        for (const device of devices) {
            await this.createDeviceStates(device.id, device.name);
        }
    }

    /**
     * Create states for a specific device
     */
    async createDeviceStates(deviceId, deviceName) {
        // Device object
        await this.setObjectNotExistsAsync(deviceId, {
            type: 'device',
            common: {
                name: deviceName,
                statusStates: {
                    onlineId: `${deviceId}.online`
                }
            },
            native: {}
        });

        // Online status
        await this.setObjectNotExistsAsync(`${deviceId}.online`, {
            type: 'state',
            common: {
                name: 'Online',
                type: 'boolean',
                role: 'indicator.reachable',
                read: true,
                write: false
            },
            native: {}
        });

        // Power state
        await this.setObjectNotExistsAsync(`${deviceId}.power`, {
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

        // Level control
        await this.setObjectNotExistsAsync(`${deviceId}.level`, {
            type: 'state',
            common: {
                name: 'Level',
                type: 'number',
                role: 'level',
                unit: '%',
                min: 0,
                max: 100,
                read: true,
                write: true
            },
            native: {}
        });

        // Set initial values
        await this.setStateAsync(`${deviceId}.online`, { val: true, ack: true });
        await this.setStateAsync(`${deviceId}.power`, { val: false, ack: true });
        await this.setStateAsync(`${deviceId}.level`, { val: 0, ack: true });
    }

    /**
     * Start periodic data collection
     */
    startDataCollection() {
        const interval = this.config.updateInterval || 30000; // Default 30 seconds

        this.updateInterval = setInterval(async () => {
            try {
                await this.updateDeviceData();
            } catch (error) {
                this.log.error(`Error updating device data: ${error.message}`);
            }
        }, interval);

        this.log.debug(`Data collection started with ${interval}ms interval`);
    }

    /**
     * Update device data from external source
     */
    async updateDeviceData() {
        // Simulate data fetching
        const deviceData = await this.fetchDeviceData();

        for (const device of deviceData) {
            await this.updateDeviceStates(device.id, device.data);
        }
    }

    /**
     * Simulate fetching device data (replace with actual implementation)
     */
    async fetchDeviceData() {
        // This would typically make HTTP requests, read from database, etc.
        return [
            {
                id: 'device1',
                data: {
                    online: true,
                    power: Math.random() > 0.5,
                    level: Math.round(Math.random() * 100)
                }
            },
            {
                id: 'device2',
                data: {
                    online: true,
                    power: Math.random() > 0.5,
                    level: Math.round(Math.random() * 100)
                }
            }
        ];
    }

    /**
     * Update states for a specific device
     */
    async updateDeviceStates(deviceId, data) {
        for (const [key, value] of Object.entries(data)) {
            const stateId = `${deviceId}.${key}`;
            const currentState = await this.getStateAsync(stateId);

            // Only update if value has changed
            if (!currentState || currentState.val !== value) {
                await this.setStateAsync(stateId, { val: value, ack: true });
                this.log.debug(`Updated ${stateId} to ${value}`);
            }
        }
    }

    /**
     * Handle power state changes
     */
    async handlePowerChange(deviceId, power) {
        this.log.info(`Power change for ${deviceId}: ${power}`);
        
        // Implement actual device control here
        const success = await this.setDevicePower(deviceId, power);
        
        if (!success) {
            this.log.error(`Failed to set power for ${deviceId}`);
            // Revert state change
            const currentState = await this.getStateAsync(`${deviceId}.power`);
            await this.setStateAsync(`${deviceId}.power`, { 
                val: !power, 
                ack: true 
            });
        }
    }

    /**
     * Handle level changes
     */
    async handleLevelChange(deviceId, level) {
        this.log.info(`Level change for ${deviceId}: ${level}%`);
        
        // Implement actual device control here
        const success = await this.setDeviceLevel(deviceId, level);
        
        if (!success) {
            this.log.error(`Failed to set level for ${deviceId}`);
        }
    }

    /**
     * Set device power (implement with actual device communication)
     */
    async setDevicePower(deviceId, power) {
        // Simulate device communication
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve(Math.random() > 0.1); // 90% success rate
            }, 100);
        });
    }

    /**
     * Set device level (implement with actual device communication)
     */
    async setDeviceLevel(deviceId, level) {
        // Simulate device communication
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve(Math.random() > 0.1); // 90% success rate
            }, 100);
        });
    }

    /**
     * Cleanup resources
     */
    cleanup() {
        // Close connections, cleanup resources
        this.connected = false;
        this.log.debug('Resources cleaned up');
    }
}

// Start the adapter
if (require.main !== module) {
    module.exports = (options) => new BasicAdapter(options);
} else {
    new BasicAdapter();
}