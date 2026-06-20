# Experiment Tracking Capability API Contract

## Purpose

This document defines the API contract exposed by the Experiment Tracking Capability.

The API enables platform components to:

* Create experiments
* Create runs
* Log parameters
* Log metrics
* Register artifacts
* Query experiment metadata
* Retrieve lineage information
* Search experiment history

This capability acts as the system of record for experimentation metadata.

---

# API Design Principles

## Metadata-Only Operations

The API manages metadata.

It does not:

* Execute training
* Store artifact files
* Deploy models

---

## Idempotent Operations

Repeated requests should not create inconsistent state.

---

## Immutable Experiment History

Completed runs cannot be modified.

---

## Capability Isolation

Consumers interact through APIs only.

Direct database access is prohibited.

---

# API Consumers

| Consumer            | Usage                          |
| ------------------- | ------------------------------ |
| Training Capability | Create runs, log metrics       |
| Model Registry      | Read experiment metadata       |
| Governance          | Read lineage and audit data    |
| Monitoring          | Read operational metrics       |
| Platform UI         | Search and inspect experiments |

---

# Base Endpoint

```text
/api/v1/experiments
```

---

# Authentication

All APIs require authenticated access.

Example:

```http
Authorization: Bearer <token>
```

---

# Experiment APIs

---

# Create Experiment

## Endpoint

```http
POST /api/v1/experiments
```

---

## Request

```json
{
  "name": "heart-stroke-prediction",
  "description": "Heart stroke prediction project",
  "owner": "ml-team"
}
```

---

## Response

```json
{
  "experiment_id": "exp-001",
  "status": "created"
}
```

---

## Status Codes

| Code | Meaning                   |
| ---- | ------------------------- |
| 201  | Created                   |
| 400  | Invalid request           |
| 409  | Experiment already exists |

---

# Get Experiment

## Endpoint

```http
GET /api/v1/experiments/{experiment_id}
```

---

## Response

```json
{
  "experiment_id": "exp-001",
  "name": "heart-stroke-prediction",
  "owner": "ml-team"
}
```

---

# List Experiments

## Endpoint

```http
GET /api/v1/experiments
```

---

## Query Parameters

| Parameter     | Description     |
| ------------- | --------------- |
| owner         | Filter by owner |
| created_after | Filter by date  |
| page          | Pagination      |
| limit         | Page size       |

---

## Response

```json
{
  "experiments": [
    {
      "experiment_id": "exp-001",
      "name": "heart-stroke-prediction"
    }
  ]
}
```

---

# Run APIs

---

# Create Run

## Endpoint

```http
POST /api/v1/experiments/{experiment_id}/runs
```

---

## Request

```json
{
  "triggered_by": "training-service",
  "dataset_version": "v3",
  "feature_version": "v2"
}
```

---

## Response

```json
{
  "run_id": "run-145",
  "status": "pending"
}
```

---

## Status Codes

| Code | Meaning              |
| ---- | -------------------- |
| 201  | Created              |
| 404  | Experiment not found |
| 400  | Invalid request      |

---

# Get Run

## Endpoint

```http
GET /api/v1/runs/{run_id}
```

---

## Response

```json
{
  "run_id": "run-145",
  "status": "running",
  "created_at": "2026-01-01T10:00:00Z"
}
```

---

# Update Run Status

## Endpoint

```http
PATCH /api/v1/runs/{run_id}
```

---

## Request

```json
{
  "status": "completed"
}
```

---

## Allowed States

```text
pending
running
completed
failed
cancelled
```

---

# Parameter APIs

---

# Log Parameters

## Endpoint

```http
POST /api/v1/runs/{run_id}/parameters
```

---

## Request

```json
{
  "learning_rate": 0.001,
  "epochs": 100,
  "batch_size": 64
}
```

---

## Response

```json
{
  "status": "logged"
}
```

---

## Validation Rules

Parameters:

* Must be JSON serializable
* Cannot exceed size limits
* Cannot be modified after completion

---

# Retrieve Parameters

## Endpoint

```http
GET /api/v1/runs/{run_id}/parameters
```

---

## Response

```json
{
  "learning_rate": 0.001,
  "epochs": 100
}
```

---

# Metric APIs

---

# Log Metrics

## Endpoint

```http
POST /api/v1/runs/{run_id}/metrics
```

---

## Request

```json
{
  "accuracy": 0.92,
  "precision": 0.89,
  "recall": 0.87
}
```

---

## Response

```json
{
  "status": "logged"
}
```

---

## Validation Rules

Metrics:

* Numeric values only
* Timestamp automatically attached
* Multiple writes supported

---

# Retrieve Metrics

## Endpoint

```http
GET /api/v1/runs/{run_id}/metrics
```

