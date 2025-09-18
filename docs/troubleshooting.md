# Troubleshooting Guide

This document provides solutions to common issues encountered during ioBroker adapter development and deployment.

## Common Development Issues

### Adapter Won't Start

#### Symptoms
- Adapter shows as "not started" in admin interface
- No log entries from adapter
- Process exits immediately

#### Possible Causes & Solutions

**1. Missing Dependencies**
```bash
# Check for missing modules
npm ls --depth=0

# Install missing dependencies
npm install

# Check for peer dependencies
npm ls --depth=0 2>&1 | grep "UNMET DEPENDENCY"
```

**2. Incorrect Entry Point**
```javascript
// Ensure main.js or src/main.js exists and is properly referenced in package.json
{
  "main": "main.js"  // or "src/main.js"
}
```

**3. Syntax Errors**
```bash
# Check for syntax errors
node -c main.js

# Use ESLint for comprehensive checking
npm run lint
```

**4. Permission Issues**
```bash
# Check file permissions
ls -la main.js

# Fix permissions if needed
chmod +x main.js
```

### State Management Issues

#### States Not Being Created

**Symptoms**
- Objects don't appear in admin interface
- `setObjectNotExistsAsync` calls fail silently

**Solutions**
```javascript
// Always check for errors
try {
    await this.setObjectNotExistsAsync('test.state', {
        type: 'state',
        common: {
            name: 'Test State',
            type: 'boolean',
            role: 'indicator',
            read: true,
            write: true
        },
        native: {}
    });
    this.log.info('State created successfully');
} catch (error) {
    this.log.error(`Failed to create state: ${error.message}`);
}

// Verify object creation
const obj = await this.getObjectAsync('test.state');
if (!obj) {
    this.log.error('Object was not created');
}
```

#### State Changes Not Detected

**Symptoms**
- `onStateChange` callback not triggered
- States update but adapter doesn't respond

**Solutions**
```javascript
// Ensure proper subscription
async onReady() {
    // Subscribe to all state changes
    this.subscribeStates('*');
    
    // Or subscribe to specific states
    this.subscribeStates('device1.power');
}

// Check state change handler
async onStateChange(id, state) {
    // Always check if state exists and is not acknowledged
    if (!state || state.ack) return;
    
    this.log.debug(`State ${id} changed to ${state.val}`);
    
    try {
        // Process state change
        await this.handleStateChange(id, state);
    } catch (error) {
        this.log.error(`Error processing state change: ${error.message}`);
    }
}
```

### Configuration Issues

#### Admin Interface Not Loading

**Symptoms**
- Blank admin configuration page
- JavaScript errors in browser console

**Solutions**

**1. Check JSON-Config Syntax**
```bash
# Validate JSON syntax
node -e "JSON.parse(require('fs').readFileSync('admin/jsonConfig.json', 'utf8'))"
```

**2. Missing Dependencies in Admin**
```html
<!-- Ensure all required scripts are included in index_m.html -->
<script type="text/javascript" src="../../lib/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../js/adapter-settings.js"></script>
```

**3. Browser Console Errors**
```javascript
// Check browser console for JavaScript errors
// Common issues:
// - Uncaught SyntaxError in jsonConfig.json
// - Missing translation keys
// - Incorrect element selectors
```

#### Configuration Not Saving

**Symptoms**
- Settings reset after save
- No error messages in admin

**Solutions**
```javascript
// Ensure proper configuration validation
function validateConfig(config) {
    const errors = [];
    
    if (!config.host) {
        errors.push('Host is required');
    }
    
    if (config.port < 1 || config.port > 65535) {
        errors.push('Port must be between 1 and 65535');
    }
    
    return errors;
}

// In adapter code
async onReady() {
    const errors = validateConfig(this.config);
    if (errors.length > 0) {
        this.log.error('Configuration errors: ' + errors.join(', '));
        return;
    }
    
    // Proceed with initialization
}
```

## Network and Connection Issues

### Connection Timeouts

**Symptoms**
- Adapter logs "connection timeout" errors
- Intermittent connectivity issues

**Solutions**

**1. Implement Proper Timeout Handling**
```javascript
const axios = require('axios');

class NetworkManager {
    constructor(timeout = 5000) {
        this.client = axios.create({
            timeout: timeout,
            headers: {
                'User-Agent': 'ioBroker-Adapter/1.0.0'
            }
        });
        
        // Add retry logic
        this.client.interceptors.response.use(
            response => response,
            async error => {
                if (error.code === 'ECONNABORTED' || error.code === 'ENOTFOUND') {
                    // Retry logic
                    return this.retryRequest(error.config);
                }
                throw error;
            }
        );
    }
    
    async retryRequest(config, retries = 3) {
        for (let i = 0; i < retries; i++) {
            try {
                await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
                return await this.client.request(config);
            } catch (error) {
                if (i === retries - 1) throw error;
            }
        }
    }
}
```

