/**
 * HTTP Client ioBroker Adapter Example
 * 
 * This example demonstrates how to create an ioBroker adapter that
 * communicates with HTTP/REST APIs with proper error handling,
 * authentication, and data processing.
 */

'use strict';

const utils = require('@iobroker/adapter-core');
const axios = require('axios');

class HttpClientAdapter extends utils.Adapter {
    constructor(options = {}) {
        super({
            ...options,
            name: 'http-client',
        });

        this.on('ready', this.onReady.bind(this));
        this.on('stateChange', this.onStateChange.bind(this));
        this.on('unload', this.onUnload.bind(this));

        // HTTP client configuration
        this.httpClient = null;
        this.updateInterval = null;
        this.connected = false;
    }

    async onReady() {
        try {
            this.log.info('HTTP client adapter starting...');

            // Validate configuration
            if (!this.validateConfig()) {
                return;
            }

            // Initialize HTTP client
            this.initializeHttpClient();

            // Test connection
            await this.testConnection();

            // Create states
            await this.createStates();

            // Subscribe to state changes
            this.subscribeStates('*');

            // Start data polling
            this.startPolling();

            this.connected = true;
            await this.setStateAsync('info.connection', { val: true, ack: true });

            this.log.info('HTTP client adapter started successfully');

        } catch (error) {
            this.log.error(`Failed to start adapter: ${error.message}`);
            await this.setStateAsync('info.connection', { val: false, ack: true });
        }
    }

    onUnload(callback) {
        try {
            if (this.updateInterval) {
                clearInterval(this.updateInterval);
            }
            this.connected = false;
            this.setState('info.connection', { val: false, ack: true });
            callback();
        } catch {
            callback();
        }
    }

    validateConfig() {
        if (!this.config.baseUrl) {
            this.log.error('Base URL is required');
            return false;
        }

        try {
            new URL(this.config.baseUrl);
        } catch {
            this.log.error('Invalid base URL format');
            return false;
        }

        return true;
    }

    initializeHttpClient() {
        const config = {
            baseURL: this.config.baseUrl,
            timeout: this.config.timeout || 10000,
            headers: {
                'User-Agent': 'ioBroker-HTTP-Client/1.0.0',
                'Content-Type': 'application/json'
            }
        };

        // Add authentication if configured
        if (this.config.authType === 'basic' && this.config.username) {
            config.auth = {
                username: this.config.username,
                password: this.config.password || ''
            };
        } else if (this.config.authType === 'bearer' && this.config.token) {
            config.headers['Authorization'] = `Bearer ${this.config.token}`;
        } else if (this.config.authType === 'apikey' && this.config.apiKey) {
            config.headers[this.config.apiKeyHeader || 'X-API-Key'] = this.config.apiKey;
        }

        // Create axios instance
        this.httpClient = axios.create(config);

        // Add request interceptor for logging
        this.httpClient.interceptors.request.use(
            (config) => {
                this.log.debug(`HTTP Request: ${config.method?.toUpperCase()} ${config.url}`);
                return config;
            },
            (error) => {
                this.log.error(`HTTP Request Error: ${error.message}`);
                return Promise.reject(error);
            }
        );

        // Add response interceptor for error handling
        this.httpClient.interceptors.response.use(
            (response) => {
                this.log.debug(`HTTP Response: ${response.status} ${response.statusText}`);
                return response;
            },
            (error) => {
                this.logHttpError(error);
                return Promise.reject(error);
            }
        );
    }

    logHttpError(error) {
        if (error.response) {
            this.log.error(`HTTP Error ${error.response.status}: ${error.response.statusText}`);
            if (error.response.data) {
                this.log.debug(`Response data: ${JSON.stringify(error.response.data)}`);
            }
        } else if (error.request) {
            this.log.error(`HTTP Request failed: ${error.message}`);
        } else {
            this.log.error(`HTTP Error: ${error.message}`);
        }
    }

    async testConnection() {
        try {
            const response = await this.httpClient.get('/status');
            this.log.info(`Connection test successful: ${response.status}`);
            return true;
        } catch (error) {
            if (error.response?.status === 404) {
                this.log.warn('Status endpoint not found, but connection appears to work');
                return true;
            }
            throw new Error(`Connection test failed: ${error.message}`);
        }
    }

    async createStates() {
        // Create info channel
        await this.setObjectNotExistsAsync('info', {
            type: 'channel',
            common: { name: 'Information' },
            native: {}
        });

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

        await this.setObjectNotExistsAsync('info.lastUpdate', {
            type: 'state',
            common: {
                name: 'Last Update',
                type: 'string',
                role: 'date',
                read: true,
                write: false
            },
            native: {}
        });

        // Create control states
        await this.setObjectNotExistsAsync('control', {
            type: 'channel',
            common: { name: 'Control' },
            native: {}
        });

        await this.setObjectNotExistsAsync('control.refresh', {
            type: 'state',
            common: {
                name: 'Refresh Data',
                type: 'boolean',
                role: 'button',
                read: true,
                write: true
            },
            native: {}
        });

        // Create data channel for fetched data
        await this.setObjectNotExistsAsync('data', {
            type: 'channel',
            common: { name: 'Data' },
            native: {}
        });
    }

    startPolling() {
        const interval = this.config.pollInterval || 60000; // Default 1 minute
        
        this.updateInterval = setInterval(async () => {
            if (this.connected) {
                await this.fetchData();
            }
        }, interval);

        this.log.info(`Started polling every ${interval / 1000} seconds`);
    }

