# JSON-Config Examples and Patterns

This document provides comprehensive examples and patterns for creating ioBroker admin interfaces using JSON-Config.

## Basic Structure

### Minimal Configuration
```json
{
    "type": "tabs",
    "items": {
        "main": {
            "type": "panel",
            "label": "Main Settings",
            "items": {
                "host": {
                    "type": "text",
                    "label": "Host",
                    "default": "localhost"
                },
                "port": {
                    "type": "number",
                    "label": "Port",
                    "default": 80
                }
            }
        }
    }
}
```

## Input Types and Examples

### Text Inputs
```json
{
    "username": {
        "type": "text",
        "label": "Username",
        "placeholder": "Enter username",
        "required": true,
        "maxLength": 50
    },
    "password": {
        "type": "password",
        "label": "Password",
        "required": true,
        "minLength": 6
    },
    "description": {
        "type": "textarea",
        "label": "Description",
        "rows": 4,
        "placeholder": "Enter description..."
    }
}
```

### Numeric Inputs
```json
{
    "port": {
        "type": "number",
        "label": "Port",
        "default": 80,
        "min": 1,
        "max": 65535,
        "step": 1
    },
    "temperature": {
        "type": "slider",
        "label": "Temperature",
        "min": -20,
        "max": 50,
        "step": 0.5,
        "unit": "°C"
    },
    "timeout": {
        "type": "number",
        "label": "Timeout",
        "default": 5000,
        "min": 1000,
        "help": "Connection timeout in milliseconds"
    }
}
```

### Boolean/Checkbox
```json
{
    "enabled": {
        "type": "checkbox",
        "label": "Enable adapter",
        "default": true
    },
    "debug": {
        "type": "checkbox",
        "label": "Debug mode",
        "default": false,
        "help": "Enable detailed logging"
    }
}
```

### Select/Dropdown
```json
{
    "protocol": {
        "type": "select",
        "label": "Protocol",
        "options": [
            {"label": "HTTP", "value": "http"},
            {"label": "HTTPS", "value": "https"},
            {"label": "TCP", "value": "tcp"}
        ],
        "default": "http"
    },
    "logLevel": {
        "type": "select",
        "label": "Log Level",
        "options": ["silly", "debug", "info", "warn", "error"],
        "default": "info"
    }
}
```

### Multi-Select
```json
{
    "features": {
        "type": "chips",
        "label": "Enabled Features",
        "options": [
            {"label": "Temperature", "value": "temp"},
            {"label": "Humidity", "value": "hum"},
            {"label": "Pressure", "value": "press"}
        ]
    }
}
```

## Advanced Patterns

### Conditional Visibility
```json
{
    "useAuthentication": {
        "type": "checkbox",
        "label": "Use Authentication",
        "default": false
    },
    "username": {
        "type": "text",
        "label": "Username",
        "hidden": "!data.useAuthentication"
    },
    "password": {
        "type": "password",
        "label": "Password",
        "hidden": "!data.useAuthentication"
    }
}
```

### Dynamic Options
```json
{
    "deviceType": {
        "type": "select",
        "label": "Device Type",
        "options": [
            {"label": "Thermostat", "value": "thermostat"},
            {"label": "Switch", "value": "switch"},
            {"label": "Sensor", "value": "sensor"}
        ]
    },
    "sensorType": {
        "type": "select",
        "label": "Sensor Type",
        "options": [
            {"label": "Temperature", "value": "temp"},
            {"label": "Humidity", "value": "hum"},
            {"label": "Motion", "value": "motion"}
        ],
        "hidden": "data.deviceType !== 'sensor'"
    }
}
```

### Validation Rules
```json
{
    "ipAddress": {
        "type": "text",
        "label": "IP Address",
        "pattern": "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
        "validatorErrorText": "Please enter a valid IP address"
    },
    "email": {
        "type": "text",
        "label": "Email",
        "validator": "email",
        "validatorErrorText": "Please enter a valid email address"
    }
}
```

## Layout Patterns

### Tabbed Interface
```json
{
    "type": "tabs",
    "items": {
        "connection": {
            "type": "panel",
            "label": "Connection",
            "icon": "mdi:connection",
            "items": {
                "host": {
                    "type": "text",
                    "label": "Host"
                },
                "port": {
                    "type": "number",
                    "label": "Port"
                }
            }
        },
        "devices": {
            "type": "panel",
            "label": "Devices",
            "icon": "mdi:devices",
            "items": {
                "deviceList": {
                    "type": "table",
                    "label": "Device List",
                    "items": []
                }
            }
        },
        "advanced": {
            "type": "panel",
            "label": "Advanced",
            "icon": "mdi:cog",
            "items": {
                "debug": {
                    "type": "checkbox",
                    "label": "Debug Mode"
                }
            }
        }
    }
}
```

