# Create CSV reports for db admin access compliance

## 📋 Description

Design and implement CSV report format that provides comprehensive database administrator access information required for SOC2 audit verification.

## 🎯 Acceptance Criteria

Reports are formatted in a standard CSV layout that auditors can easily open in Excel and understand immediately so that audit reviews go faster and require less back-and-forth questions. All the required compliance information is clearly labeled and organized so that auditors can quickly verify our database security controls.

- **CSV report format includes columns:** Account ID, Region, Database Name, Database Type, Username, Role Name, Permission Level, Last Login Date, User Status, Report Timestamp
- **Reports organized by AWS account with clear section headers**
- **Failed database connections clearly documented with error reasons**
- **Reports include database names where each user is an admin**
- **Data validation ensures no sensitive business data included in reports**