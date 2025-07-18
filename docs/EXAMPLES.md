# Workflow Examples

## Overview
This document provides practical examples of Tiation Terminal Workflows for various enterprise use cases.

## Basic Examples

### 1. File System Operations
```yaml
---
name: Create Project Directory Structure
command: |-
  mkdir -p {{project_name}}/{src,docs,tests,config}
  touch {{project_name}}/README.md
  touch {{project_name}}/src/main.js
  touch {{project_name}}/tests/test.js
  echo "Project {{project_name}} created successfully!"
tags:
  - filesystem
  - project-setup
description: Create a standard project directory structure
arguments:
  - name: project_name
    description: Name of the project
    default_value: "my-project"
```

### 2. Git Operations
```yaml
---
name: Initialize Git Repository with Standard Setup
command: |-
  cd {{project_path}}
  git init
  echo "node_modules/" > .gitignore
  echo "*.log" >> .gitignore
  git add .
  git commit -m "Initial commit"
  git branch -M main
  echo "Git repository initialized successfully!"
tags:
  - git
  - initialization
description: Initialize a new Git repository with standard configuration
arguments:
  - name: project_path
    description: Path to the project directory
    default_value: "."
```

## Enterprise Examples

### 1. Deployment Workflows

#### Production Deployment
```yaml
---
name: Deploy Application to Production
command: |-
  echo "🚀 Starting production deployment for {{app_name}}..."
  
  # Build application
  docker build -t {{registry_url}}/{{app_name}}:{{version}} .
  
  # Push to registry
  docker push {{registry_url}}/{{app_name}}:{{version}}
  
  # Deploy to Kubernetes
  kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:{{version}}
  kubectl rollout status deployment/{{app_name}}
  
  # Verify deployment
  kubectl get pods -l app={{app_name}}
  
  echo "✅ Production deployment completed successfully!"
tags:
  - enterprise
  - deployment
  - kubernetes
  - production
description: Deploy application to production environment with verification
arguments:
  - name: app_name
    description: Application name
    default_value: "myapp"
  - name: version
    description: Version tag
    default_value: "latest"
  - name: registry_url
    description: Docker registry URL
    default_value: "registry.company.com"
security:
  level: high
  audit: true
  permissions:
    - deploy
    - kubernetes
enterprise:
  department: engineering
  team: devops
  criticality: high
  approval_required: true
```

#### Staging Deployment
```yaml
---
name: Deploy to Staging Environment
command: |-
  echo "🔄 Deploying {{app_name}} to staging..."
  
  # Build and tag
  docker build -t {{registry_url}}/{{app_name}}:staging-{{version}} .
  docker push {{registry_url}}/{{app_name}}:staging-{{version}}
  
  # Deploy to staging namespace
  kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:staging-{{version}} -n staging
  kubectl rollout status deployment/{{app_name}} -n staging
  
  # Run smoke tests
  kubectl run smoke-test --image={{registry_url}}/{{app_name}}:staging-{{version}} --restart=Never -- npm test
  
  echo "✅ Staging deployment completed!"
tags:
  - enterprise
  - deployment
  - staging
  - testing
description: Deploy application to staging environment with smoke tests
arguments:
  - name: app_name
    description: Application name
    default_value: "myapp"
  - name: version
    description: Version tag
    default_value: "latest"
  - name: registry_url
    description: Docker registry URL
    default_value: "registry.company.com"
```

### 2. Security Workflows

#### Security Audit
```yaml
---
name: Comprehensive Security Audit
command: |-
  echo "🔒 Starting security audit..."
  
  # Dependency vulnerability scan
  npm audit --audit-level=moderate
  
  # Docker image security scan
  docker scan {{image_name}}
  
  # Code security analysis
  bandit -r {{source_directory}}
  
  # Network security check
  nmap -sV {{target_host}}
  
  echo "✅ Security audit completed!"
tags:
  - enterprise
  - security
  - audit
  - vulnerability
description: Comprehensive security audit including dependencies, Docker, and code analysis
arguments:
  - name: image_name
    description: Docker image to scan
    default_value: "myapp:latest"
  - name: source_directory
    description: Source code directory
    default_value: "./src"
  - name: target_host
    description: Target host for network scan
    default_value: "localhost"
security:
  level: high
  audit: true
  permissions:
    - security-scan
    - network-scan
```

