# Secrets Management

## Purpose

This document defines how secrets are stored, accessed, rotated, and used across the platform.

Secrets include any sensitive information required by systems to function securely.

Examples:

* Database credentials
* API keys
* Cloud access tokens
* Encryption keys
* Service account credentials

The goal is to ensure secrets are:

* Secure
* Centralized
* Access-controlled
* Auditable
* Never exposed in code or artifacts

---

# Objectives

The secrets management strategy aims to provide:

* Secure storage of sensitive data
* Controlled access based on identity
* Runtime injection of secrets
* Auditability of secret usage
* Rotation and lifecycle management
* Elimination of hardcoded credentials

---

# Core Principle

```text id="m7r2p8"
❌ Secrets must never be stored in:
   - Source code
   - Git repositories
   - Docker images
   - Logs

✔ Secrets must only exist in:
   - Secret management systems
   - Runtime environment injection
```

---

# Types of Secrets

## Infrastructure Secrets

Used by Terraform and cloud resources:

```text id="k4m8r3"
AWS Access Keys
Cloud Provider Credentials
Backend State Encryption Keys
```

---

## Application Secrets

Used by services at runtime:

```text id="v8m3r5"
Database Passwords
Redis Credentials
External API Keys
JWT Signing Secrets
```

---

## ML Secrets

Used in ML pipelines:

```text id="p2m7r9"
S3 Access Keys
MLflow Tracking Tokens
Experiment Access Credentials
```

---

# Secret Storage Strategy

Secrets are stored in centralized secret management systems.

Preferred options:

```text id="n5r8m2"
AWS Secrets Manager

AWS Parameter Store (Secure Strings)
```

---

# Secret Access Model

Secrets are accessed at runtime through identity-based permissions.

```text id="w7m4p3"
Application
   │
   ▼

IAM Role / Service Identity
   │
   ▼

Secrets Manager
   │
   ▼

Injected Secret
```

No hardcoded credentials are used.

---

# Access Control

Secrets access is controlled using IAM policies.

Principles:

* Least privilege
* Role-based access
* Environment isolation

Example:

```text id="y4m8r1"
Dev service → dev secrets only
Prod service → prod secrets only
```

---

# Secrets in CI/CD

GitHub Actions interacts with secrets securely.

```text id="q8m3r4"
GitHub Actions
      │
      ▼

Encrypted GitHub Secrets
      │
      ▼

Runtime Injection
```

CI/CD pipelines never expose raw secrets in logs.

---

# Secrets in Terraform

Terraform does NOT store secrets in state files.

Best practices:

```text id="x2m7r8"
Use data sources

Reference secret manager

Avoid inline sensitive values
```

State files should be encrypted and secured.

---

# Secrets in Kubernetes

Secrets are injected into pods at runtime.

Methods:

```text id="f4m8r2"
Kubernetes Secrets

External Secrets Operator

CSI Secret Store Driver
```

Example:

```text id="k7r3m8"
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
```

---

# Secrets in Applications

Applications must never hardcode secrets.

Bad:

```text id="t5m8r1"
db_password = "hardcoded-password"
```

Good:

```text id="p3m7r9"
db_password = os.environ["DB_PASSWORD"]
```

---

# Secrets in ML Pipelines

ML pipelines require secure access to:

* Data storage
* Model registry
* Experiment tracking systems

Example:

```text id="r8m2p5"
MLflow token injected at runtime
S3 credentials via IAM role
```

---

# Secret Rotation Strategy

Secrets should be rotated periodically.

Rotation triggers:

```text id="u6m4r8"
Time-based rotation

Security incident

Credential compromise

Policy enforcement
```

---

# Rotation Workflow

```text id="n4m9r2"
Generate new secret
        │
        ▼

Update secret manager
        │
        ▼

Deploy new version
        │
        ▼

Invalidate old secret
```

---

# Environment Isolation

Secrets are separated by environment:

```text id="a7m3r5"
dev
staging
prod
```

Each environment has its own secret namespace.

---

# Audit and Logging

All secret access must be logged:

Tracked events:

```text id="j8m2r4"
Who accessed secret

When it was accessed

Which service used it
```

Logs should NOT contain secret values.

---

# Secret Injection Patterns

## Environment Variables (Preferred)

```text id="g4m7r8"
DB_PASSWORD injected at runtime
```

---

## Mounted Files (Advanced)

```text id="z5m2r7"
/secrets/db-password
```

---

## SDK-Based Access

Applications can fetch secrets directly:

```text id="k2m7p9"
Secrets Manager SDK call
```

---

# Anti-Patterns

## Hardcoded Secrets

```text id="r6m3p8"
❌ Passwords in code
```

---

## GitHub Secrets in Code

```text id="w4p7m2"
❌ secrets printed or committed
```

---

## Logging Secrets

```text id="n9r4m7"
❌ Logging API keys
```

---

## Shared Credentials

```text id="p3m7n8"
❌ One key for all environments
```

---

## Long-Lived Keys

```text id="f6r2m9"
❌ Never rotated credentials
```

---

# Security Best Practices

* Use IAM roles instead of keys where possible
* Prefer short-lived credentials
* Encrypt secrets at rest and in transit
* Rotate secrets regularly
* Restrict access to minimal services
* Monitor secret usage patterns

---

# Example Startup Architecture

```text id="v7r3m8"
Application
   │
   ▼

IAM Role
   │
   ▼

Secrets Manager
   │
   ▼

Runtime Injection
   │
   ▼

Service Execution
```

---

# Incident Handling

If a secret is compromised:

```text id="k5m2r7"
1. Revoke secret immediately
2. Rotate credentials
3. Redeploy affected services
4. Audit access logs
```

---

# Future Evolution

As the platform grows, secrets management may evolve into:

* Zero-trust secret access
* Automatic rotation systems
* Ephemeral credentials
* Identity-based authentication everywhere
* Secretless architectures

---

# Core Principle

```text id="n2m9r4"
Secrets should never be static,
never exposed,
and always controlled at runtime.
```

---

# Related Documents

* Infrastructure Delivery
* Application Delivery
* ML Delivery
* CI/CD Overview
* Deployment
* Security Governance

Together, these define how sensitive information is securely handled across the entire platform lifecycle.