### Grouped Settings
```json
{
    "type": "panel",
    "items": {
        "connectionGroup": {
            "type": "staticText",
            "label": "Connection Settings",
            "style": {
                "fontSize": 16,
                "fontWeight": "bold",
                "marginTop": 20
            }
        },
        "host": {
            "type": "text",
            "label": "Host"
        },
        "port": {
            "type": "number",
            "label": "Port"
        },
        "deviceGroup": {
            "type": "staticText",
            "label": "Device Settings",
            "style": {
                "fontSize": 16,
                "fontWeight": "bold",
                "marginTop": 20
            }
        },
        "pollInterval": {
            "type": "number",
            "label": "Poll Interval (ms)"
        }
    }
}
```

### Accordion/Collapsible Sections
```json
{
    "type": "accordion",
    "items": {
        "basic": {
            "type": "panel",
            "label": "Basic Settings",
            "expanded": true,
            "items": {
                "host": {
                    "type": "text",
                    "label": "Host"
                }
            }
        },
        "advanced": {
            "type": "panel",
            "label": "Advanced Settings",
            "expanded": false,
            "items": {
                "timeout": {
                    "type": "number",
                    "label": "Timeout"
                }
            }
        }
    }
}
```

## Dynamic Content

### Table Configuration
```json
{
    "deviceTable": {
        "type": "table",
        "label": "Devices",
        "items": [
            {
                "type": "text",
                "attr": "name",
                "label": "Name",
                "width": "30%"
            },
            {
                "type": "text",
                "attr": "ip",
                "label": "IP Address",
                "width": "25%"
            },
            {
                "type": "checkbox",
                "attr": "enabled",
                "label": "Enabled",
                "width": "15%"
            },
            {
                "type": "select",
                "attr": "type",
                "label": "Type",
                "options": ["thermostat", "switch", "sensor"],
                "width": "30%"
            }
        ]
    }
}
```

### Custom Components
```json
{
    "customComponent": {
        "type": "custom",
        "label": "Device Scanner",
        "url": "custom/deviceScanner.js",
        "height": 300
    }
}
```

## Real-World Examples

### Thermostat Adapter Configuration
```json
{
    "type": "tabs",
    "items": {
        "general": {
            "type": "panel",
            "label": "General",
            "items": {
                "hubAddress": {
                    "type": "text",
                    "label": "Hub IP Address",
                    "required": true,
                    "pattern": "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
                    "validatorErrorText": "Please enter a valid IP address"
                },
                "hubPort": {
                    "type": "number",
                    "label": "Hub Port",
                    "default": 80,
                    "min": 1,
                    "max": 65535
                },
                "pollInterval": {
                    "type": "slider",
                    "label": "Poll Interval",
                    "min": 5,
                    "max": 300,
                    "step": 5,
                    "unit": "seconds",
                    "default": 30
                }
            }
        },
        "authentication": {
            "type": "panel",
            "label": "Authentication",
            "items": {
                "useAuth": {
                    "type": "checkbox",
                    "label": "Use Authentication",
                    "default": false
                },
                "username": {
                    "type": "text",
                    "label": "Username",
                    "hidden": "!data.useAuth"
                },
                "password": {
                    "type": "password",
                    "label": "Password",
                    "hidden": "!data.useAuth"
                }
            }
        },
        "devices": {
            "type": "panel",
            "label": "Devices",
            "items": {
                "deviceList": {
                    "type": "table",
                    "label": "Thermostats",
                    "items": [
                        {
                            "type": "text",
                            "attr": "name",
                            "label": "Name",
                            "width": "25%"
                        },
                        {
                            "type": "text",
                            "attr": "id",
                            "label": "Device ID",
                            "width": "20%"
                        },
                        {
                            "type": "text",
                            "attr": "room",
                            "label": "Room",
                            "width": "20%"
                        },
                        {
                            "type": "checkbox",
                            "attr": "enabled",
                            "label": "Enabled",
                            "width": "15%"
                        },
                        {
                            "type": "select",
                            "attr": "tempUnit",
                            "label": "Unit",
                            "options": [
                                {"label": "Celsius", "value": "C"},
                                {"label": "Fahrenheit", "value": "F"}
                            ],
                            "width": "20%"
                        }
                    ]
                }
            }
        }
    }
}
```

