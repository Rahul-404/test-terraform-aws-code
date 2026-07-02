# API Contract

## Purpose

This document defines the public API contract exposed by the Deployment Capability.

The API enables platform users, CI/CD pipelines, automation systems, and platform services to:

* Deploy approved models
* Retrieve deployment status
* List deployments
* Rollback deployments
* View deployment history

The API contract serves as the formal interface between Deployment and other platform capabilities.

---

# API Design Principles

The Deployment API follows several principles:

```text
Resource-Oriented

Versioned

Idempotent

Auditable

Environment Aware

Model Version Explicit
```

---

# Base URL

## Internal Platform API

```http
/api/v1/deployments
```

---

# Authentication

Startup V1 uses:

```text
GitHub Actions OIDC

IAM Roles

Platform Service Accounts
```

---

# Authorization

Deployment actions require:

```text
Deployment Permissions

Environment Access

Approved Model Access
```

---

# Resource Model

A deployment represents a model version running in an environment.

Example:

```json
{
  "deployment_id": "dep-123",
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production",
  "status": "running"
}
```

---

# Deployment Lifecycle

```text
Requested
     │
     ▼

Validating
     │
     ▼

Deploying
     │
     ▼

Verifying
     │
     ▼

Running
```

Failure path:

```text
Failed
     │
     ▼

RollingBack
     │
     ▼

RolledBack
```

---

# Create Deployment

## Endpoint

```http
POST /api/v1/deployments
```

---

## Purpose

Deploy an approved model version into an environment.

---

## Request

```json
{
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production",
  "replicas": 2
}
```

---

## Request Fields

| Field         | Type    | Required | Description           |
| ------------- | ------- | -------- | --------------------- |
| model_name    | string  | Yes      | Registered model name |
| model_version | integer | Yes      | Registry version      |
| environment   | string  | Yes      | Deployment target     |
| replicas      | integer | No       | Desired replicas      |

---

## Validation Rules

The API validates:

```text
Model Exists

Model Approved

Version Exists

Environment Exists

Permissions Valid
```

---

## Response

```json
{
  "deployment_id": "dep-123",
  "status": "requested",
  "created_at": "2026-06-01T10:00:00Z"
}
```

---

## Status Codes

| Code | Meaning             |
| ---- | ------------------- |
| 201  | Deployment Created  |
| 400  | Invalid Request     |
| 403  | Permission Denied   |
| 404  | Model Not Found     |
| 409  | Deployment Conflict |

---

# Get Deployment

## Endpoint

```http
GET /api/v1/deployments/{deployment_id}
```

---

## Purpose

Retrieve deployment details.

---

## Example

```http
GET /api/v1/deployments/dep-123
```

---

## Response

```json
{
  "deployment_id": "dep-123",
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production",
  "status": "running",
  "created_at": "2026-06-01T10:00:00Z"
}
```

---

## Status Codes

| Code | Meaning              |
| ---- | -------------------- |
| 200  | Success              |
| 404  | Deployment Not Found |

---

# List Deployments

## Endpoint

```http
GET /api/v1/deployments
```

---

## Purpose

Return deployment history.

---

## Query Parameters

| Parameter   | Description           |
| ----------- | --------------------- |
| model_name  | Filter by model       |
| environment | Filter by environment |
| status      | Filter by state       |

---

## Example

```http
GET /api/v1/deployments?environment=production
```

---

## Response

```json
{
  "items": [
    {
      "deployment_id": "dep-123",
      "model_name": "heart-stroke-prediction",
      "model_version": 12,
      "status": "running"
    }
  ]
}
```

---

# Get Current Deployment

## Endpoint

```http
GET /api/v1/deployments/current
```

---

## Purpose

Return active deployment for a model.

---

## Example

```http
GET /api/v1/deployments/current?model_name=heart-stroke-prediction
```

---

## Response

```json
{
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production",
  "status": "running"
}
```

---

# Rollback Deployment

