# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The DB Admin Reports CLI Tool is a TypeScript-based system designed to generate on-demand database administrator access reports for SOC2 audit compliance. The system triggers cross-account data collection across AWS environments and produces CSV reports.

## Architecture

This is a multi-component AWS serverless system:

- **CLI Tool**: TypeScript/Node.js CLI that triggers report generation
- **Master Orchestrator Lambda**: Coordinates cross-account execution from bb-us-product account (209371858707)  
- **Worker Lambdas**: Deployed across target accounts to collect database admin data
- **Infrastructure**: Pulumi-managed AWS resources (IAM, S3, CloudWatch)
- **Reports**: Generated CSV files stored in central S3 bucket

The system handles both MSSQL and MySQL databases across multiple AWS accounts and regions.

## Key Development Commands

Since this project is in early development phase, the following commands will be relevant once implementation begins:

```bash
# Environment validation
../validate_env.sh

# TypeScript compilation (when implemented)
npm run build

# Testing (when implemented)
npm test
npm run test:unit
npm run test:integration

# AWS SAM development (when implemented)
sam local start-api
sam local invoke

# Pulumi infrastructure deployment (when implemented)
pulumi up
pulumi preview

# CLI execution (when implemented)
npm run cli -- generate --accounts 123456789012 --regions us-east-1
```

## Development Environment Requirements

Based on `../validate_env.sh`, the following tools are required:

- **Core**: Node.js 18+, npm 8+, TypeScript, Git
- **AWS**: AWS CLI, AWS SAM CLI 1.0+, Pulumi
- **Azure**: Azure CLI with DevOps extension
- **Testing**: Jest (as project dependency)
- **Code Quality**: ESLint, Prettier (as project dependencies)
- **Database**: MySQL Client, SQL Server Client (for local testing)
- **Optional**: Claude CLI, WSL (Windows), Python

## Code Structure Guidelines

### TypeScript Configuration
- Strict type checking enabled
- Uses AWS SDK for JavaScript v3
- Target runtime: Node.js 18.x

### Error Handling Pattern
```typescript
try {
  const result = await operation();
  logger.info('Operation completed successfully', { result });
  return result;
} catch (error) {
  logger.error('Operation failed', { 
    error: error.message, 
    stack: error.stack,
    context: { operation: 'operationName' }
  });
  throw new CustomError('Operation failed', { cause: error });
}
```

### Logging Standards
- Structured JSON logging with correlation IDs
- CloudWatch Log Groups with 90-day retention for security logs
- Consistent log levels: INFO, WARN, ERROR

## Key Interfaces

### Database Admin User
```typescript
interface DatabaseAdminUser {
  username: string;
  role_name: string;
  permission_level: string;
  last_login_date: string;
  account_details: string;
  database_name: string;
  database_type: 'MSSQL' | 'MySQL';
  collection_timestamp: string;
}
```

### Worker Response
```typescript
interface WorkerResponse {
  accountId: string;
  region: string;
  status: 'success' | 'failure';
  s3Location?: string;
  errorMessage?: string;
  dataCount?: number;
}
```

## Security Requirements

- **Encryption**: All data encrypted at rest and in transit (TLS 1.2+)
- **IAM**: Least-privilege cross-account roles
- **Credentials**: AWS Secrets Manager for database credentials
- **SQL Injection**: Parameterized queries only
- **Input Validation**: Validate all connection parameters
- **Audit Trail**: Complete logging for SOC2 compliance

## Database Query Patterns

### SQL Server Admin Users
```sql
SELECT 
    dp.name AS username,
    dp.type_desc AS user_type,
    CASE 
        WHEN dp.name IN (SELECT name FROM sys.server_principals WHERE type = 'S') THEN 'System Admin'
        WHEN dp.name IN (SELECT name FROM sys.server_principals WHERE type = 'U') THEN 'User'
        ELSE 'Other'
    END AS role_name,
    'Admin' AS permission_level,
    COALESCE(CAST(LOGINPROPERTY(dp.name, 'LastLoginTime') AS VARCHAR), 'Never') AS last_login_date,
    @@SERVERNAME AS account_details
FROM sys.server_principals dp
WHERE dp.type IN ('S', 'U')
    AND dp.name NOT LIKE '##%'
    AND dp.name NOT IN ('sa', 'public', 'guest')
ORDER BY dp.name;
```

### MySQL Admin Users
```sql
SELECT 
    u.User AS username,
    u.Host AS host,
    CASE 
        WHEN u.User = 'root' THEN 'Root Admin'
        WHEN u.Select_priv = 'Y' AND u.Insert_priv = 'Y' AND u.Update_priv = 'Y' AND u.Delete_priv = 'Y' THEN 'Full Admin'
        ELSE 'Limited User'
    END AS role_name,
    CASE 
        WHEN u.User = 'root' OR (u.Select_priv = 'Y' AND u.Insert_priv = 'Y' AND u.Update_priv = 'Y' AND u.Delete_priv = 'Y') THEN 'Admin'
        ELSE 'User'
    END AS permission_level,
    COALESCE(u.authentication_string, 'N/A') AS last_login_date,
    @@hostname AS account_details
FROM mysql.user u
WHERE u.User NOT IN ('', 'debian-sys-maint', 'mysql.session', 'mysql.sys')
ORDER BY u.User, u.Host;
```

## Testing Strategy

- **Unit Tests**: 80% minimum code coverage using Jest
- **Integration Tests**: End-to-end workflow testing
- **Load Tests**: Test with 100+ databases across multiple accounts
- **Security Tests**: Regular penetration testing and vulnerability scanning

## Performance Requirements

- Complete execution within 15 minutes for typical environments
- 95%+ successful report generation rate
- Efficient memory usage for large dataset processing
- Handle 10+ databases across multiple accounts concurrently

## AWS Dependencies

- **Lambda Runtime**: Node.js 18.x
- **Database Drivers**: `mssql`, `mysql2`
- **AWS SDK**: v3 (`@aws-sdk/client-lambda`, `@aws-sdk/client-s3`, `@aws-sdk/client-sts`, `@aws-sdk/client-secrets-manager`)
- **Cross-Account Access**: STS role assumption with 10-minute timeout
- **Storage**: Central S3 bucket for reports and configuration

## Documentation Location

All project documentation is in `docs/Epic/`:
- `project_guidelines.md`: Comprehensive technical requirements and architecture
- `SOC2-2.md`: Business overview and workflow
- `tickets/SOC2-4/`: Individual development tasks and tickets

## Deployment Strategy

1. **Infrastructure**: Deploy Pulumi resources across all accounts
2. **Lambda Functions**: Deploy worker Lambdas to target accounts, orchestrator to central account
3. **CLI Tool**: Develop and package CLI with proper authentication
4. **Testing**: Comprehensive testing across all environments

### /create-prd
**Prompt:**
Generate a detailed Project Requirements Document based on this codebase.

### /generate-tasks
**Prompt:**
Break the PRD into detailed, time-estimated engineering tasks.

### /process-task-list
**Prompt:**
For each task, generate infrastructure code using Pulumi and TypeScript.