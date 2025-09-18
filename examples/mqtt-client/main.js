/**
 * MQTT Client ioBroker Adapter Example
 * Version: 0.1.0
 * 
 * This example demonstrates how to create an ioBroker adapter that
 * communicates with MQTT brokers, handling subscriptions, publishing,
 * and proper connection management.
 * 
 * @version 0.1.0
 * @since 0.1.0
 */

'use strict';

const utils = require('@iobroker/adapter-core');
const mqtt = require('mqtt');

class MqttClientAdapter extends utils.Adapter {
    constructor(options = {}) {
        super({
            ...options,
            name: 'mqtt-client',
        });

        this.on('ready', this.onReady.bind(this));
        this.on('stateChange', this.onStateChange.bind(this));
        this.on('unload', this.onUnload.bind(this));

        // MQTT client instance
        this.mqttClient = null;
        this.connected = false;
        this.reconnectTimer = null;
        
        // Topic mappings
        this.topicMappings = new Map();
        this.subscriptions = new Set();
    }

    async onReady() {
        try {
            this.log.info('MQTT client adapter starting...');

            // Validate configuration
            if (!this.validateConfig()) {
                return;
            }

            // Create basic states
            await this.createStates();

            // Initialize MQTT connection
            await this.connectToMqtt();

            // Subscribe to state changes
            this.subscribeStates('*');

            this.log.info('MQTT client adapter started successfully');

        } catch (error) {
            this.log.error(`Failed to start adapter: ${error.message}`);
            await this.setStateAsync('info.connection', { val: false, ack: true });
        }
    }

    onUnload(callback) {
        try {
            this.log.info('MQTT client adapter stopping...');

            if (this.reconnectTimer) {
                clearTimeout(this.reconnectTimer);
                this.reconnectTimer = null;
            }

            if (this.mqttClient) {
                this.mqttClient.end(true);
                this.mqttClient = null;
            }

            this.setState('info.connection', { val: false, ack: true });
            callback();
        } catch {
            callback();
        }
    }

    validateConfig() {
        if (!this.config.brokerUrl) {
            this.log.error('MQTT broker URL is required');
            return false;
        }

        if (this.config.port && (this.config.port < 1 || this.config.port > 65535)) {
            this.log.error('Invalid port number');
            return false;
        }

        return true;
    }

    async createStates() {
        // Info channel
        await this.setObjectNotExistsAsync('info', {
            type: 'channel',
            common: { name: 'Information' },
            native: {}
        });

        await this.setObjectNotExistsAsync('info.connection', {
            type: 'state',
            common: {
                name: 'MQTT Connection Status',
                type: 'boolean',
                role: 'indicator.connected',
                read: true,
                write: false
            },
            native: {}
        });

        await this.setObjectNotExistsAsync('info.lastMessage', {
            type: 'state',
            common: {
                name: 'Last Message Time',
                type: 'string',
                role: 'date',
                read: true,
                write: false
            },
            native: {}
        });

        // Statistics
        await this.setObjectNotExistsAsync('stats', {
            type: 'channel',
            common: { name: 'Statistics' },
            native: {}
        });

        await this.setObjectNotExistsAsync('stats.messagesReceived', {
            type: 'state',
            common: {
                name: 'Messages Received',
                type: 'number',
                role: 'value',
                read: true,
                write: false
            },
            native: {}
        });

        await this.setObjectNotExistsAsync('stats.messagesSent', {
            type: 'state',
            common: {
                name: 'Messages Sent',
                type: 'number',
                role: 'value',
                read: true,
                write: false
            },
            native: {}
        });
    }