#### Access Control Audit
```yaml
---
name: User Access Control Audit
command: |-
  echo "👥 Auditing user access controls..."
  
  # List all users with sudo access
  grep -Po '^sudo.+:\K.*$' /etc/group
  
  # Check for users with empty passwords
  awk -F: '($2 == "" ) { print $1 }' /etc/shadow
  
  # List recently failed login attempts
  journalctl _SYSTEMD_UNIT=ssh.service | grep "Failed password"
  
  # Check file permissions for sensitive files
  find /etc -name "passwd" -o -name "shadow" -o -name "group" | xargs ls -la
  
  echo "✅ Access control audit completed!"
tags:
  - enterprise
  - security
  - access-control
  - audit
description: Audit user access controls and security configurations
security:
  level: critical
  audit: true
  permissions:
    - system-admin
    - security-audit
```

### 3. Monitoring Workflows

#### Health Check
```yaml
---
name: Application Health Check
command: |-
  echo "💊 Performing health check for {{service_name}}..."
  
  # Check service status
  kubectl get pods -l app={{service_name}}
  
  # Check service endpoints
  curl -f http://{{service_url}}/health || echo "Health endpoint failed"
  
  # Check resource usage
  kubectl top pods -l app={{service_name}}
  
  # Check recent logs for errors
  kubectl logs -l app={{service_name}} --since=1h | grep -i error
  
  echo "✅ Health check completed!"
tags:
  - enterprise
  - monitoring
  - health-check
  - kubernetes
description: Comprehensive health check for Kubernetes applications
arguments:
  - name: service_name
    description: Service name to check
    default_value: "myapp"
  - name: service_url
    description: Service URL for health check
    default_value: "http://localhost:8080"
```

#### Performance Monitoring
```yaml
---
name: Performance Monitoring Report
command: |-
  echo "📊 Generating performance report..."
  
  # CPU and memory usage
  top -b -n1 | head -20
  
  # Disk usage
  df -h
  
  # Network statistics
  netstat -i
  
  # Application metrics
  curl -s http://{{metrics_url}}/metrics | grep -E "(cpu|memory|requests)"
  
  echo "✅ Performance report generated!"
tags:
  - enterprise
  - monitoring
  - performance
  - metrics
description: Generate comprehensive performance monitoring report
arguments:
  - name: metrics_url
    description: Metrics endpoint URL
    default_value: "http://localhost:9090"
```

### 4. Backup and Recovery

#### Database Backup
```yaml
---
name: Database Backup with Rotation
command: |-
  echo "💾 Starting database backup..."
  
  # Create backup directory
  mkdir -p {{backup_path}}/$(date +%Y-%m-%d)
  
  # Perform database backup
  pg_dump -h {{db_host}} -U {{db_user}} {{db_name}} > {{backup_path}}/$(date +%Y-%m-%d)/{{db_name}}_$(date +%H%M%S).sql
  
  # Compress backup
  gzip {{backup_path}}/$(date +%Y-%m-%d)/{{db_name}}_$(date +%H%M%S).sql
  
  # Remove backups older than 7 days
  find {{backup_path}} -name "*.gz" -mtime +7 -delete
  
  echo "✅ Database backup completed!"
tags:
  - enterprise
  - backup
  - database
  - postgresql
description: Create PostgreSQL database backup with automatic rotation
arguments:
  - name: db_host
    description: Database host
    default_value: "localhost"
  - name: db_user
    description: Database user
    default_value: "postgres"
  - name: db_name
    description: Database name
    default_value: "myapp"
  - name: backup_path
    description: Backup directory path
    default_value: "/backup/postgres"
security:
  level: high
  audit: true
  permissions:
    - database-backup
```

