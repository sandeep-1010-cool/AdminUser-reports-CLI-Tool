Certainly! Let's systematically incorporate the new information about **database inventory** and **credential management** into the guidelines. Below is the updated version with detailed modifications and integration of the new details.

---

# **DB Admin Reports CLI Tool - Project Guidelines (Single Lambda Architecture)**

## 📑 **Table of Contents**

1. [🎯 Project Overview](#project-overview)  
2. [🏗️ System Architecture](#system-architecture)  
3. [📋 Complete Workflow](#complete-workflow)  
4. [🛠️ Technical Requirements](#technical-requirements)  
5. [🔧 Development Guidelines](#development-guidelines)  
6. [🚀 Deployment Strategy](#deployment-strategy)  
7. [📊 Monitoring and Observability](#monitoring-and-observability)  
8. [🔒 Security Considerations](#security-considerations)  
9. [📈 Performance Optimization](#performance-optimization)  
10. [🧪 Testing Strategy](#testing-strategy)  
11. [📚 Documentation Requirements](#documentation-requirements)  
12. [🎯 Success Metrics](#success-metrics)  
13. [🔄 Maintenance and Operations](#maintenance-and-operations)

---

## 🎯 **Project Overview**

### **Primary Goal**
Develop a CLI tool that generates on-demand database administrator access reports by invoking a single Lambda function. The Lambda assumes cross-account IAM roles to query databases across multiple AWS accounts and consolidates the results into a CSV report for SOC2 audit compliance.

### **Business Value**
- **Automation**: Streamlines SOC2 audit reporting by eliminating manual processes.  
- **Compliance**: Ensures timestamped, auditable reports for regulatory adherence.  
- **Efficiency**: Reduces time and effort for audit cycles.  
- **Reliability**: Guarantees complete coverage across all database infrastructure.

---

## 🏗️ **System Architecture**

### **High-Level Architecture**
```
┌──────────────┐    ┌─────────────────────────────┐
│   CLI Tool   │───▶│ Orchestrator Lambda (Single)│
│ (Entry Point)│    │ - Assumes cross-account IAM │
└──────────────┘    │   roles, queries DBs        │
                    └─────────────────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │ Central S3      │
                       │ Bucket          │
                       └─────────────────┘
```

### **Detailed Architecture Diagram**
```mermaid
graph TD
    A[CLI Command] --> B[Orchestrator Lambda]
    B --> C[Read DB Inventory from S3]
    B --> D[Assume Cross-Account IAM Roles]
    D --> E[Connect to Databases MSSQL/MySQL in Target Accounts]
    E --> F[Collect Admin User Data]
    F --> G[Upload Results to Central S3]
    G --> H[Generate Consolidated CSV]
    H --> I[Store CSV in Central S3]
    I --> J[CLI Displays Status & S3 Location]

    classDef lambda fill:#f9d,stroke:#333,stroke-width:2px
    class B lambda
    classDef s3 fill:#9f6,stroke:#333,stroke-width:2px
    class C,G,I s3
    classDef db fill:#69c,stroke:#333,stroke-width:2px
    class E db
    classDef cli fill:#fc6,stroke:#333,stroke-width:2px
    class A,J cli
---

## 📋 **Complete Workflow**

### **Step 1: CLI Execution**
- The user runs a CLI command to request a database admin report.  
- CLI authenticates with AWS credentials and passes parameters to the Lambda function.  

### **Step 2: Lambda Processing**
1. **Read DB Inventory**:
   - The Lambda function retrieves the list of databases from S3 or Parameter Store.  
   - The database inventory is manually updated and maintained by **@maurice.williams**.

2. **Fetch Secrets**:
   - For each database in the inventory, the Lambda function fetches credentials from AWS Secrets Manager.  
   - Credentials include:
     - Database IDs
     - Usernames and passwords required for database access.

3. **Database Connection**:
   - Using the fetched credentials, the Lambda function establishes connections to the databases.  
   - Queries are executed to gather admin user data.

4. **Aggregate Results**:
   - The Lambda function consolidates admin user data from all databases and accounts.

### **Step 3: Report Generation**
- Lambda generates a consolidated CSV report with timestamps and metadata.  
- Stores the report in a central S3 bucket.  
- CLI displays the report generation status and provides the S3 download location.  

---

## 🛠️ **Technical Requirements**

### **Database Inventory and Credential Management**
- **Database Inventory**:
  - Maintained manually by **@maurice.williams**.
  - Includes database IDs, hostnames, ports, and types (e.g., MSSQL, MySQL).
  - Stored in S3 or Parameter Store for Lambda access.

- **Secrets Manager**:
  - Securely stores database credentials.
  - Credentials include usernames, passwords, and roles.
  - Lambda fetches credentials dynamically during execution.

---

### **CLI Tool**
- **Language**: TypeScript/JavaScript (Node.js).  
- **Framework**: Commander.js or equivalent for argument parsing.  
- **Authentication**: AWS SDK v3 for secure access.  
- **Options**:  
  - `--accounts`: Specify target accounts.  
  - `--regions`: Filter by AWS regions.  
  - `--output-format`: Choose CSV or JSON.  
  - `--verbose`: Enable detailed logging.  
- **Output**: Displays status and S3 location of the report.  

---

### **Orchestrator Lambda**
- **Language**: TypeScript (Node.js 18.x runtime).  
- **AWS SDK**: v3 for STS, S3, Secrets Manager integration.  
- **Database Drivers**: `mssql`, `mysql2`.  
- **Functionality**:  
  - Reads configuration from S3 or Parameter Store.  
  - Assumes cross-account IAM roles securely.  
  - Queries databases for admin user data.  
  - Generates and uploads CSV reports to S3.  

---

## 🔒 **Security Considerations**

- **IAM Roles**: Least privilege access for cross-account operations.  
- **Secrets Manager**: Secure storage for database credentials.  
- **Encryption**: Ensure data is encrypted in transit (TLS) and at rest (S3 bucket encryption).  
- **Compliance**: Maintain SOC2 audit trails and data retention policies.  

---

## 🔄 **Maintenance and Operations**

- **Database Inventory Updates**:
  - **@maurice.williams** manually reviews and updates the database inventory periodically.
  - Ensure all new databases are added to the inventory.

- **Credential Updates**:
  - Credentials stored in Secrets Manager must be updated whenever database passwords or roles change.
  - Manual updates performed by **@maurice.williams**.

---

### **Actionable Enhancements**
1. **Automation Opportunities**:
   - Explore automating database inventory updates using APIs or scripts in future iterations.
   - Implement automated credential rotation using Secrets Manager.

2. **Documentation**:
   - Provide clear instructions for manually updating the database inventory and credentials in Secrets Manager.

---

This revised version integrates the manual processes managed by **@maurice.williams** while ensuring the workflow remains secure, efficient, and auditable. Let me know if further refinements are needed!
