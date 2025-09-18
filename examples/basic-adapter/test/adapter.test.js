const { expect } = require('chai');
const sinon = require('sinon');

// Mock adapter for testing
class MockAdapter {
    constructor() {
        this.objects = {};
        this.states = {};
        this.config = {
            host: 'localhost',
            port: 80,
            updateInterval: 30000
        };
        this.log = {
            info: sinon.stub(),
            warn: sinon.stub(),
            error: sinon.stub(),
            debug: sinon.stub()
        };
    }

    async setObjectNotExistsAsync(id, obj) {
        if (!this.objects[id]) {
            this.objects[id] = obj;
        }
    }

    async setStateAsync(id, state) {
        this.states[id] = state;
    }

    async getStateAsync(id) {
        return this.states[id];
    }

    subscribeStates() {
        // Mock subscription
    }
}

// Import the adapter class
const BasicAdapter = require('../main.js');

describe('Basic Adapter Tests', () => {
    let adapter;

    beforeEach(() => {
        adapter = new MockAdapter();
    });

    describe('Configuration Validation', () => {
        it('should validate correct configuration', () => {
            const isValid = BasicAdapter.prototype.validateConfig.call(adapter);
            expect(isValid).to.be.true;
        });

        it('should reject missing host', () => {
            adapter.config.host = '';
            const isValid = BasicAdapter.prototype.validateConfig.call(adapter);
            expect(isValid).to.be.false;
        });

        it('should reject invalid port', () => {
            adapter.config.port = -1;
            const isValid = BasicAdapter.prototype.validateConfig.call(adapter);
            expect(isValid).to.be.false;
        });
    });

    describe('State Management', () => {
        it('should create device states correctly', async () => {
            await BasicAdapter.prototype.createDeviceStates.call(adapter, 'device1', 'Test Device');
            
            expect(adapter.objects['device1']).to.be.defined;
            expect(adapter.objects['device1'].common.name).to.equal('Test Device');
            expect(adapter.objects['device1.online']).to.be.defined;
            expect(adapter.objects['device1.power']).to.be.defined;
            expect(adapter.objects['device1.level']).to.be.defined;
        });

        it('should update device states correctly', async () => {
            await BasicAdapter.prototype.createDeviceStates.call(adapter, 'device1', 'Test Device');
            
            const data = {
                online: true,
                power: true,
                level: 75
            };
            
            await BasicAdapter.prototype.updateDeviceStates.call(adapter, 'device1', data);
            
            expect(adapter.states['device1.online'].val).to.be.true;
            expect(adapter.states['device1.power'].val).to.be.true;
            expect(adapter.states['device1.level'].val).to.equal(75);
        });
    });

    describe('State Changes', () => {
        beforeEach(async () => {
            await BasicAdapter.prototype.createDeviceStates.call(adapter, 'device1', 'Test Device');
        });

        it('should handle power state changes', async () => {
            const state = { val: true, ack: false };
            const handlePowerChange = sinon.stub(BasicAdapter.prototype, 'handlePowerChange');
            handlePowerChange.resolves();
            
            adapter.namespace = 'basic-adapter.0';
            await BasicAdapter.prototype.onStateChange.call(adapter, 'basic-adapter.0.device1.power', state);
            
            expect(handlePowerChange.calledWith('device1', true)).to.be.true;
            handlePowerChange.restore();
        });

        it('should ignore acknowledged state changes', async () => {
            const state = { val: true, ack: true };
            const handlePowerChange = sinon.spy();
            adapter.handlePowerChange = handlePowerChange;
            
            adapter.namespace = 'basic-adapter.0';
            await BasicAdapter.prototype.onStateChange.call(adapter, 'basic-adapter.0.device1.power', state);
            
            expect(handlePowerChange.called).to.be.false;
        });
    });

    describe('Error Handling', () => {
        it('should handle initialization errors gracefully', async () => {
            adapter.config.host = ''; // Invalid config
            
            try {
                await BasicAdapter.prototype.onReady.call(adapter);
            } catch (error) {
                // Should not throw
            }
            
            expect(adapter.log.error.called).to.be.true;
        });

        it('should handle state change errors gracefully', async () => {
            const state = { val: true, ack: false };
            
            // Mock handlePowerChange to throw error
            adapter.handlePowerChange = sinon.stub().rejects(new Error('Test error'));
            
            adapter.namespace = 'basic-adapter.0';
            
            try {
                await BasicAdapter.prototype.onStateChange.call(adapter, 'basic-adapter.0.device1.power', state);
            } catch (error) {
                // Should not throw
            }
            
            expect(adapter.log.error.called).to.be.true;
        });
    });

    describe('Cleanup', () => {
        it('should cleanup resources on unload', (done) => {
            adapter.updateInterval = setInterval(() => {}, 1000);
            adapter.cleanup = sinon.stub();
            
            BasicAdapter.prototype.onUnload.call(adapter, () => {
                expect(adapter.cleanup.called).to.be.true;
                done();
            });
        });
    });
});