#!/bin/bash

echo "🔍 Verifying development environment..."

# Arrays to store results
successful_checks=()
warning_checks=()
error_checks=()

# Function to check version numbers
check_version() {
    tool=$1
    version=$2
    min_version=$3
    # If the sorted order puts min_version first, version is greater than or equal to min_version
    if [[ "$(printf '%s\n' "$min_version" "$version" | sort -V | head -n1)" == "$min_version" ]]; then
        successful_checks+=("✅ $tool version $version is OK")
    else
        error_checks+=("❌ $tool version $version is less than required $min_version")
    fi
}

# Node.js
if command -v node >/dev/null; then
    node_version=$(node -v | cut -c2-)
    check_version "Node.js" "$node_version" "18.0.0"
else
    error_checks+=("❌ Node.js not found")
fi

# npm
if command -v npm >/dev/null; then
    npm_version=$(npm -v)
    check_version "npm" "$npm_version" "8.0.0"
else
    error_checks+=("❌ npm not found")
fi

# TypeScript
if command -v tsc >/dev/null; then
    tsc_version=$(tsc -v | awk '{print $2}')
    successful_checks+=("✅ TypeScript version $tsc_version is installed")
else
    error_checks+=("❌ TypeScript (tsc) not found. Run: npm install -g typescript")
fi

# Pulumi
if command -v pulumi >/dev/null; then
    pulumi_version=$(pulumi version | cut -c2-)
    successful_checks+=("✅ Pulumi version $pulumi_version is installed")
else
    error_checks+=("❌ Pulumi CLI not found. Install via: brew install pulumi")
fi

# AWS CLI
if command -v aws >/dev/null; then
    aws_version=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
    successful_checks+=("✅ AWS CLI version $aws_version is installed")
else
    error_checks+=("❌ AWS CLI not found. Install and run: aws configure")
fi

# AWS SAM CLI
if command -v sam >/dev/null; then
    sam_version=$(sam --version | awk '{print $4}')
    check_version "AWS SAM CLI" "$sam_version" "1.0.0"
elif command -v sam.cmd >/dev/null; then
    sam_version=$(sam.cmd --version | awk '{print $4}')
    check_version "AWS SAM CLI" "$sam_version" "1.0.0"
else
    error_checks+=("❌ AWS SAM CLI not found. Install from: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html")
fi

# Git
if command -v git >/dev/null; then
    git_version=$(git --version | awk '{print $3}')
    successful_checks+=("✅ Git version $git_version is installed")
else
    error_checks+=("❌ Git not found")
fi

# Azure DevOps CLI (via Azure CLI)
if command -v az >/dev/null; then
    if az extension show --name azure-devops >/dev/null 2>&1; then
        az_devops_version=$(az extension show --name azure-devops --query version -o tsv)
        successful_checks+=("✅ Azure DevOps CLI extension version $az_devops_version is installed")
    else
        error_checks+=("❌ Azure DevOps CLI extension not found. Run: az extension add --name azure-devops")
    fi
else
    error_checks+=("❌ Azure CLI not found. Install from: https://aka.ms/installazurecli")
fi

# Python
if command -v python >/dev/null; then
    python_version=$(python --version 2>&1 | awk '{print $2}')
    successful_checks+=("✅ Python version $python_version is installed")
else
    error_checks+=("❌ Python not found")
fi

# Jest (Testing Framework)
if command -v jest >/dev/null; then
    jest_version=$(jest --version 2>/dev/null || echo "unknown")
    successful_checks+=("✅ Jest version $jest_version is installed")
else
    warning_checks+=("⚠️  Jest not found globally. It will be installed as a project dependency")
fi

# ESLint (Code Linting)
if command -v eslint >/dev/null; then
    eslint_version=$(eslint --version 2>/dev/null || echo "unknown")
    successful_checks+=("✅ ESLint version $eslint_version is installed")
else
    warning_checks+=("⚠️  ESLint not found globally. It will be installed as a project dependency")
fi

# Prettier (Code Formatting)
if command -v prettier >/dev/null; then
    prettier_version=$(prettier --version 2>/dev/null || echo "unknown")
    successful_checks+=("✅ Prettier version $prettier_version is installed")
else
    warning_checks+=("⚠️  Prettier not found globally. It will be installed as a project dependency")
fi

# MySQL Client (for local testing)
if command -v mysql >/dev/null; then
    mysql_version=$(mysql --version 2>&1 | awk '{print $6}' | cut -d',' -f1)
    successful_checks+=("✅ MySQL Client version $mysql_version is installed")
else
    warning_checks+=("⚠️  MySQL Client not found. Install for local database testing")
fi

# SQL Server Client (for local testing)
if command -v sqlcmd >/dev/null; then
    successful_checks+=("✅ SQL Server Client (sqlcmd) is installed")
else
    warning_checks+=("⚠️  SQL Server Client not found. Install for local database testing")
fi

# Claude CLI
if command -v claude >/dev/null; then
    claude_version=$(claude --version | awk '{print $1}')
    successful_checks+=("✅ Claude CLI version $claude_version is installed")
else
    warning_checks+=("⚠️  Claude CLI not found. Install from: https://docs.anthropic.com/claude/docs/claude-cli")
fi

# WSL (Windows Subsystem for Linux)
if command -v wsl >/dev/null 2>&1; then
    # Use tr to remove null bytes from wsl output
    wsl_output=$(wsl --status 2>/dev/null | tr -d '\000')
    if [ $? -eq 0 ] && [ -n "$wsl_output" ]; then
        wsl_distro=$(echo "$wsl_output" | grep "Default Distribution" | sed 's/Default Distribution: //')
        wsl_version=$(echo "$wsl_output" | grep "Default Version" | sed 's/Default Version: //')
        if [ -n "$wsl_distro" ] && [ -n "$wsl_version" ]; then
            successful_checks+=("✅ WSL is installed and configured: Distribution: $wsl_distro, Version: $wsl_version")
        else
            warning_checks+=("⚠️  WSL is installed but may not be properly configured")
        fi
    else
        warning_checks+=("⚠️  WSL is installed but may not be properly configured")
    fi
else
    warning_checks+=("⚠️  WSL not found. Optional for Linux development environment. Install from: Microsoft Store")
fi

echo ""
echo "✅ SUCCESSFUL CHECKS:"
echo "===================="
for check in "${successful_checks[@]}"; do
    echo "$check"
done

echo ""
echo "⚠️  WARNINGS:"
echo "============"
if [ ${#warning_checks[@]} -eq 0 ]; then
    echo "No warnings - all optional tools are ready!"
else
    for check in "${warning_checks[@]}"; do
        echo "$check"
    done
fi

echo ""
echo "❌ ERRORS:"
echo "=========="
if [ ${#error_checks[@]} -eq 0 ]; then
    echo "No errors - all required tools are installed!"
else
    for check in "${error_checks[@]}"; do
        echo "$check"
    done
fi

echo ""
echo "🎯 Development Environment Summary:"
echo "=================================="
echo "✅ Core tools: Node.js, npm, TypeScript, Git"
echo "✅ AWS tools: AWS CLI, AWS SAM CLI, Pulumi"
echo "✅ Azure tools: Azure CLI with DevOps extension"
echo "⚠️  Optional tools: Jest, ESLint, Prettier (will be installed as project dependencies)"
echo "⚠️  Database clients: MySQL, SQL Server (for local testing)"