    async connectToMqtt() {
        const options = {
            host: this.config.brokerUrl,
            port: this.config.port || 1883,
            protocol: this.config.secure ? 'mqtts' : 'mqtt',
            keepalive: this.config.keepalive || 60,
            reconnectPeriod: this.config.reconnectPeriod || 1000,
            connectTimeout: this.config.connectTimeout || 30000,
            clean: this.config.cleanSession !== false
        };

        // Authentication
        if (this.config.username) {
            options.username = this.config.username;
            options.password = this.config.password || '';
        }

        // SSL/TLS options
        if (this.config.secure) {
            options.rejectUnauthorized = this.config.rejectUnauthorized !== false;
            
            if (this.config.caCert) {
                options.ca = this.config.caCert;
            }
            if (this.config.clientCert) {
                options.cert = this.config.clientCert;
                options.key = this.config.clientKey;
            }
        }

        // Last Will Testament
        if (this.config.lwTopic) {
            options.will = {
                topic: this.config.lwTopic,
                payload: this.config.lwPayload || 'offline',
                qos: this.config.lwQos || 0,
                retain: this.config.lwRetain || false
            };
        }

        this.log.debug(`Connecting to MQTT broker: ${options.protocol}://${options.host}:${options.port}`);

        try {
            this.mqttClient = mqtt.connect(options);

            this.mqttClient.on('connect', this.onMqttConnect.bind(this));
            this.mqttClient.on('message', this.onMqttMessage.bind(this));
            this.mqttClient.on('error', this.onMqttError.bind(this));
            this.mqttClient.on('close', this.onMqttClose.bind(this));
            this.mqttClient.on('reconnect', this.onMqttReconnect.bind(this));
            this.mqttClient.on('offline', this.onMqttOffline.bind(this));

        } catch (error) {
            throw new Error(`Failed to create MQTT client: ${error.message}`);
        }
    }

    async onMqttConnect() {
        this.log.info('Connected to MQTT broker');
        this.connected = true;
        
        await this.setStateAsync('info.connection', { val: true, ack: true });

        // Subscribe to configured topics
        await this.subscribeToTopics();

        // Publish birth message if configured
        if (this.config.birthTopic) {
            this.publishMessage(this.config.birthTopic, this.config.birthPayload || 'online');
        }
    }

    async onMqttMessage(topic, message) {
        try {
            this.log.debug(`MQTT message received: ${topic} = ${message.toString()}`);

            // Update statistics
            const received = await this.getStateAsync('stats.messagesReceived');
            const count = received ? received.val + 1 : 1;
            await this.setStateAsync('stats.messagesReceived', { val: count, ack: true });

            // Update last message time
            await this.setStateAsync('info.lastMessage', { 
                val: new Date().toISOString(), 
                ack: true 
            });

            // Process the message
            await this.processMessage(topic, message);

        } catch (error) {
            this.log.error(`Error processing MQTT message: ${error.message}`);
        }
    }

    onMqttError(error) {
        this.log.error(`MQTT error: ${error.message}`);
        this.connected = false;
        this.setState('info.connection', { val: false, ack: true });
    }

    onMqttClose() {
        this.log.warn('MQTT connection closed');
        this.connected = false;
        this.setState('info.connection', { val: false, ack: true });
    }

    onMqttReconnect() {
        this.log.info('Attempting to reconnect to MQTT broker...');
    }

    onMqttOffline() {
        this.log.warn('MQTT client is offline');
        this.connected = false;
        this.setState('info.connection', { val: false, ack: true });
    }

    async subscribeToTopics() {
        const topics = this.config.subscriptions || [];

        for (const subscription of topics) {
            if (subscription.topic && subscription.enabled !== false) {
                await this.subscribeToTopic(subscription.topic, subscription.qos || 0);
            }
        }

        // Subscribe to device discovery topics if enabled
        if (this.config.autoDiscovery) {
            await this.subscribeToTopic('homeassistant/+/+/config', 0);
            await this.subscribeToTopic('+/+/available', 0);
        }
    }

    async subscribeToTopic(topic, qos = 0) {
        if (this.subscriptions.has(topic)) {
            return; // Already subscribed
        }

        return new Promise((resolve, reject) => {
            this.mqttClient.subscribe(topic, { qos }, (error, granted) => {
                if (error) {
                    this.log.error(`Failed to subscribe to ${topic}: ${error.message}`);
                    reject(error);
                } else {
                    this.log.debug(`Subscribed to topic: ${topic} (QoS: ${granted[0].qos})`);
                    this.subscriptions.add(topic);
                    resolve();
                }
            });
        });
    }

