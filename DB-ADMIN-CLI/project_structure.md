# DB Admin Access Reporter - TypeScript/Node.js Project Structure

## 📁 Complete Project Structure

```
db-admin-access-reporter/
├── .pulumi/                       # Pulumi local state and configuration
│   ├── dev/                       # Development environment state
│   ├── staging/                   # Staging environment state
│   └── prod/                      # Production environment state
├── config/                        # Configuration files for different environments
│   ├── dev.json                   # Development environment config
│   ├── staging.json               # Staging environment config
│   └── prod.json                  # Production environment config
├── docs/                          # Documentation
│   ├── project_guidelines.md      # Project requirements and guidelines
│   └── architecture.md            # Architecture diagrams and descriptions
├── infrastructure/                # Infrastructure as Code (Pulumi TypeScript)
│   ├── src/
│   │   ├── index.ts              # Main Pulumi program
│   │   ├── components/
│   │   │   ├── cloudwatch.ts     # CloudWatch Log Groups
│   │   │   ├── iam.ts           # IAM Roles and Policies
│   │   │   ├── networking.ts    # VPC Endpoints
│   │   │   └── security.ts      # KMS Keys
│   │   └── utils/
│   │       ├── config.ts        # Configuration utilities
│   │       └── tags.ts          # Tag management
│   ├── Pulumi.yaml
│   ├── package.json
│   └── tsconfig.json
├── scripts/                       # Utility scripts for setup and deployment
│   ├── setup-cli.sh              # Script to set up CLI environment
│   ├── deploy-lambdas.sh         # Script to package and deploy Lambdas
│   └── update-inventory.js       # Script to update database inventory
├── src/                           # Source code
│   ├── cli/                       # Command Line Interface tool
│   │   ├── src/
│   │   │   ├── index.ts          # CLI entry point
│   │   │   ├── commands.ts       # CLI command definitions
│   │   │   ├── config.ts         # CLI configuration
│   │   │   └── types.ts          # CLI type definitions
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── lambdas/                   # AWS Lambda functions
│   │   ├── orchestrator/          # Master Orchestrator Lambda
│   │   │   ├── src/
│   │   │   │   ├── index.ts      # Lambda handler
│   │   │   │   ├── orchestrator.ts # Core orchestrator logic
│   │   │   │   ├── types.ts      # TypeScript interfaces
│   │   │   │   └── utils.ts      # Orchestrator utilities
│   │   │   ├── package.json
│   │   │   └── tsconfig.json
│   │   └── worker/                # Worker Lambdas for different DB types
│   │       ├── mssql/             # MSSQL Worker Lambda
│   │       │   ├── src/
│   │       │   │   ├── index.ts  # MSSQL Lambda handler
│   │       │   │   ├── mssql-client.ts # MSSQL connection logic
│   │       │   │   ├── queries.ts # MSSQL admin user queries
│   │       │   │   └── types.ts  # MSSQL types
│   │       │   ├── package.json
│   │       │   └── tsconfig.json
│   │       └── mysql/             # MySQL Worker Lambda
│   │           ├── src/
│   │           │   ├── index.ts  # MySQL Lambda handler
│   │           │   ├── mysql-client.ts # MySQL connection logic
│   │           │   ├── queries.ts # MySQL admin user queries
│   │           │   └── types.ts  # MySQL types
│   │           ├── package.json
│   │           └── tsconfig.json
│   └── shared/                    # Shared utilities and libraries
│       ├── src/
│       │   ├── database.ts        # Database connection utilities
│       │   ├── aws-utils.ts       # AWS service utilities
│       │   ├── report-generator.ts # Report generation logic
│       │   ├── logger.ts          # Structured logging utilities
│       │   ├── config.ts          # Shared configuration
│       │   └── types.ts           # Shared type definitions
│       ├── package.json
│       └── tsconfig.json
├── tests/                         # Test suites
│   ├── unit/                      # Unit tests
│   │   ├── cli.test.ts           # CLI unit tests
│   │   ├── orchestrator.test.ts  # Orchestrator unit tests
│   │   ├── worker.test.ts        # Worker unit tests
│   │   └── shared.test.ts        # Shared utilities tests
│   ├── integration/               # Integration tests
│   │   ├── workflow.test.ts      # End-to-end workflow tests
│   │   └── cross-account.test.ts # Cross-account access tests
│   └── fixtures/                  # Test data and fixtures
│       ├── sample-db-data.json   # Sample database responses
│       └── mock-aws-responses.json # Mock AWS service responses
├── .gitignore                     # Git ignore file
├── .env.template                 # Environment variable template
├── README.md                     # Project overview and setup instructions
├── package.json                  # Root project metadata and scripts
├── tsconfig.json                 # Root TypeScript configuration
├── jest.config.js                # Jest testing configuration
├── .eslintrc.js                  # ESLint configuration
├── .prettierrc                   # Prettier configuration
└── .editorconfig                 # Editor configuration
```

