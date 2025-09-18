# Development Workflow and CI/CD Best Practices

This document outlines recommended development workflows, CI/CD practices, and automation strategies for ioBroker adapter development.

## Project Structure

### Standard Directory Layout
```
my-iobroker-adapter/
├── .github/
│   ├── workflows/
│   │   ├── test-and-release.yml
│   │   └── dependabot.yml
│   └── ISSUE_TEMPLATE/
├── admin/
│   ├── index_m.html
│   ├── jsonConfig.json
│   └── i18n/
├── docs/
│   └── en/
├── lib/
│   └── utils.js
├── test/
│   ├── unit/
│   └── integration/
├── src/ or main.js
├── io-package.json
├── package.json
├── README.md
├── LICENSE
├── .gitignore
├── .eslintrc.js
├── .prettierrc.js
└── tsconfig.json (for TypeScript)
```

### Essential Configuration Files

#### package.json
```json
{
  "name": "iobroker.my-adapter",
  "version": "1.0.0",
  "description": "My ioBroker Adapter",
  "author": "Your Name",
  "license": "MIT",
  "main": "main.js",
  "files": [
    "admin/",
    "docs/",
    "lib/",
    "main.js",
    "io-package.json",
    "LICENSE"
  ],
  "scripts": {
    "test": "npm run test:js && npm run test:package",
    "test:js": "mocha --config test/mocharc.custom.json src/**/*.test.js",
    "test:package": "mocha test/package --exit",
    "test:unit": "mocha test/unit --exit",
    "test:integration": "mocha test/integration --exit",
    "lint": "eslint src/ admin/ --ext .js,.ts",
    "lint:fix": "eslint src/ admin/ --ext .js,.ts --fix",
    "build": "npm run lint && npm run test",
    "release": "release-script",
    "dev": "nodemon main.js"
  },
  "dependencies": {
    "@iobroker/adapter-core": "^3.0.0"
  },
  "devDependencies": {
    "@iobroker/testing": "^4.1.0",
    "@types/node": "^18.0.0",
    "eslint": "^8.0.0",
    "mocha": "^10.0.0",
    "nodemon": "^3.0.0",
    "prettier": "^2.8.0",
    "release-script": "^6.0.0",
    "typescript": "^4.9.0"
  },
  "engines": {
    "node": ">=16.0.0"
  }
}
```

#### .eslintrc.js
```javascript
module.exports = {
    root: true,
    env: {
        es6: true,
        node: true,
        mocha: true
    },
    extends: [
        'eslint:recommended',
        '@typescript-eslint/recommended'
    ],
    parser: '@typescript-eslint/parser',
    parserOptions: {
        ecmaVersion: 2020,
        sourceType: 'module'
    },
    plugins: [
        '@typescript-eslint'
    ],
    rules: {
        'indent': ['error', 4],
        'no-console': 'warn',
        'no-unused-vars': 'error',
        'no-var': 'error',
        'prefer-const': 'error',
        'quotes': ['error', 'single'],
        'semi': ['error', 'always']
    },
    overrides: [
        {
            files: ['test/**/*.js'],
            env: {
                mocha: true
            },
            rules: {
                'no-unused-expressions': 'off'
            }
        }
    ]
};
```

## GitHub Actions Workflows

### Main CI/CD Pipeline
```yaml
# .github/workflows/test-and-release.yml
name: Test and Release

on:
  push:
    branches:
      - main
  pull_request: {}

jobs:
  # Test the adapter
  test:
    if: contains(github.event.head_commit.message, '[skip ci]') == false

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16.x, 18.x, 20.x]

    steps:
      - uses: actions/checkout@v4

      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm test

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        if: matrix.node-version == '18.x'

  # Deploy to npm on release
  deploy:
    needs: test

    if: |
      github.event_name == 'push' &&
      github.ref == 'refs/heads/main' &&
      contains(github.event.head_commit.message, '[skip ci]') == false

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Use Node.js 18.x
        uses: actions/setup-node@v4
        with:
          node-version: 18.x
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Release
        run: npm run release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### Dependency Updates
```yaml
# .github/workflows/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm
    directory: "/"
    schedule:
      interval: weekly
    open-pull-requests-limit: 10
    reviewers:
      - "your-username"
    assignees:
      - "your-username"
    commit-message:
      prefix: "chore(deps):"
      include: scope
```

### Advanced Testing Workflow
```yaml
# .github/workflows/advanced-test.yml
name: Advanced Testing

on:
  pull_request:
    branches: [main]

jobs:
  test-matrix:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [16, 18, 20]
        
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm test

  integration-test:
    runs-on: ubuntu-latest
    
    services:
      redis:
        image: redis:6
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
          
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run integration tests
        run: npm run test:integration
        env:
          REDIS_URL: redis://localhost:6379

  security-audit:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run security audit
        run: npm audit --audit-level moderate
        
      - name: Run license check
        run: npx license-checker --onlyAllow 'MIT;Apache-2.0;BSD-2-Clause;BSD-3-Clause;ISC'
