# Testing Guidelines for ioBroker Adapters

This document provides comprehensive testing strategies and best practices for ioBroker adapter development.

## Testing Framework Setup

### Recommended Testing Stack
- **Jest** - Primary testing framework
- **@iobroker/testing** - ioBroker-specific testing utilities
- **Sinon** - Mocking and stubbing
- **Supertest** - HTTP endpoint testing (if applicable)

### Package.json Configuration
```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  },
  "devDependencies": {
    "@iobroker/testing": "^4.1.0",
    "jest": "^29.0.0",
    "sinon": "^15.0.0"
  },
  "jest": {
    "testEnvironment": "node",
    "collectCoverageFrom": [
      "src/**/*.{js,ts}",
      "!src/**/*.d.ts"
    ],
    "testMatch": [
      "**/test/**/*.test.{js,ts}"
    ]
  }
}
```

## Unit Testing Patterns

### Adapter Mock Setup
```javascript
const { tests } = require('@iobroker/testing');

// Mock adapter for testing
class MockAdapter {
    constructor() {
        this.objects = {};
        this.states = {};
        this.config = {};
        this.log = {
            info: jest.fn(),
            warn: jest.fn(),
            error: jest.fn(),
            debug: jest.fn()
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
}
```

### State Management Testing
```javascript
describe('State Management', () => {
    let adapter;

    beforeEach(() => {
        adapter = new MockAdapter();
    });

    it('should create temperature state with correct properties', async () => {
        await adapter.setObjectNotExistsAsync('device.temperature', {
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

        expect(adapter.objects['device.temperature']).toBeDefined();
        expect(adapter.objects['device.temperature'].common.role).toBe('value.temperature');
        expect(adapter.objects['device.temperature'].common.type).toBe('number');
    });

    it('should set state value correctly', async () => {
        await adapter.setStateAsync('device.temperature', { val: 23.5, ack: true });
        
        const state = await adapter.getStateAsync('device.temperature');
        expect(state.val).toBe(23.5);
        expect(state.ack).toBe(true);
    });
});
```

### Configuration Validation Testing
```javascript
describe('Configuration Validation', () => {
    it('should validate host configuration', () => {
        const config = { host: 'localhost', port: 80 };
        const isValid = validateConfig(config);
        expect(isValid).toBe(true);
    });

    it('should reject invalid port numbers', () => {
        const config = { host: 'localhost', port: -1 };
        const isValid = validateConfig(config);
        expect(isValid).toBe(false);
    });

    it('should provide default values for missing config', () => {
        const config = {};
        const normalizedConfig = normalizeConfig(config);
        expect(normalizedConfig.host).toBe('localhost');
        expect(normalizedConfig.port).toBe(80);
    });
});
```

### Error Handling Testing
```javascript
describe('Error Handling', () => {
    let adapter;

    beforeEach(() => {
        adapter = new MockAdapter();
    });

    it('should handle connection errors gracefully', async () => {
        // Mock a failing connection
        const connectToDevice = jest.fn().mockRejectedValue(new Error('Connection failed'));
        
        try {
            await connectToDevice();
        } catch (error) {
            expect(adapter.log.error).toHaveBeenCalledWith(expect.stringContaining('Connection failed'));
        }
    });

    it('should cleanup resources on unload', async () => {
        const cleanup = jest.fn();
        adapter.cleanup = cleanup;

        await adapter.onUnload(() => {});
        expect(cleanup).toHaveBeenCalled();
    });
});
```

## Integration Testing

### Using @iobroker/testing
```javascript
const { tests } = require('@iobroker/testing');

// Integration tests using ioBroker testing framework
tests.integration(path.join(__dirname, '..'), {
    defineAdditionalTests: ({ suite }) => {
        suite('Custom Integration Tests', (getHarness) => {
            it('should start adapter successfully', () => {
                return new Promise((resolve, reject) => {
                    const harness = getHarness();
                    
                    harness.on('ready', () => {
                        expect(harness.adapter.isAlive()).toBe(true);
                        resolve();
                    });

                    harness.on('error', reject);
                    harness.startAdapter();
                });
            });

            it('should create expected objects', async () => {
                const harness = getHarness();
                await harness.startAdapter();
                
                const objects = await harness.getAdapterObjects();
                expect(objects).toHaveProperty('info');
                expect(objects).toHaveProperty('info.connection');
            });
        });
    }
});
```

