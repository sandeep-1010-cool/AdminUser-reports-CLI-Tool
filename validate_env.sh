#!/bin/bash

echo "��� Verifying development environment..."

# Function to check version numbers
check_version() {
    tool=$1
    version=$2
    min_version=$3
    # If the sorted order puts min_version first, version is greater than or equal to min_version
    if [[ "$(printf '%s\n' "$min_version" "$version" | sort -V | head -n1)" == "$min_version" ]]; then
        echo "✅ $tool version $version is OK"
    else
        echo "❌ $tool version $version is less than required $min_version"
    fi
}

# Node.js
if command -v node >/dev/null; then
    node_version=$(node -v | cut -c2-)
    check_version "Node.js" "$node_version" "18.0.0"
else
    echo "❌ Node.js not found"
fi

# npm
if command -v npm >/dev/null; then
    npm_version=$(npm -v)
    check_version "npm" "$npm_version" "8.0.0"
else
    echo "❌ npm not found"
fi

# TypeScript
if command -v tsc >/dev/null; then
    tsc_version=$(tsc -v | awk '{print $2}')
    echo "✅ TypeScript version $tsc_version is installed"
else
    echo "❌ TypeScript (tsc) not found. Run: npm install -g typescript"
fi

# Pulumi
if command -v pulumi >/dev/null; then
    pulumi_version=$(pulumi version | cut -c2-)
    echo "✅ Pulumi version $pulumi_version is installed"
else
    echo "❌ Pulumi CLI not found. Install via: brew install pulumi"
fi

# AWS CLI
if command -v aws >/dev/null; then
    aws_version=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
    echo "✅ AWS CLI version $aws_version is installed"
else
    echo "❌ AWS CLI not found. Install and run: aws configure"
fi

# Git
if command -v git >/dev/null; then
    git_version=$(git --version | awk '{print $3}')
    echo "✅ Git version $git_version is installed"
else
    echo "❌ Git not found"
fi

# Azure DevOps CLI (via Azure CLI)
if command -v az >/dev/null; then
    if az extension show --name azure-devops >/dev/null 2>&1; then
        az_devops_version=$(az extension show --name azure-devops --query version -o tsv)
        echo "✅ Azure DevOps CLI extension version $az_devops_version is installed"
    else
        echo "❌ Azure DevOps CLI extension not found. Run: az extension add --name azure-devops"
    fi
else
    echo "❌ Azure CLI not found. Install from: https://aka.ms/installazurecli"
fi

# Python