---

## 📋 Key Directory Explanations

### **`.pulumi/`**
Contains Pulumi local state and configuration for different environments:
- **Development** (`dev/`) - Local development environment state
- **Staging** (`staging/`) - Staging environment state for testing
- **Production** (`prod/`) - Production environment state
- **Local deployment** using `pulumi up` commands
- **State management** for infrastructure tracking

### **`config/`**
Environment-specific configurations:
- **JSON configuration files** for different environments
- **Database inventory** and connection settings
- **AWS account mappings** and region configurations

### **`docs/`**
Project documentation:
- **`project_guidelines.md`** - Comprehensive requirements and guidelines
- **`architecture.md`** - System architecture diagrams and descriptions
- **API documentation** and deployment guides

### **`infrastructure/`**
Pulumi TypeScript Infrastructure as Code:
- **Multi-account deployment** across 8 accounts and 2 regions
- **CloudWatch Log Groups** with standardized naming
- **IAM Roles and Policies** for cross-account access
- **VPC Endpoints** and KMS encryption
- **Parameter Store** for centralized configuration

### **`scripts/`**
Utility scripts for automation:
- **`setup-cli.sh`** - CLI environment setup and configuration
- **`deploy-lambdas.sh`** - Lambda packaging and deployment
- **`update-inventory.js`** - Database inventory updates

### **`src/`**
Core TypeScript source code:

#### **`cli/`** - Command Line Interface
- **Commander.js** framework for CLI commands
- **AWS SDK v3** for authentication and Lambda invocation
- **Configuration management** for different environments
- **Error handling** and user feedback

#### **`lambdas/`** - AWS Lambda Functions

**`orchestrator/`** - Master Orchestrator Lambda:
- **Cross-account coordination** and worker invocation
- **Result aggregation** and CSV report generation
- **Error handling** with retry logic and partial failure management
- **S3 storage** with organized naming conventions

**`worker/`** - Database Worker Lambdas:
- **`mssql/`** - SQL Server database connections and queries
- **`mysql/`** - MySQL database connections and queries
- **Connection pooling** and credential management
- **Data collection** and S3 upload functionality

#### **`shared/`** - Common Utilities
- **Database connection** utilities for both MSSQL and MySQL
- **AWS service** utilities for S3, Secrets Manager, etc.
- **Report generation** logic for CSV formatting
- **Structured logging** with correlation IDs
- **Shared types** and interfaces

### **`tests/`**
Comprehensive testing structure:

#### **`unit/`** - Unit Tests
- **Jest framework** with TypeScript support
- **Mock AWS services** for isolated testing
- **Database connection** mocking
- **Error scenario** testing

#### **`integration/`** - Integration Tests
- **End-to-end workflow** testing
- **Cross-account access** validation
- **Real database** connection testing
- **Report generation** validation

#### **`fixtures/`** - Test Data
- **Sample database responses** for testing
- **Mock AWS service responses** for unit tests
- **Configuration files** for different test scenarios

---

## 🛠️ Technology Stack Alignment

### **TypeScript/Node.js Stack**
```json
{
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^18.0.0",
    "jest": "^29.0.0",
    "@types/jest": "^29.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0"
  }
}
```

### **AWS SDK v3 Dependencies**
```json
{
  "dependencies": {
    "@aws-sdk/client-lambda": "^3.0.0",
    "@aws-sdk/client-s3": "^3.0.0",
    "@aws-sdk/client-sts": "^3.0.0",
    "@aws-sdk/client-secrets-manager": "^3.0.0",
    "@aws-sdk/client-ssm": "^3.0.0"
  }
}
```