#### Disaster Recovery Test
```yaml
---
name: Disaster Recovery Test
command: |-
  echo "🔄 Starting disaster recovery test..."
  
  # Test backup restoration
  echo "Testing backup restoration..."
  pg_restore -h {{test_db_host}} -U {{db_user}} -d {{test_db_name}} {{backup_file}}
  
  # Verify data integrity
  echo "Verifying data integrity..."
  psql -h {{test_db_host}} -U {{db_user}} -d {{test_db_name}} -c "SELECT COUNT(*) FROM users;"
  
  # Test application connectivity
  echo "Testing application connectivity..."
  curl -f http://{{test_app_url}}/health || echo "Application health check failed"
  
  # Clean up test environment
  echo "Cleaning up test environment..."
  dropdb -h {{test_db_host}} -U {{db_user}} {{test_db_name}}
  
  echo "✅ Disaster recovery test completed!"
tags:
  - enterprise
  - disaster-recovery
  - testing
  - backup
description: Test disaster recovery procedures and data restoration
arguments:
  - name: test_db_host
    description: Test database host
    default_value: "test-db.company.com"
  - name: db_user
    description: Database user
    default_value: "postgres"
  - name: test_db_name
    description: Test database name
    default_value: "myapp_test"
  - name: backup_file
    description: Backup file path
    default_value: "/backup/latest.sql"
  - name: test_app_url
    description: Test application URL
    default_value: "http://test.company.com"
```

## Integration Examples

### 1. Slack Integration
```yaml
---
name: Deploy with Slack Notification
command: |-
  echo "🚀 Deploying {{app_name}}..."
  
  # Send deployment start notification
  curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"🚀 Deployment started for {{app_name}} version {{version}}"}' \
    {{slack_webhook_url}}
  
  # Perform deployment
  kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:{{version}}
  
  # Wait for rollout
  kubectl rollout status deployment/{{app_name}}
  
  # Send success notification
  curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"✅ Deployment successful for {{app_name}} version {{version}}"}' \
    {{slack_webhook_url}}
  
  echo "✅ Deployment completed with Slack notifications!"
tags:
  - enterprise
  - deployment
  - slack
  - notifications
description: Deploy application with Slack notifications
arguments:
  - name: app_name
    description: Application name
    default_value: "myapp"
  - name: version
    description: Version tag
    default_value: "latest"
  - name: registry_url
    description: Docker registry URL
    default_value: "registry.company.com"
  - name: slack_webhook_url
    description: Slack webhook URL
    default_value: "$SLACK_WEBHOOK_URL"
```

### 2. JIRA Integration
```yaml
---
name: Create JIRA Release Ticket
command: |-
  echo "🎫 Creating JIRA release ticket..."
  
  # Create release ticket
  curl -X POST \
    -H "Authorization: Basic $JIRA_AUTH" \
    -H "Content-Type: application/json" \
    -d '{
      "fields": {
        "project": {"key": "{{project_key}}"},
        "summary": "Release {{app_name}} version {{version}}",
        "description": "{{description}}",
        "issuetype": {"name": "Task"}
      }
    }' \
    "{{jira_url}}/rest/api/2/issue/"
  
  echo "✅ JIRA ticket created!"
tags:
  - enterprise
  - jira
  - release
  - tickets
description: Create JIRA ticket for application release
arguments:
  - name: project_key
    description: JIRA project key
    default_value: "REL"
  - name: app_name
    description: Application name
    default_value: "myapp"
  - name: version
    description: Version tag
    default_value: "1.0.0"
  - name: description
    description: Release description
    default_value: "Production release"
  - name: jira_url
    description: JIRA base URL
    default_value: "https://company.atlassian.net"
```

## Advanced Examples