**2. Connection Pooling**
```javascript
const http = require('http');
const https = require('https');

// Create agents with connection pooling
const httpAgent = new http.Agent({
    keepAlive: true,
    maxSockets: 10
});

const httpsAgent = new https.Agent({
    keepAlive: true,
    maxSockets: 10
});
```

### SSL/TLS Issues

**Symptoms**
- CERT_UNTRUSTED errors
- SSL handshake failures

**Solutions**
```javascript
// Handle self-signed certificates (development only)
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'; // NOT for production!

// Better approach: provide certificate validation options
const https = require('https');

const agent = new https.Agent({
    rejectUnauthorized: false // Only for development
});

// Production approach: proper certificate handling
const fs = require('fs');

const options = {
    ca: fs.readFileSync('ca-cert.pem'),
    cert: fs.readFileSync('client-cert.pem'),
    key: fs.readFileSync('client-key.pem')
};
```

## Memory and Performance Issues

### Memory Leaks

**Symptoms**
- Memory usage continuously increases
- Adapter becomes unresponsive over time

**Diagnostic Tools**
```javascript
// Monitor memory usage
setInterval(() => {
    const usage = process.memoryUsage();
    this.log.debug(`Memory usage: ${JSON.stringify(usage)}`);
}, 60000);

// Use heapdump for detailed analysis
const heapdump = require('heapdump');
heapdump.writeSnapshot('/tmp/heap-snapshot.heapsnapshot');
```

**Common Solutions**
```javascript
// 1. Properly clear intervals and timeouts
class AdapterWithCleanup extends utils.Adapter {
    constructor(options) {
        super(options);
        this.intervals = [];
        this.timeouts = [];
    }
    
    setInterval(callback, delay) {
        const id = setInterval(callback, delay);
        this.intervals.push(id);
        return id;
    }
    
    setTimeout(callback, delay) {
        const id = setTimeout(callback, delay);
        this.timeouts.push(id);
        return id;
    }
    
    async onUnload(callback) {
        // Clear all intervals and timeouts
        this.intervals.forEach(id => clearInterval(id));
        this.timeouts.forEach(id => clearTimeout(id));
        
        callback();
    }
}

// 2. Remove event listeners
this.client.removeAllListeners();

// 3. Close database connections
await this.database.close();
```

### High CPU Usage

**Symptoms**
- High CPU usage by adapter process
- System becomes slow

**Solutions**
```javascript
// 1. Optimize polling intervals
const POLLING_INTERVAL = 30000; // 30 seconds instead of 1 second

// 2. Use efficient data processing
const processLargeArray = async (array) => {
    const BATCH_SIZE = 100;
    
    for (let i = 0; i < array.length; i += BATCH_SIZE) {
        const batch = array.slice(i, i + BATCH_SIZE);
        await processBatch(batch);
        
        // Allow other operations to run
        await new Promise(resolve => setImmediate(resolve));
    }
};

// 3. Implement debouncing for frequent events
const debounce = (func, delay) => {
    let timeoutId;
    return (...args) => {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(null, args), delay);
    };
};

const debouncedUpdate = debounce(this.updateStates.bind(this), 1000);
```

## Database and Storage Issues

### Object Database Corruption

**Symptoms**
- Objects not loading correctly
- Inconsistent object data

**Solutions**
```bash
# Stop ioBroker
iobroker stop

# Backup current database
cp -r /opt/iobroker/iobroker-data/objects.json /opt/iobroker/iobroker-data/objects.json.backup

# Restart with database repair
iobroker start --force

# If issues persist, recreate objects
iobroker object list system.adapter.my-adapter.0.*
iobroker object del system.adapter.my-adapter.0.*
```

**Prevent Corruption**
```javascript
// Always use try-catch for object operations
async createObjectSafely(id, obj) {
    try {
        await this.setObjectNotExistsAsync(id, obj);
        
        // Verify creation
        const created = await this.getObjectAsync(id);
        if (!created) {
            throw new Error(`Object ${id} was not created`);
        }
        
        return true;
    } catch (error) {
        this.log.error(`Failed to create object ${id}: ${error.message}`);
        return false;
    }
}
```

## Testing and Debugging Issues

### Tests Failing Unexpectedly

**Common Issues and Solutions**

**1. Async/Await Problems**
```javascript
// Wrong: Missing await
it('should create state', () => {
    adapter.setStateAsync('test', { val: true, ack: true });
    expect(adapter.states['test']).toBeDefined();
});

// Correct: Proper async handling
it('should create state', async () => {
    await adapter.setStateAsync('test', { val: true, ack: true });
    expect(adapter.states['test']).toBeDefined();
});
```

**2. Test Isolation Issues**
```javascript
describe('Adapter Tests', () => {
    let adapter;
    
    beforeEach(() => {
        // Create fresh adapter instance for each test
        adapter = new MockAdapter();
    });
    
    afterEach(async () => {
        // Cleanup after each test
        if (adapter && adapter.destroy) {
            await adapter.destroy();
        }
    });
});
```