    async processMessage(topic, message) {
        const messageStr = message.toString();
        
        // Try to parse JSON messages
        let payload = messageStr;
        try {
            payload = JSON.parse(messageStr);
        } catch {
            // Not JSON, use as string
        }

        // Check for device discovery messages
        if (topic.startsWith('homeassistant/')) {
            await this.processDiscoveryMessage(topic, payload);
            return;
        }

        // Process regular device messages
        const deviceInfo = this.parseTopicForDevice(topic);
        if (deviceInfo) {
            await this.updateDeviceState(deviceInfo, payload);
        } else {
            // Create generic state for unmapped topics
            await this.createTopicState(topic, payload);
        }
    }

    parseTopicForDevice(topic) {
        // Example parsing for different topic patterns:
        // Pattern 1: device/device_id/property
        const devicePattern1 = /^device\/([^\/]+)\/(.+)$/;
        const match1 = topic.match(devicePattern1);
        if (match1) {
            return {
                deviceId: match1[1],
                property: match1[2]
            };
        }

        // Pattern 2: sensors/room/device/property
        const devicePattern2 = /^sensors\/([^\/]+)\/([^\/]+)\/(.+)$/;
        const match2 = topic.match(devicePattern2);
        if (match2) {
            return {
                deviceId: `${match2[1]}_${match2[2]}`,
                property: match2[3],
                room: match2[1],
                device: match2[2]
            };
        }

        return null;
    }

    async updateDeviceState(deviceInfo, payload) {
        const deviceId = `devices.${deviceInfo.deviceId}`;
        const stateId = `${deviceId}.${deviceInfo.property}`;

        // Create device object if it doesn't exist
        await this.setObjectNotExistsAsync(deviceId, {
            type: 'device',
            common: {
                name: deviceInfo.device || deviceInfo.deviceId,
                statusStates: {
                    onlineId: `${deviceId}.available`
                }
            },
            native: {
                room: deviceInfo.room
            }
        });

        // Determine state properties based on payload
        const stateType = typeof payload;
        const stateRole = this.determineRole(deviceInfo.property, payload);

        // Create state object if it doesn't exist
        await this.setObjectNotExistsAsync(stateId, {
            type: 'state',
            common: {
                name: deviceInfo.property,
                type: stateType,
                role: stateRole,
                read: true,
                write: false
            },
            native: {}
        });

        // Update state value
        await this.setStateAsync(stateId, { val: payload, ack: true });
    }

    determineRole(property, value) {
        const lowerProp = property.toLowerCase();
        
        if (typeof value === 'boolean') {
            if (lowerProp.includes('available') || lowerProp.includes('online')) {
                return 'indicator.reachable';
            }
            if (lowerProp.includes('motion')) return 'sensor.motion';
            if (lowerProp.includes('door') || lowerProp.includes('window')) return 'sensor.door';
            return 'indicator';
        }
        
        if (typeof value === 'number') {
            if (lowerProp.includes('temp')) return 'value.temperature';
            if (lowerProp.includes('humidity')) return 'value.humidity';
            if (lowerProp.includes('pressure')) return 'value.pressure';
            if (lowerProp.includes('battery')) return 'value.battery';
            if (lowerProp.includes('level')) return 'level';
            return 'value';
        }
        
        return 'text';
    }

    async createTopicState(topic, payload) {
        const stateId = `raw.${topic.replace(/[^a-zA-Z0-9]/g, '_')}`;
        
        await this.setObjectNotExistsAsync('raw', {
            type: 'channel',
            common: { name: 'Raw MQTT Topics' },
            native: {}
        });

        await this.setObjectNotExistsAsync(stateId, {
            type: 'state',
            common: {
                name: topic,
                type: typeof payload,
                role: 'text',
                read: true,
                write: false
            },
            native: { originalTopic: topic }
        });

        await this.setStateAsync(stateId, { val: payload, ack: true });
    }