### Network Scanner Configuration
```json
{
    "type": "panel",
    "items": {
        "scanSettings": {
            "type": "staticText",
            "label": "Network Scan Settings",
            "style": {
                "fontSize": 16,
                "fontWeight": "bold"
            }
        },
        "subnet": {
            "type": "text",
            "label": "Subnet to Scan",
            "default": "192.168.1.0/24",
            "help": "CIDR notation (e.g., 192.168.1.0/24)"
        },
        "scanPorts": {
            "type": "chips",
            "label": "Ports to Scan",
            "options": [
                {"label": "HTTP (80)", "value": 80},
                {"label": "HTTPS (443)", "value": 443},
                {"label": "Telnet (23)", "value": 23},
                {"label": "SSH (22)", "value": 22}
            ]
        },
        "autoScan": {
            "type": "checkbox",
            "label": "Enable Auto-Scan",
            "default": true
        },
        "scanInterval": {
            "type": "select",
            "label": "Scan Interval",
            "options": [
                {"label": "Every 5 minutes", "value": 300},
                {"label": "Every 15 minutes", "value": 900},
                {"label": "Every hour", "value": 3600},
                {"label": "Daily", "value": 86400}
            ],
            "default": 3600,
            "hidden": "!data.autoScan"
        },
        "foundDevices": {
            "type": "table",
            "label": "Found Devices",
            "readOnly": true,
            "items": [
                {
                    "type": "text",
                    "attr": "ip",
                    "label": "IP Address",
                    "width": "25%"
                },
                {
                    "type": "text",
                    "attr": "hostname",
                    "label": "Hostname",
                    "width": "25%"
                },
                {
                    "type": "text",
                    "attr": "mac",
                    "label": "MAC Address",
                    "width": "30%"
                },
                {
                    "type": "checkbox",
                    "attr": "monitor",
                    "label": "Monitor",
                    "width": "20%"
                }
            ]
        }
    }
}
```

## Styling and Customization

### Custom Styles
```json
{
    "title": {
        "type": "staticText",
        "label": "Adapter Configuration",
        "style": {
            "fontSize": 18,
            "fontWeight": "bold",
            "color": "#1976d2",
            "textAlign": "center",
            "marginBottom": 20
        }
    },
    "warningText": {
        "type": "staticText",
        "label": "⚠️ Warning: Changing these settings may affect device connectivity",
        "style": {
            "backgroundColor": "#fff3cd",
            "color": "#856404",
            "padding": 10,
            "borderRadius": 4,
            "border": "1px solid #ffeaa7"
        }
    }
}
```

### Responsive Layout
```json
{
    "type": "panel",
    "style": {
        "display": "grid",
        "gridTemplateColumns": "repeat(auto-fit, minmax(300px, 1fr))",
        "gap": 16
    },
    "items": {
        "leftColumn": {
            "type": "panel",
            "items": {
                "host": {"type": "text", "label": "Host"},
                "port": {"type": "number", "label": "Port"}
            }
        },
        "rightColumn": {
            "type": "panel",
            "items": {
                "username": {"type": "text", "label": "Username"},
                "password": {"type": "password", "label": "Password"}
            }
        }
    }
}
```

## Validation and Error Handling

### Custom Validators
```json
{
    "customField": {
        "type": "text",
        "label": "Custom Field",
        "validator": "data.customField && data.customField.length > 5",
        "validatorErrorText": "Field must be longer than 5 characters",
        "validatorNoSaveOnError": true
    }
}
```

### Real-time Validation
```json
{
    "emailField": {
        "type": "text",
        "label": "Email Address",
        "validator": "/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/",
        "validatorErrorText": "Please enter a valid email address",
        "validatorNoSaveOnError": true,
        "onChange": "obj.emailField && obj.emailField.match(/^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/) ? obj.emailValid = true : obj.emailValid = false"
    },
    "emailStatus": {
        "type": "staticText",
        "label": "✅ Valid email format",
        "hidden": "!data.emailValid",
        "style": {
            "color": "green"
        }
    }
}
```

This comprehensive guide covers the most common patterns and advanced features of JSON-Config for ioBroker adapter development. Use these examples as starting points and customize them according to your specific adapter requirements.