**3. Mock Configuration**
```javascript
// Proper mock setup
const mockAdapter = {
    log: {
        info: jest.fn(),
        warn: jest.fn(),
        error: jest.fn(),
        debug: jest.fn()
    },
    config: {
        host: 'localhost',
        port: 80
    },
    states: {},
    objects: {},
    
    setStateAsync: jest.fn().mockImplementation(function(id, state) {
        this.states[id] = state;
        return Promise.resolve();
    }),
    
    getStateAsync: jest.fn().mockImplementation(function(id) {
        return Promise.resolve(this.states[id]);
    })
};
```

### Debugging in Production

**Safe Debugging Techniques**
```javascript
// 1. Conditional debug logging
if (this.config.debugMode) {
    this.log.debug('Debug info:', JSON.stringify(data, null, 2));
}

// 2. State-based debugging
await this.setStateAsync('debug.lastUpdate', { 
    val: Date.now(), 
    ack: true 
});

await this.setStateAsync('debug.errorCount', { 
    val: this.errorCount, 
    ack: true 
});

// 3. Remote debugging setup
if (process.env.NODE_ENV === 'development') {
    const inspector = require('inspector');
    inspector.open(9229, '0.0.0.0');
}
```

## Deployment and Installation Issues

### NPM Package Issues

**Symptoms**
- Package installation fails
- Missing files in published package

**Solutions**
```json
// package.json: Ensure proper files field
{
  "files": [
    "admin/",
    "docs/",
    "lib/",
    "main.js",
    "io-package.json",
    "LICENSE",
    "README.md"
  ]
}
```

```bash
# Test package before publishing
npm pack
tar -tzf iobroker.my-adapter-1.0.0.tgz

# Check for excluded files
npm run prepare
```

### Version Compatibility Issues

**Node.js Version Issues**
```json
// package.json: Specify supported Node versions
{
  "engines": {
    "node": ">=16.0.0",
    "npm": ">=7.0.0"
  }
}
```

**ioBroker Version Compatibility**
```json
// io-package.json: Specify minimum ioBroker version
{
  "common": {
    "dependencies": [
      {
        "js-controller": ">=4.0.0"
      }
    ]
  }
}
```

## Performance Optimization

### Monitoring Tools
```javascript
// Built-in performance monitoring
const { performance, PerformanceObserver } = require('perf_hooks');

const obs = new PerformanceObserver((list) => {
    const entries = list.getEntries();
    entries.forEach((entry) => {
        if (entry.duration > 1000) { // Log slow operations
            this.log.warn(`Slow operation: ${entry.name} took ${entry.duration}ms`);
        }
    });
});
obs.observe({ entryTypes: ['measure'] });

// Measure operation performance
performance.mark('operation-start');
await someExpensiveOperation();
performance.mark('operation-end');
performance.measure('operation-duration', 'operation-start', 'operation-end');
```

### Optimization Strategies
```javascript
// 1. Batch state updates
const stateUpdates = [];
stateUpdates.push(['device1.temperature', { val: 23.5, ack: true }]);
stateUpdates.push(['device1.humidity', { val: 60, ack: true }]);

await Promise.all(stateUpdates.map(([id, state]) => 
    this.setStateAsync(id, state)
));

// 2. Cache frequently accessed data
class CachedDataManager {
    constructor(ttl = 60000) { // 1 minute TTL
        this.cache = new Map();
        this.ttl = ttl;
    }
    
    async get(key, fetchFunction) {
        const cached = this.cache.get(key);
        if (cached && Date.now() - cached.timestamp < this.ttl) {
            return cached.data;
        }
        
        const data = await fetchFunction();
        this.cache.set(key, { data, timestamp: Date.now() });
        return data;
    }
}
```

## Best Practices for Troubleshooting

1. **Comprehensive Logging**: Include context and relevant data in log messages
2. **Error Boundaries**: Wrap critical operations in try-catch blocks
3. **Health Checks**: Implement status monitoring and reporting
4. **Gradual Rollout**: Test changes in development environment first
5. **Monitoring**: Set up alerts for critical failures
6. **Documentation**: Keep troubleshooting steps documented
7. **Community Support**: Engage with ioBroker community for complex issues

## Getting Help

### Community Resources
- **ioBroker Forum**: https://forum.iobroker.net/
- **GitHub Discussions**: Repository-specific discussions
- **Discord/Telegram**: Real-time community support

### Debugging Information to Provide
```javascript
// Collect debug information
const debugInfo = {
    adapterVersion: require('./io-package.json').common.version,
    nodeVersion: process.version,
    platform: process.platform,
    arch: process.arch,
    memoryUsage: process.memoryUsage(),
    uptime: process.uptime(),
    lastError: this.lastError,
    configuration: this.config // Remove sensitive data!
};

this.log.info('Debug info:', JSON.stringify(debugInfo, null, 2));
```

This troubleshooting guide covers the most common issues encountered in ioBroker adapter development. Always check logs first, and don't hesitate to reach out to the community for assistance with complex problems.