### 1. Multi-Environment Deployment
```yaml
---
name: Multi-Environment Deployment Pipeline
command: |-
  echo "🌍 Starting multi-environment deployment..."
  
  # Deploy to development
  echo "Deploying to development..."
  kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:{{version}} -n development
  kubectl rollout status deployment/{{app_name}} -n development
  
  # Run tests
  echo "Running integration tests..."
  kubectl run integration-test --image={{registry_url}}/{{app_name}}:{{version}} --restart=Never -n development -- npm run test:integration
  
  # Deploy to staging
  echo "Deploying to staging..."
  kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:{{version}} -n staging
  kubectl rollout status deployment/{{app_name}} -n staging
  
  # Deploy to production (with approval)
  echo "Ready for production deployment. Proceed? (y/n)"
  read -r approval
  if [[ "$approval" == "y" ]]; then
    kubectl set image deployment/{{app_name}} {{app_name}}={{registry_url}}/{{app_name}}:{{version}} -n production
    kubectl rollout status deployment/{{app_name}} -n production
    echo "✅ Multi-environment deployment completed!"
  else
    echo "❌ Production deployment cancelled"
  fi
tags:
  - enterprise
  - deployment
  - multi-environment
  - pipeline
description: Deploy application across multiple environments with testing and approval
arguments:
  - name: app_name
    description: Application name
    default_value: "myapp"
  - name: version
    description: Version tag
    default_value: "latest"
  - name: registry_url
    description: Docker registry URL
    default_value: "registry.company.com"
```

### 2. Automated Rollback
```yaml
---
name: Automated Rollback with Health Check
command: |-
  echo "🔄 Initiating rollback for {{app_name}}..."
  
  # Get current revision
  current_revision=$(kubectl rollout history deployment/{{app_name}} | tail -1 | awk '{print $1}')
  
  # Perform rollback
  kubectl rollout undo deployment/{{app_name}}
  kubectl rollout status deployment/{{app_name}}
  
  # Wait for rollback to complete
  sleep 30
  
  # Health check
  health_check=$(curl -s -o /dev/null -w "%{http_code}" http://{{service_url}}/health)
  
  if [[ "$health_check" == "200" ]]; then
    echo "✅ Rollback successful! Health check passed."
  else
    echo "❌ Rollback failed! Health check returned: $health_check"
    # Notify team
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"❌ Rollback failed for {{app_name}}! Manual intervention required."}' \
      {{slack_webhook_url}}
  fi
tags:
  - enterprise
  - rollback
  - health-check
  - automation
description: Automated rollback with health verification and notifications
arguments:
  - name: app_name
    description: Application name
    default_value: "myapp"
  - name: service_url
    description: Service URL for health check
    default_value: "http://localhost:8080"
  - name: slack_webhook_url
    description: Slack webhook URL
    default_value: "$SLACK_WEBHOOK_URL"
```

## Best Practices

### 1. Error Handling
Always include proper error handling in your workflows:
```yaml
command: |-
  set -e  # Exit on error
  
  # Your commands here
  command_that_might_fail || {
    echo "Error: Command failed"
    exit 1
  }
```

### 2. Logging
Include comprehensive logging:
```yaml
command: |-
  echo "$(date): Starting workflow {{workflow_name}}"
  
  # Your commands here
  
  echo "$(date): Workflow completed successfully"
```

### 3. Security
Use environment variables for sensitive data:
```yaml
command: |-
  # Use environment variables instead of hardcoded values
  api_key="$API_KEY"
  database_password="$DB_PASSWORD"
```

### 4. Validation
Include input validation:
```yaml
command: |-
  # Validate required parameters
  if [[ -z "{{app_name}}" ]]; then
    echo "Error: app_name is required"
    exit 1
  fi
```

## Conclusion

These examples demonstrate the power and flexibility of Tiation Terminal Workflows for enterprise use cases. They can be customized and extended to meet specific organizational needs while maintaining security and compliance requirements.