```

## Development Environment Setup

### VS Code Configuration
```json
// .vscode/settings.json
{
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "eslint.autoFixOnSave": true,
    "typescript.preferences.importModuleSpecifier": "relative",
    "files.exclude": {
        "**/node_modules": true,
        "**/dist": true,
        "**/.nyc_output": true,
        "**/coverage": true
    }
}
```

```json
// .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "Debug Adapter",
            "program": "${workspaceFolder}/main.js",
            "env": {
                "NODE_ENV": "development"
            }
        },
        {
            "type": "node",
            "request": "launch",
            "name": "Run Tests",
            "program": "${workspaceFolder}/node_modules/.bin/_mocha",
            "args": ["test/**/*.test.js", "--timeout", "5000"],
            "console": "integratedTerminal"
        }
    ]
}
```

### Git Hooks with Husky
```json
// package.json (additional)
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  },
  "lint-staged": {
    "*.{js,ts}": ["eslint --fix", "git add"],
    "*.{json,md}": ["prettier --write", "git add"]
  }
}
```

### Commit Message Convention
```javascript
// .commitlintrc.js
module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'type-enum': [
            2,
            'always',
            [
                'feat',     // New feature
                'fix',      // Bug fix
                'docs',     // Documentation
                'style',    // Formatting
                'refactor', // Code refactoring
                'test',     // Adding tests
                'chore'     // Maintenance
            ]
        ],
        'subject-max-length': [2, 'always', 50],
        'body-max-line-length': [2, 'always', 72]
    }
};
```

## Release Management

### Semantic Versioning Strategy
- **Major (1.0.0 → 2.0.0)**: Breaking changes
- **Minor (1.0.0 → 1.1.0)**: New features, backward compatible
- **Patch (1.0.0 → 1.0.1)**: Bug fixes, backward compatible

### Release Script Configuration
```json
// .releaserc.js
module.exports = {
    branches: ['main'],
    plugins: [
        '@semantic-release/commit-analyzer',
        '@semantic-release/release-notes-generator',
        '@semantic-release/changelog',
        '@semantic-release/npm',
        '@semantic-release/github',
        [
            '@semantic-release/git',
            {
                assets: ['CHANGELOG.md', 'package.json'],
                message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}'
            }
        ]
    ]
};
```

### Manual Release Process
```bash
# 1. Ensure all tests pass
npm test

# 2. Update version
npm version patch|minor|major

# 3. Update changelog
npm run changelog

# 4. Commit changes
git add .
git commit -m "chore: prepare release v$(node -p "require('./package.json').version")"

# 5. Create tag
git tag -a "v$(node -p "require('./package.json').version")" -m "Release v$(node -p "require('./package.json').version")"

# 6. Push changes and tags
git push origin main --tags

# 7. Publish to npm
npm publish
```

## Quality Assurance

### Code Coverage Configuration
```javascript
// .nyc.json
{
    "reporter": ["text", "html", "lcov"],
    "exclude": [
        "test/**",
        "coverage/**",
        ".nyc_output/**",
        "admin/**"
    ],
    "check-coverage": true,
    "lines": 80,
    "functions": 80,
    "branches": 70,
    "statements": 80
}
```

### Performance Monitoring
```javascript
// Performance testing example
const { performance } = require('perf_hooks');

describe('Performance Tests', () => {
    it('should handle 1000 state updates within 5 seconds', async () => {
        const start = performance.now();
        
        const promises = [];
        for (let i = 0; i < 1000; i++) {
            promises.push(adapter.setStateAsync(`test.${i}`, { val: i, ack: true }));
        }
        
        await Promise.all(promises);
        
        const duration = performance.now() - start;
        expect(duration).toBeLessThan(5000);
    });
});
```

### Security Scanning
```bash
# Add to package.json scripts
{
  "scripts": {
    "audit": "npm audit",
    "audit:fix": "npm audit fix",
    "security:check": "npx audit-ci --moderate"
  }
}
```

## Documentation Workflow

### Auto-generated Documentation
```javascript
// Generate API documentation
const jsdoc = require('jsdoc-api');

async function generateDocs() {
    const docs = await jsdoc.explain({ files: './src/**/*.js' });
    // Process and generate markdown documentation
}
```

### Automated README Updates
```yaml
# .github/workflows/update-docs.yml
name: Update Documentation

on:
  push:
    branches: [main]
    paths: ['src/**', 'docs/**']

jobs:
  update-docs:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Generate docs
        run: npm run docs:generate
        
      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add docs/
          git diff --staged --quiet || git commit -m "docs: update generated documentation [skip ci]"
          git push
```

## Monitoring and Alerting

### Health Check Endpoint
```javascript
// Add to your adapter
class MyAdapter extends utils.Adapter {
    constructor(options) {
        super({ ...options, name: 'my-adapter' });
        this.setupHealthCheck();
    }
    
    setupHealthCheck() {
        this.on('message', (obj) => {
            if (obj && obj.command === 'health') {
                this.sendTo(obj.from, obj.command, {
                    status: 'ok',
                    uptime: process.uptime(),
                    memory: process.memoryUsage(),
                    version: require('./io-package.json').common.version
                }, obj.callback);
            }
        });
    }
}
```

### Error Tracking
```javascript
// Integration with error tracking services
const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.File({ filename: 'error.log', level: 'error' }),
        new winston.transports.Console()
    ]
});

// Use in adapter
this.on('error', (error) => {
    logger.error('Adapter error', { 
        error: error.message, 
        stack: error.stack,
        adapter: this.name,
        instance: this.instance
    });
});
```

## Best Practices Summary

1. **Consistent Structure**: Follow standard project layout
2. **Automated Testing**: Comprehensive test coverage with CI/CD
3. **Code Quality**: Linting, formatting, and security checks
4. **Semantic Versioning**: Clear versioning strategy
5. **Documentation**: Keep docs updated and auto-generated where possible
6. **Performance**: Regular performance testing and monitoring
7. **Security**: Regular security audits and dependency updates
8. **Monitoring**: Health checks and error tracking
9. **Community**: Follow ioBroker community standards and contribute back

This workflow ensures high-quality, maintainable ioBroker adapters that integrate well with the ecosystem and provide reliable functionality for users.