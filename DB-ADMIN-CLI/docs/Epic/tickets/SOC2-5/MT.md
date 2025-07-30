# Create worker lambdas for db admin access data collection

## 📋 Description

Develop worker Lambda functions that connect to databases in individual AWS accounts to collect administrator access information and report back to the master orchestrator.

## 🎯 Acceptance Criteria

These worker functions connect to every database in each AWS account to pull the list of admin users so that we have complete coverage across our entire database infrastructure. Each function works independently so that if one account has issues, the others keep working and we still get most of our data.

- **Worker Lambda function written in TypeScript with Node.js runtime**
- **Function connects to both MSSQL and MySQL databases using appropriate drivers**
- **Function uses pre-configured read-only database credentials from Secrets Manager**
- **Function executes SQL queries to retrieve: username, role name, permissions level, last login date, account details**
- **Function handles database connection failures with exponential backoff (max 3 retries)**
- **Function implements connection pooling for multiple databases in same account**
- **Function validates database connectivity before attempting queries**
- **Function formats collected data into structured JSON with timestamp metadata**
- **Function uploads results to central S3 bucket using cross-account IAM role**
- **Function responds to master orchestrator with execution status and result location**
- **Function logs all database operations and errors to CloudWatch**
- **Function handles SQL injection protection and input validation**
- **Function implements proper connection cleanup and resource management**
- **Function supports both RDS and EC2-hosted databases**
- **Function includes timeout protection to prevent long-running executions**
- **Function can process multiple databases concurrently within account**