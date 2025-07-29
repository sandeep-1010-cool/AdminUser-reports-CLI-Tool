--

### Epic Overview
- **Goal:** Generate on-demand database administrator access reports via a CLI tool that triggers cross-account data collection and CSV report generation.

---

### Business Value
- Provides system-generated lists of database administrative users.
- Eliminates manual screenshot collection for SOC2 audits.
- Ensures timestamped, auditable reports of database administrator access.
- Simple CLI interface enables quick report generation for compliance reviews.

---

### Reference
- GRC Control: [StrikeGraph Control Detail](https://grc.strikegraph.com/organization/085c5b9b-eee0-49d0-9b07-296e3787734d/control/control_detail/176245)

---

### Complete Workflow
**Step 1: CLI Execution**
- Operations team runs CLI command to request database admin report.
- CLI authenticates with AWS and invokes master orchestrator Lambda.

**Step 2: Master Orchestrator (bb-us-product 209371858707)**
- Reads database inventory list from S3 or Parameter Store.
- Invokes all worker Lambda functions across target AWS accounts.
- Receives worker lambda outputs; handles issues like timeouts and retries.

**Step 3: Worker Lambda Data Collection**
- Worker Lambdas connect to target databases (MSSQL and MySQL) and generate the reports.
- Return outputs to orchestrator Lambda function.

**Step 4: Report Generation and Storage**
- Orchestrator Lambda aggregates all worker responses and generates CSV report with timestamps and metadata.
- Stores report in central S3 bucket with timestamp of report generation.

**Step 5: CLI Completion**
- CLI displays report generation status and S3 location.
- Report is ready for download and audit use.

---

### Scope

**In Scope:**
- CLI tool for triggering reports.
- Master orchestrator Lambda coordination.
- Worker Lambda database data collection.
- CSV report generation and S3 storage.
- Cross-account IAM permissions and security.

**Out of Scope:**
- Automated scheduling or recurring reports.
- Web interfaces or dashboards.
- Real-time monitoring or alerting.
- Database credential management or user creation.

---

### Success Criteria
- CLI successfully triggers report generation across all accounts.
- CSV reports contain complete database administrator information.
- Reports generated within 15 minutes for typical environments.
- Simple operational workflow for compliance teams.

---