## Endpoint

```http
POST /api/v1/deployments/{deployment_id}/rollback
```

---

## Purpose

Restore previous stable version.

---

## Example

```http
POST /api/v1/deployments/dep-123/rollback
```

---

## Response

```json
{
  "deployment_id": "dep-123",
  "status": "rolling_back"
}
```

---

## Rollback Rules

Rollback requires:

```text
Stable Previous Version Exists

Deployment Is Active

User Has Rollback Permission
```

---

## Status Codes

| Code | Meaning               |
| ---- | --------------------- |
| 202  | Rollback Started      |
| 404  | Deployment Not Found  |
| 409  | Rollback Not Possible |

---

# Deployment Events

Deployment lifecycle generates events.

---

## Example Event

```json
{
  "event_type": "deployment.started",
  "deployment_id": "dep-123",
  "timestamp": "2026-06-01T10:00:00Z"
}
```

---

## Event Types

```text
deployment.created

deployment.validated

deployment.started

deployment.succeeded

deployment.failed

deployment.rollback_started

deployment.rollback_completed
```

---

# Deployment Status Model

## Status Values

| Status       | Description                       |
| ------------ | --------------------------------- |
| requested    | Deployment created                |
| validating   | Validation in progress            |
| deploying    | Infrastructure update in progress |
| verifying    | Health checks running             |
| running      | Deployment successful             |
| failed       | Deployment failed                 |
| rolling_back | Rollback executing                |
| rolled_back  | Rollback completed                |

---

## Example

```json
{
  "status": "running"
}
```

---

# Deployment Metadata Model

Every deployment stores metadata.

---

## Example

```json
{
  "deployment_id": "dep-123",
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production",
  "deployed_by": "github-actions",
  "status": "running",
  "created_at": "2026-06-01T10:00:00Z"
}
```

---

# Error Model

All API errors follow a standard structure.

---

## Example

```json
{
  "error_code": "MODEL_NOT_APPROVED",
  "message": "Model version is not approved for deployment."
}
```

---

## Common Error Codes

| Error Code            | Description                 |
| --------------------- | --------------------------- |
| MODEL_NOT_FOUND       | Registry entry missing      |
| MODEL_NOT_APPROVED    | Governance check failed     |
| VERSION_NOT_FOUND     | Version missing             |
| DEPLOYMENT_NOT_FOUND  | Deployment missing          |
| INVALID_ENVIRONMENT   | Environment unsupported     |
| PERMISSION_DENIED     | Unauthorized action         |
| ROLLBACK_NOT_POSSIBLE | No stable version available |

---

# Idempotency

Deployment creation should support idempotent execution.

---

## Example

Repeated request:

```json
{
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production"
}
```

should not create duplicate active deployments.

---

# Audit Metadata

Every API operation generates audit records.

---

## Captured Fields

```text
User

Timestamp

Action

Model Version

Environment

Result
```

---

## Example

```json
{
  "action": "deployment.create",
  "user": "github-actions",
  "deployment_id": "dep-123"
}
```

---

# Integration Consumers

The API is expected to be used by:

```text
GitHub Actions

Platform Automation

Release Pipelines

Internal Platform Services

Operations Team
```

---

# Startup V1 Limitations

Startup V1 intentionally excludes:

```text
Canary Releases

Blue-Green Deployments

Traffic Splitting

Multi-Region Deployments

Multi-Cloud Deployments
```

These are added in future platform versions.

---

# Future API Evolution

Future releases may introduce:

```text
Canary Deployment APIs

Blue-Green APIs

Traffic Weight Controls

Deployment Policies

Multi-Region Releases

Automated Promotion APIs
```

without breaking existing contracts.

---

# Summary

The Deployment API provides a stable interface for creating deployments, monitoring deployment progress, retrieving deployment metadata, listing deployment history, and performing rollbacks. It enforces governance policies, supports auditability, and ensures that only approved model versions are promoted into production environments.
