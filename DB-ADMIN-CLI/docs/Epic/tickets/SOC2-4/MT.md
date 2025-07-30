# Create orchestrator lambda for db admin user reporting

## 📋 Description

Develop the master orchestrator Lambda function that coordinates the execution of database administrator access reporting across multiple AWS accounts and regions.

## 🎯 Acceptance Criteria

This Lambda function gathers database admin reports from all our AWS accounts on-demand so that compliance teams can quickly generate reports for audits and compliance reviews. One central system handles all the coordination work so that we reduce errors and save hours of manual effort each time reports are needed.

- **Lambda function written in TypeScript with Node.js runtime**
- **Function accepts configuration parameters for target accounts and regions**
- **Function reads database inventory from S3 configuration store**
- **Function invokes worker Lambdas in target accounts using cross-account IAM roles**
- **Function implements 10-minute timeout for worker Lambda executions**
- **Function handles worker Lambda failures with exponential backoff retry logic (max 3 retries)**
- **Function collects and aggregates results from all worker Lambdas**
- **Function generates consolidated CSV reports with timestamp metadata**
- **Function stores final reports in central S3 bucket with organized naming convention**
- **Function logs all operations to CloudWatch with appropriate log levels**
- **Function handles partial failures gracefully and reports status for each account**
- **Function includes comprehensive error handling for network timeouts and permission issues**
- **Function validates worker Lambda responses before processing**
- **Performance optimized for handling 10+ databases across multiple accounts**