### **Database Dependencies**
```json
{
  "dependencies": {
    "mssql": "^10.0.0",
    "mysql2": "^3.0.0",
    "@types/mssql": "^9.0.0"
  }
}
```

---

## 🔧 Configuration Files

### **Root `package.json`**
```json
{
  "name": "db-admin-access-reporter",
  "version": "1.0.0",
  "description": "CLI tool for generating database administrator access reports",
  "scripts": {
    "build": "npm run build:cli && npm run build:lambdas",
    "build:cli": "cd src/cli && npm run build",
    "build:lambdas": "cd src/lambdas/orchestrator && npm run build && cd ../worker/mssql && npm run build && cd ../mysql && npm run build",
    "test": "jest",
    "test:unit": "jest tests/unit",
    "test:integration": "jest tests/integration",
    "lint": "eslint src/**/*.ts",
    "format": "prettier --write src/**/*.ts",
    "deploy:infrastructure:dev": "cd infrastructure && pulumi stack select dev && pulumi up",
    "deploy:infrastructure:staging": "cd infrastructure && pulumi stack select staging && pulumi up",
    "deploy:infrastructure:prod": "cd infrastructure && pulumi stack select prod && pulumi up",
    "deploy:lambdas": "./scripts/deploy-lambdas.sh"
  },
  "workspaces": [
    "src/cli",
    "src/lambdas/orchestrator",
    "src/lambdas/worker/mssql",
    "src/lambdas/worker/mysql",
    "src/shared"
  ]
}
```

### **Root `tsconfig.json`**
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": "./src",
    "paths": {
      "@shared/*": ["../shared/src/*"],
      "@types/*": ["../shared/src/types/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

### **Jest Configuration**
```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
};
```

---

## 🚀 Development Workflow

### **1. Initial Setup**
```bash
# Clone repository
git clone <repository-url>
cd db-admin-access-reporter

# Install dependencies
npm install

# Setup environment
cp .env.template .env
# Edit .env with your AWS credentials and configuration

# Build all components
npm run build
```

### **2. Development Commands**
```bash
# Run tests
npm test                    # All tests
npm run test:unit          # Unit tests only
npm run test:integration   # Integration tests only

# Code quality
npm run lint               # ESLint check
npm run format             # Prettier formatting

# Build components
npm run build:cli         # Build CLI tool
npm run build:lambdas     # Build all Lambda functions
```

### **3. Deployment Commands**
```bash
# Deploy infrastructure locally
npm run deploy:infrastructure:dev    # Development environment
npm run deploy:infrastructure:staging # Staging environment
npm run deploy:infrastructure:prod   # Production environment

# Deploy Lambda functions
npm run deploy:lambdas

# Update database inventory
node scripts/update-inventory.js
```

---

## 📊 Benefits of This Structure

### **1. Modularity & Maintainability**
- **Separate concerns** for CLI, Lambdas, infrastructure, and tests
- **Independent package.json** files for each component
- **Shared utilities** to reduce code duplication
- **Type safety** with TypeScript throughout

### **2. Local Deployment Compatibility**
- **Pulumi local deployment** for infrastructure management
- **Environment-specific stacks** (dev/staging/prod)
- **Local state management** for infrastructure tracking
- **Workspace management** with npm workspaces
- **Automated testing** and quality checks

### **3. Development Experience**
- **Hot reloading** for CLI development
- **TypeScript IntelliSense** across all components
- **Consistent code formatting** with Prettier
- **Linting** with ESLint for code quality

### **4. Testing & Quality**
- **Comprehensive test coverage** with Jest
- **Unit and integration tests** for all components
- **Mock AWS services** for isolated testing
- **Code coverage thresholds** to maintain quality

### **5. Production Readiness**
- **Multi-environment** support (dev/staging/prod)
- **Local Pulumi deployment** with environment-specific stacks
- **Cross-account deployment** capabilities
- **Comprehensive logging** and monitoring
- **Security best practices** with IAM and encryption

---

This TypeScript/Node.js structure provides a solid foundation for building the DB Admin Access Reporter CLI tool that meets all the requirements specified in the project guidelines while maintaining excellent developer experience and production readiness. 