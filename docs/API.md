# API Reference

## Overview
This document provides comprehensive API documentation for Tiation Terminal Workflows.

## Workflow Definition API

### Basic Structure
```yaml
---
name: Workflow Name
command: |-
  command_to_execute {{argument}}
tags:
  - category
  - subcategory
description: Description of what the workflow does
arguments:
  - name: argument
    description: Description of the argument
    default_value: default_value
source_url: "https://example.com"
author: Author Name
author_url: "https://example.com/author"
shells: []
```

### Required Fields
- `name`: Descriptive name for the workflow
- `command`: Command template with argument placeholders
- `description`: Clear description of workflow functionality

### Optional Fields
- `tags`: Array of categorization tags
- `arguments`: Array of argument definitions
- `source_url`: Reference URL for the workflow
- `author`: Author name
- `author_url`: Author profile URL
- `shells`: Array of supported shells (empty = all shells)

## Argument Definition API

### Argument Object
```yaml
- name: argument_name
  description: Argument description
  default_value: default_value
  required: true/false
  type: string/number/boolean
  options:
    - option1
    - option2
```

### Argument Fields
- `name`: Argument name (must match template placeholder)
- `description`: User-friendly description
- `default_value`: Default value if not provided
- `required`: Whether argument is required (optional)
- `type`: Data type validation (optional)
- `options`: Array of valid options (optional)

## Enterprise API Extensions

### Security Metadata
```yaml
security:
  level: low/medium/high/critical
  audit: true/false
  permissions:
    - read
    - write
    - execute
  compliance:
    - soc2
    - pci
    - hipaa
```

### Monitoring Integration
```yaml
monitoring:
  enabled: true/false
  metrics:
    - execution_time
    - success_rate
    - error_count
  alerts:
    - on_failure
    - on_timeout
    - on_security_violation
```

### Enterprise Tags
```yaml
enterprise:
  department: engineering/operations/security
  team: frontend/backend/devops
  criticality: low/medium/high
  approval_required: true/false
```

## Workflow Categories

### Standard Categories
- `automation`: General automation workflows
- `deployment`: Deployment and release workflows
- `monitoring`: Monitoring and alerting workflows
- `security`: Security and compliance workflows
- `development`: Development and testing workflows

### Enterprise Categories
- `enterprise`: Enterprise-specific workflows
- `compliance`: Compliance and audit workflows
- `integration`: Third-party integration workflows
- `governance`: Governance and approval workflows

## Command Template Syntax

### Basic Placeholders
```bash
{{argument_name}}
```

### Advanced Placeholders
```bash
{{argument_name:default_value}}
{{argument_name|filter}}
{{argument_name?optional_text}}
```

### Conditional Logic
```bash
{{#if argument_name}}
  command_if_true
{{else}}
  command_if_false
{{/if}}
```

## Error Handling

### Common Error Codes
- `INVALID_YAML`: Workflow YAML syntax error
- `MISSING_REQUIRED_FIELD`: Required field not provided
- `INVALID_ARGUMENT`: Argument validation failed
- `COMMAND_EXECUTION_FAILED`: Command execution error
- `SECURITY_VIOLATION`: Security policy violation

### Error Response Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      "field": "field_name",
      "value": "invalid_value",
      "expected": "expected_format"
    }
  }
}
```

## Best Practices

### Naming Conventions
- Use descriptive, action-oriented names
- Include the primary tool or service
- Follow consistent capitalization

### Command Structure
- Use clear, readable command syntax
- Include error handling where appropriate
- Provide helpful output messages

### Documentation
- Include comprehensive descriptions
- Document all arguments clearly
- Provide usage examples

### Security
- Avoid hardcoded secrets
- Use environment variables for sensitive data
- Implement proper access controls

## Examples

### Basic Workflow
```yaml
---
name: List Directory Contents
command: ls -la {{directory}}
tags:
  - file_system
  - utilities
description: List all files and directories in the specified path
arguments:
  - name: directory
    description: Directory path to list
    default_value: "."
```

### Enterprise Workflow
```yaml
---
name: Deploy to Production Environment
command: |-
  echo "🚀 Starting production deployment..."
  docker build -t {{app_name}}:{{version}} .
  kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:{{version}}
  kubectl rollout status deployment/{{app_name}}
  echo "✅ Production deployment completed!"
tags:
  - enterprise
  - deployment
  - kubernetes
description: Enterprise-grade production deployment workflow
arguments:
  - name: app_name
    description: Application name
    default_value: myapp
  - name: version
    description: Version tag
    default_value: latest
  - name: registry_url
    description: Docker registry URL
    default_value: "registry.company.com"
security:
  level: high
  audit: true
  permissions:
    - execute
    - deploy
enterprise:
  department: engineering
  team: devops
  criticality: high
  approval_required: true
```

## Validation Rules

### Name Validation
- Must be 3-100 characters
- Can contain letters, numbers, spaces, and basic punctuation
- Must start with a letter

### Command Validation
- Must contain at least one command
- All argument placeholders must be defined
- No hardcoded secrets allowed

### Tag Validation
- Must be lowercase
- Can contain letters, numbers, and hyphens
- Maximum 20 tags per workflow

## Integration Points

### Warp Terminal Integration
- Automatic workflow discovery
- Argument validation
- Command execution
- Result display

### Enterprise Tool Integration
- Slack notifications
- JIRA ticket creation
- Monitoring alerts
- Audit logging

### CI/CD Integration
- Automated testing
- Security scanning
- Deployment automation
- Version control

## Troubleshooting

### Common Issues
- **Workflow Not Found**: Check file location and naming
- **Argument Validation Failed**: Verify argument definitions
- **Command Execution Failed**: Check command syntax and permissions
- **Security Violation**: Review security policies and permissions

### Debug Mode
Enable debug mode for detailed execution logging:
```bash
WARP_DEBUG=true warp execute workflow_name
```

## Support

For API questions and support:
- Documentation: [GitHub Pages](https://tiation.github.io/tiation-terminal-workflows/)
- Issues: [GitHub Issues](https://github.com/tiation/tiation-terminal-workflows/issues)
- Enterprise Support: [tiatheone@protonmail.com](mailto:tiatheone@protonmail.com)