    async onStateChange(id, state) {
        if (!state || state.ack) return;

        try {
            const stateId = id.replace(this.namespace + '.', '');

            switch (stateId) {
                case 'control.refresh':
                    if (state.val) {
                        await this.fetchData();
                        await this.setStateAsync(id, { val: false, ack: true });
                    }
                    break;

                default:
                    await this.handleApiCommand(stateId, state.val);
                    await this.setStateAsync(id, { val: state.val, ack: true });
            }
        } catch (error) {
            this.log.error(`Error handling state change: ${error.message}`);
        }
    }

    async fetchData() {
        try {
            this.log.debug('Fetching data from API...');

            // Example: Fetch device list
            const devicesResponse = await this.httpClient.get('/api/devices');
            await this.processDevices(devicesResponse.data);

            // Example: Fetch system status
            const statusResponse = await this.httpClient.get('/api/status');
            await this.processStatus(statusResponse.data);

            // Update last update timestamp
            await this.setStateAsync('info.lastUpdate', {
                val: new Date().toISOString(),
                ack: true
            });

            this.log.debug('Data fetch completed successfully');

        } catch (error) {
            this.log.error(`Failed to fetch data: ${error.message}`);
            
            // Set connection to false if request fails
            if (error.code === 'ECONNREFUSED' || error.code === 'ENOTFOUND') {
                this.connected = false;
                await this.setStateAsync('info.connection', { val: false, ack: true });
            }
        }
    }

    async processDevices(devices) {
        if (!Array.isArray(devices)) {
            this.log.warn('Invalid devices data format');
            return;
        }

        for (const device of devices) {
            await this.createDeviceStates(device);
            await this.updateDeviceStates(device);
        }
    }

    async createDeviceStates(device) {
        const deviceId = `devices.${device.id}`;

        // Device object
        await this.setObjectNotExistsAsync(deviceId, {
            type: 'device',
            common: {
                name: device.name || device.id,
                statusStates: {
                    onlineId: `${deviceId}.online`
                }
            },
            native: device
        });

        // Common device states
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

        // Dynamic states based on device properties
        if (typeof device.temperature === 'number') {
            await this.setObjectNotExistsAsync(`${deviceId}.temperature`, {
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
        }

        if (typeof device.power === 'boolean') {
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
        }
    }

    async updateDeviceStates(device) {
        const deviceId = `devices.${device.id}`;

        const states = {
            online: device.online !== undefined ? device.online : true,
            temperature: device.temperature,
            power: device.power
        };

        for (const [key, value] of Object.entries(states)) {
            if (value !== undefined) {
                await this.setStateAsync(`${deviceId}.${key}`, {
                    val: value,
                    ack: true
                });
            }
        }
    }

    async processStatus(status) {
        // Create status states dynamically
        for (const [key, value] of Object.entries(status)) {
            const stateId = `data.${key}`;
            
            // Create state if it doesn't exist
            await this.setObjectNotExistsAsync(stateId, {
                type: 'state',
                common: {
                    name: key.charAt(0).toUpperCase() + key.slice(1),
                    type: typeof value,
                    role: this.getRoleForValue(key, value),
                    read: true,
                    write: false
                },
                native: {}
            });

            // Update value
            await this.setStateAsync(stateId, { val: value, ack: true });
        }
    }

    getRoleForValue(key, value) {
        if (typeof value === 'boolean') {
            return key.includes('online') ? 'indicator.reachable' : 'indicator';
        }
        if (typeof value === 'number') {
            if (key.includes('temp')) return 'value.temperature';
            if (key.includes('humidity')) return 'value.humidity';
            if (key.includes('level')) return 'level';
            return 'value';
        }
        return 'text';
    }

    async handleApiCommand(stateId, value) {
        const parts = stateId.split('.');
        if (parts[0] === 'devices' && parts.length >= 3) {
            const deviceId = parts[1];
            const command = parts[2];

            await this.sendDeviceCommand(deviceId, command, value);
        }
    }

    async sendDeviceCommand(deviceId, command, value) {
        try {
            this.log.info(`Sending command ${command}=${value} to device ${deviceId}`);

            const response = await this.httpClient.post(`/api/devices/${deviceId}/command`, {
                command: command,
                value: value
            });

            if (response.status === 200) {
                this.log.debug(`Command sent successfully to ${deviceId}`);
            }

        } catch (error) {
            this.log.error(`Failed to send command to ${deviceId}: ${error.message}`);
            throw error;
        }
    }

    // Utility methods for advanced HTTP operations
    async uploadFile(filePath, endpoint) {
        const FormData = require('form-data');
        const fs = require('fs');

        try {
            const form = new FormData();
            form.append('file', fs.createReadStream(filePath));

            const response = await this.httpClient.post(endpoint, form, {
                headers: {
                    ...form.getHeaders(),
                },
                maxContentLength: Infinity,
                maxBodyLength: Infinity
            });

            return response.data;
        } catch (error) {
            this.log.error(`File upload failed: ${error.message}`);
            throw error;
        }
    }

    async downloadFile(url, filePath) {
        const fs = require('fs');
        const path = require('path');

        try {
            const response = await this.httpClient({
                method: 'GET',
                url: url,
                responseType: 'stream'
            });

            // Ensure directory exists
            const dir = path.dirname(filePath);
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }

            const writer = fs.createWriteStream(filePath);
            response.data.pipe(writer);

            return new Promise((resolve, reject) => {
                writer.on('finish', resolve);
                writer.on('error', reject);
            });
        } catch (error) {
            this.log.error(`File download failed: ${error.message}`);
            throw error;
        }
    }
}

if (require.main !== module) {
    module.exports = (options) => new HttpClientAdapter(options);
} else {
    new HttpClientAdapter();
}