### Device Communication Testing
```javascript
describe('Device Communication', () => {
    let mockServer;
    let adapter;

    beforeAll(() => {
        // Setup mock HTTP server for testing
        mockServer = setupMockServer();
    });

    afterAll(() => {
        mockServer.close();
    });

    it('should successfully fetch device data', async () => {
        mockServer.get('/api/status').reply(200, { 
            temperature: 23.5, 
            humidity: 60 
        });

        const data = await adapter.fetchDeviceData();
        expect(data.temperature).toBe(23.5);
        expect(data.humidity).toBe(60);
    });

    it('should handle API errors gracefully', async () => {
        mockServer.get('/api/status').reply(500);

        await expect(adapter.fetchDeviceData()).rejects.toThrow('API Error');
    });
});
```

## End-to-End Testing

### Admin Interface Testing
```javascript
describe('Admin Interface', () => {
    it('should validate JSON-Config schema', () => {
        const schema = require('../admin/jsonConfig.json');
        const validator = new JSONValidator();
        
        expect(() => validator.validate(schema)).not.toThrow();
    });

    it('should handle form submission correctly', async () => {
        const formData = {
            host: 'test-host',
            port: 8080,
            username: 'testuser'
        };

        const result = await submitAdminConfig(formData);
        expect(result.success).toBe(true);
    });
});
```

### Performance Testing
```javascript
describe('Performance Tests', () => {
    it('should handle multiple state updates efficiently', async () => {
        const start = Date.now();
        const promises = [];

        for (let i = 0; i < 1000; i++) {
            promises.push(adapter.setStateAsync(`test.${i}`, { val: i, ack: true }));
        }

        await Promise.all(promises);
        const duration = Date.now() - start;
        
        expect(duration).toBeLessThan(5000); // Should complete within 5 seconds
    });

    it('should not leak memory during long operations', async () => {
        const initialMemory = process.memoryUsage().heapUsed;
        
        // Perform memory-intensive operations
        for (let i = 0; i < 10000; i++) {
            await adapter.processData({ id: i, data: 'test'.repeat(100) });
        }
        
        // Force garbage collection if available
        if (global.gc) global.gc();
        
        const finalMemory = process.memoryUsage().heapUsed;
        const memoryIncrease = finalMemory - initialMemory;
        
        expect(memoryIncrease).toBeLessThan(50 * 1024 * 1024); // Less than 50MB increase
    });
});
```

## Test Data Management

### Test Fixtures
```javascript
// test/fixtures/deviceData.js
module.exports = {
    validDeviceResponse: {
        id: 'device1',
        name: 'Test Device',
        status: 'online',
        sensors: [
            { type: 'temperature', value: 23.5, unit: '°C' },
            { type: 'humidity', value: 60, unit: '%' }
        ]
    },
    
    invalidDeviceResponse: {
        error: 'Device not found'
    }
};
```

### Mock Data Generation
```javascript
const generateMockDeviceData = (count = 10) => {
    return Array.from({ length: count }, (_, index) => ({
        id: `device${index + 1}`,
        name: `Device ${index + 1}`,
        temperature: Math.random() * 30 + 15, // 15-45°C
        humidity: Math.random() * 50 + 30,    // 30-80%
        online: Math.random() > 0.1           // 90% online
    }));
};
```

## Continuous Integration

### GitHub Actions Configuration
```yaml
# .github/workflows/test.yml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [14.x, 16.x, 18.x]
    
    steps:
    - uses: actions/checkout@v3
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Run coverage
      run: npm run test:coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
```

## Best Practices

### Test Organization
- Group related tests using `describe` blocks
- Use meaningful test names that describe the expected behavior
- Keep tests independent and isolated
- Use `beforeEach`/`afterEach` for setup and cleanup

### Assertion Best Practices
- Use specific assertions rather than truthy/falsy checks
- Test both positive and negative scenarios
- Verify error messages and types
- Check side effects and state changes

### Mock Guidelines
- Mock external dependencies (network, file system, databases)
- Don't mock the code under test
- Use minimal, focused mocks
- Verify mock interactions when relevant

### Coverage Goals
- Aim for >90% code coverage
- Focus on critical paths and edge cases
- Don't sacrifice test quality for coverage numbers
- Use coverage reports to identify untested code

## Debugging Tests

### Common Issues
- **Async/await problems**: Ensure all async operations are properly awaited
- **State pollution**: Reset adapter state between tests
- **Mock cleanup**: Clear mocks and stubs after each test
- **Timeout issues**: Increase timeout for slow operations

### Debugging Tools
```javascript
// Enable debug logging in tests
process.env.DEBUG = 'iobroker:*';

// Use focused tests for debugging
it.only('should debug this specific test', async () => {
    // Test code with console.log statements
    console.log('Debug info:', adapter.states);
});
```

This testing strategy ensures comprehensive coverage of your ioBroker adapter functionality while maintaining code quality and reliability.