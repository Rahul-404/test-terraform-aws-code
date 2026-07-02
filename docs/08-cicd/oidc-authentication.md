# OIDC Authentication

## Purpose

This document defines how the platform uses OpenID Connect (OIDC) to securely authenticate CI/CD systems with cloud providers without using long-lived credentials.

OIDC enables **federated identity-based access** between:

* GitHub Actions
* AWS IAM
* Kubernetes clusters
* ML and data services

---

# Objectives

The OIDC authentication strategy aims to provide:

* Elimination of static credentials
* Secure CI/CD authentication
* Short-lived token-based access
* Least-privilege enforcement
* Auditability of access
* Scalable multi-environment authentication

---

# Why OIDC?

Traditional CI/CD systems rely on:

```text id="m7r2p8"
AWS Access Keys
Secret Access Tokens
Long-lived credentials stored in CI/CD
```

Problems:

* Risk of leakage
* Manual rotation
* Hard to manage at scale
* High security exposure

---

## OIDC Solution

OIDC replaces static credentials with:

```text id="k4m8r3"
Short-lived identity tokens
Federated authentication
Role assumption at runtime
```

---

# Core Concept

OIDC allows an external identity provider (GitHub Actions) to:

> Prove who it is → and receive temporary credentials from AWS

---

## Authentication Flow

```text id="v8m3r5"
GitHub Actions
      │
      ▼

OIDC Token (JWT)
      │
      ▼

AWS IAM Identity Provider
      │
      ▼

AssumeRoleWithWebIdentity
      │
      ▼

Temporary AWS Credentials
```

No static secrets are stored.

---

# Key Components

## 1. Identity Provider (IdP)

In this system:

```text id="p2m7r9"
GitHub Actions OIDC Provider
```

It issues signed identity tokens.

---

## 2. AWS IAM Role

A role is configured to trust GitHub:

```text id="n5r8m2"
Trust Policy
```

This defines who can assume the role.

---

## 3. Trust Relationship

Example:

```json id="w7m4p3"
{
  "Effect": "Allow",
  "Principal": {
    "Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
  },
  "Action": "sts:AssumeRoleWithWebIdentity"
}
```

---

## 4. OIDC Token

GitHub generates a signed JWT:

Contains:

```text id="y4m8r1"
Repository identity

Branch / environment

Workflow identity

Audience (AWS)
```

---

# GitHub Actions Integration

OIDC is used directly inside GitHub Actions workflows.

Example flow:

```text id="q8m3r4"
GitHub Workflow
      │
      ▼

Request OIDC Token
      │
      ▼

Assume AWS Role
      │
      ▼

Run Terraform / Deploy
```

---

## Example Workflow

```yaml id="x2m7r8"
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    steps:
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials
        with:
          role-to-assume: arn:aws:iam::<account-id>:role/github-oidc-role
          aws-region: ap-south-1
```

---

# AWS IAM Role Configuration

## Trust Policy Example

```json id="f4m8r2"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:org/repo:*"
        }
      }
    }
  ]
}
```

---

# Security Benefits

## 1. No Long-Lived Secrets

```text id="k7r3m8"
❌ Access keys stored in GitHub

✔ Temporary credentials only
```

---

## 2. Least Privilege Access

Each workflow assumes a **specific role**.

---

## 3. Fine-Grained Control

Access can be restricted by:

```text id="t5m8r1"
Repository

Branch

Environment

Workflow
```

---

## 4. Automatic Expiry

Tokens expire automatically after a short duration.

---

# Multi-Environment Strategy

OIDC roles are environment-specific.

```text id="p3m7r9"
dev-role
staging-role
prod-role
```

Example mapping:

```text id="r8m2p5"
dev → full access (limited scope)
staging → restricted deploy access
prod → strict approval-based access
```

---

# CI/CD Use Cases

## Infrastructure Deployment

```text id="u6m4r8"
GitHub Actions
      │
      ▼

AssumeRole (Terraform Role)
      │
      ▼

Apply Infrastructure
```

---

## Application Deployment

```text id="n4m9r2"
GitHub Actions
      │
      ▼

Assume Role
      │
      ▼

Push to ECR + Deploy to EKS
```

---

## ML Pipeline Deployment

```text id="a7m3r5"
GitHub Actions
      │
      ▼

Assume Role
      │
      ▼

Upload Model → S3
Deploy Model Service
```

---

# Token Security Model

OIDC tokens are:

```text id="j8m2r4"
Short-lived (minutes)

Signed by provider

Audience-restricted

Scope-limited
```

---

# Access Flow Summary

```text id="g4m7r8"
GitHub Identity
      │
      ▼

OIDC Token Issued
      │
      ▼

AWS Validates Token
      │
      ▼

Role Assumed
      │
      ▼

Temporary Credentials Issued
```

---

# Monitoring & Auditing

All OIDC role assumptions are logged via:

```text id="z5m2r7"
AWS CloudTrail
```

Track:

* Who assumed role
* When
* From which repository
* Which workflow

---

# Anti-Patterns

## Static AWS Keys in CI/CD

```text id="k2m7p9"
❌ AWS_ACCESS_KEY_ID stored in GitHub secrets
```

---

## Over-Privileged Roles

```text id="r6m3p8"
❌ One role for all pipelines
```

---

## Missing Conditions

```text id="w4p7m2"
❌ No repo/branch restriction
```

---

## Long-Lived Credentials

```text id="n9r4m7"
❌ IAM user keys
```

---

# Best Practices

* Use OIDC everywhere instead of static secrets
* Separate roles per environment
* Restrict access by repository and branch
* Use least privilege policies
* Monitor role usage in CloudTrail
* Rotate trust policies when needed

---

# Example Startup Architecture

```text id="p3m7n8"
GitHub Actions
      │
      ▼

OIDC Token
      │
      ▼

AWS IAM Role
      │
      ▼

Temporary Credentials
      │
      ▼

Deploy Infrastructure / Apps / ML
```

---

# Future Evolution

OIDC-based authentication may evolve into:

* Zero-trust CI/CD systems
* Fine-grained per-workflow identity
* Multi-cloud federation
* Automated permission scaling
* Policy-as-code enforcement for roles

---

# Core Principle

```text id="f6r2m9"
CI/CD systems should never store credentials.
They should prove identity and receive temporary access.
```

---

# Related Documents

* Secrets Management
* CI/CD Overview
* Infrastructure Delivery
* Application Delivery
* ML Delivery
* Deployment

Together, these define how the platform securely authenticates all automation workflows without relying on static credentials.