    async processDiscoveryMessage(topic, config) {
        // Process Home Assistant discovery messages
        const topicParts = topic.split('/');
        if (topicParts.length >= 4 && topicParts[3] === 'config') {
            const component = topicParts[1];
            const objectId = topicParts[2];
            
            if (config === '' || config === null) {
                // Device removal
                await this.removeDiscoveredDevice(component, objectId);
            } else {
                // Device discovery
                await this.createDiscoveredDevice(component, objectId, config);
            }
        }
    }

    async createDiscoveredDevice(component, objectId, config) {
        const deviceId = `discovered.${component}.${objectId}`;
        
        await this.setObjectNotExistsAsync(deviceId, {
            type: 'device',
            common: {
                name: config.name || objectId,
                statusStates: config.availability_topic ? {
                    onlineId: `${deviceId}.available`
                } : undefined
            },
            native: {
                component: component,
                config: config,
                discoveryTopic: `homeassistant/${component}/${objectId}/config`
            }
        });

        // Subscribe to state and availability topics
        if (config.state_topic) {
            await this.subscribeToTopic(config.state_topic, 0);
        }
        if (config.availability_topic) {
            await this.subscribeToTopic(config.availability_topic, 0);
        }

        this.log.info(`Discovered ${component} device: ${config.name || objectId}`);
    }

    async onStateChange(id, state) {
        if (!state || state.ack || !this.connected) return;

        try {
            const stateId = id.replace(this.namespace + '.', '');
            
            // Handle publish commands
            if (stateId.startsWith('publish.')) {
                await this.handlePublishCommand(stateId, state.val);
                await this.setStateAsync(id, { val: state.val, ack: true });
                return;
            }

            // Find topic mapping for this state
            const mapping = this.findTopicMapping(stateId);
            if (mapping) {
                await this.publishStateChange(mapping, state.val);
                await this.setStateAsync(id, { val: state.val, ack: true });
            }

        } catch (error) {
            this.log.error(`Error handling state change: ${error.message}`);
        }
    }

    findTopicMapping(stateId) {
        // Check configured mappings
        const mappings = this.config.publishMappings || [];
        
        for (const mapping of mappings) {
            if (mapping.stateId === stateId && mapping.enabled !== false) {
                return mapping;
            }
        }

        return null;
    }

    async publishStateChange(mapping, value) {
        let payload = value;
        
        // Apply value transformation if configured
        if (mapping.transform) {
            payload = this.transformValue(value, mapping.transform);
        }

        // Convert to JSON if requested
        if (mapping.format === 'json') {
            payload = JSON.stringify({ value: payload, timestamp: Date.now() });
        }

        await this.publishMessage(mapping.topic, payload, mapping.qos, mapping.retain);
    }

    transformValue(value, transform) {
        switch (transform) {
            case 'boolean_to_onoff':
                return value ? 'ON' : 'OFF';
            case 'boolean_to_number':
                return value ? 1 : 0;
            case 'invert_boolean':
                return !value;
            case 'multiply_10':
                return value * 10;
            case 'divide_10':
                return value / 10;
            default:
                return value;
        }
    }

    async publishMessage(topic, payload, qos = 0, retain = false) {
        if (!this.connected) {
            throw new Error('MQTT client is not connected');
        }

        return new Promise((resolve, reject) => {
            this.mqttClient.publish(topic, payload.toString(), { qos, retain }, (error) => {
                if (error) {
                    this.log.error(`Failed to publish to ${topic}: ${error.message}`);
                    reject(error);
                } else {
                    this.log.debug(`Published to ${topic}: ${payload}`);
                    
                    // Update statistics
                    this.getStateAsync('stats.messagesSent').then(sent => {
                        const count = sent ? sent.val + 1 : 1;
                        this.setStateAsync('stats.messagesSent', { val: count, ack: true });
                    });
                    
                    resolve();
                }
            });
        });
    }

    async handlePublishCommand(stateId, value) {
        // Format: publish.topic.subtopic -> publish to topic/subtopic
        const topicParts = stateId.replace('publish.', '').split('.');
        const topic = topicParts.join('/');
        
        await this.publishMessage(topic, value);
    }
}

if (require.main !== module) {
    module.exports = (options) => new MqttClientAdapter(options);
} else {
    new MqttClientAdapter();
}