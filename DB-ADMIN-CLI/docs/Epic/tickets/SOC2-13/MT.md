# Create Pulumi infrastructure for centralized logging

## 📋 Description

Create Pulumi TypeScript infrastructure to deploy CloudWatch Log Groups, IAM roles, and cross-account permissions for centralized logging across 8 AWS accounts and 2 regions.

## 🎯 Acceptance Criteria

All logging infrastructure is deployed using code templates so that every account gets exactly the same setup and nothing is missed or configured differently by accident. When we need to make changes, we update the code once and deploy everywhere so that all accounts stay consistent and secure.

- **Pulumi TypeScript project structure created for multi-account logging infrastructure**
- **CloudWatch Log Groups created with standardized naming:** /aws/security-ops/{account}/{region}/{service}/{component}
- **Tiered retention policies implemented:** 90 days for security/audit logs, 7 days for operational logs
- **IAM roles created for cross-account log shipping with least-privilege permissions**
- **IAM policies with explicit deny for log deletion on security-critical log groups**
- **Cross-account assume role configuration for secure log shipping**
- **VPC endpoints for CloudWatch Logs created to avoid egress charges**
- **Parameter Store configuration for centralized logging settings**
- **KMS keys for log encryption in transit and at rest**
- **Cost allocation tags applied to all logging resources**
- **Infrastructure deployable across all 8 accounts and 2 regions**
- **Rollback and disaster recovery procedures documented**