---

## Response

```json
{
  "accuracy": 0.92,
  "precision": 0.89,
  "recall": 0.87
}
```

---

# Artifact APIs

---

# Register Artifact

## Endpoint

```http
POST /api/v1/runs/{run_id}/artifacts
```

---

## Purpose

Register artifact metadata.

The API does not upload files.

---

## Request

```json
{
  "artifact_name": "model.pkl",
  "artifact_type": "model",
  "artifact_uri": "s3://artifacts/model.pkl"
}
```

---

## Response

```json
{
  "artifact_id": "artifact-001",
  "status": "registered"
}
```

---

# Retrieve Artifacts

## Endpoint

```http
GET /api/v1/runs/{run_id}/artifacts
```

---

## Response

```json
{
  "artifacts": [
    {
      "artifact_name": "model.pkl",
      "artifact_uri": "s3://artifacts/model.pkl"
    }
  ]
}
```

---

# Lineage APIs

---

# Retrieve Lineage

## Endpoint

```http
GET /api/v1/runs/{run_id}/lineage
```

---

## Response

```json
{
  "dataset_version": "v3",
  "feature_version": "v2",
  "run_id": "run-145",
  "model_version": "v7"
}
```

---

# Search APIs

---

# Search Runs

## Endpoint

```http
POST /api/v1/search/runs
```

---

## Request

```json
{
  "experiment_id": "exp-001",
  "metric": "accuracy",
  "operator": ">",
  "value": 0.90
}
```

---

## Response

```json
{
  "runs": [
    {
      "run_id": "run-145",
      "accuracy": 0.92
    }
  ]
}
```

---

# Search Experiments

## Endpoint

```http
POST /api/v1/search/experiments
```

---

## Request

```json
{
  "owner": "ml-team"
}
```

---

## Response

```json
{
  "experiments": [
    {
      "experiment_id": "exp-001"
    }
  ]
}
```

---

# Run Comparison API

## Endpoint

```http
POST /api/v1/runs/compare
```

---

## Request

```json
{
  "run_ids": [
    "run-145",
    "run-146"
  ]
}
```

---

## Response

```json
{
  "comparison": {
    "accuracy": {
      "run-145": 0.92,
      "run-146": 0.89
    }
  }
}
```

---

# Audit APIs

---

# Retrieve Audit Information

## Endpoint

```http
GET /api/v1/runs/{run_id}/audit
```

---

## Response

```json
{
  "created_by": "training-service",
  "created_at": "timestamp",
  "last_updated_at": "timestamp"
}
```

---

# Error Response Format

All APIs return a standard error structure.

```json
{
  "error_code": "RUN_NOT_FOUND",
  "message": "Run does not exist",
  "request_id": "req-123"
}
```

---

# Common Error Codes

| Error Code           | Description         |
| -------------------- | ------------------- |
| EXPERIMENT_NOT_FOUND | Experiment missing  |
| RUN_NOT_FOUND        | Run missing         |
| INVALID_REQUEST      | Validation failure  |
| UNAUTHORIZED         | Missing permissions |
| FORBIDDEN            | Access denied       |
| ARTIFACT_NOT_FOUND   | Artifact missing    |
| INTERNAL_ERROR       | Unexpected error    |

---

# Rate Limits

| API Category    | Limit             |
| --------------- | ----------------- |
| Experiment APIs | 100 requests/min  |
| Run APIs        | 500 requests/min  |
| Metric Logging  | 2000 requests/min |
| Search APIs     | 100 requests/min  |

---

# Security Requirements

## Authentication

All requests must be authenticated.

---

## Authorization

Role-based access control:

| Role               | Permissions            |
| ------------------ | ---------------------- |
| ML Engineer        | Read/Write Experiments |
| Data Scientist     | Read/Write Runs        |
| Registry Service   | Read Experiments       |
| Governance Service | Read Metadata          |
| Viewer             | Read Only              |

---

## Audit Logging

Every API request records:

```text
User
Timestamp
Operation
Target Resource
Request ID
```

---

# API Versioning Strategy

Current version:

```text
v1
```

API format:

```text
/ api / v1 / ...
```

Future changes:

```text
v2
```

introduced only for breaking changes.

---

# Non-Goals

The Experiment Tracking API does not:

* Execute training jobs
* Manage infrastructure
* Store datasets
* Store feature tables
* Deploy models
* Upload artifacts

These responsibilities belong to other platform capabilities.

---

# Summary

The Experiment Tracking Capability API provides a consistent interface for managing experiments, runs, parameters, metrics, artifacts, lineage, and audit metadata.

It acts as the authoritative metadata interface for machine learning experimentation while remaining independent of training execution, model deployment, and storage concerns.
