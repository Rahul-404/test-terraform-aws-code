# Model Registry Capability API Contract

## Purpose

This document defines the logical API contract exposed by the Model Registry Capability.

The API enables platform components to:

* Register models
* Manage versions
* Retrieve model metadata
* Approve models
* Query deployment candidates
* Retrieve lineage information
* Archive models

These APIs are consumed by:

* Training Capability
* Deployment Capability
* Governance Capability
* Platform Services
* Internal Platform Users

---

# API Design Principles

## Principle 1

### Registry Owns Model Metadata

The API manages metadata only.

Model artifacts remain in S3.

```text
Registry
    │
    ▼

Metadata

Artifact References
```

---

## Principle 2

### Version Numbers Are Immutable

A model version can never be modified after creation.

Allowed:

```text
Status Change

Tag Updates

Approval Updates
```

Not Allowed:

```text
Artifact Replacement

Version Mutation
```

---

## Principle 3

### Deployment Uses Registry

Deployments must retrieve approved models through registry APIs.

Direct S3 deployments are prohibited.

---

# Resource Model

## Model

```json
{
  "model_name": "heart-stroke-predictor",
  "description": "Heart stroke prediction model"
}
```

---

## Model Version

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 17,
  "status": "approved"
}
```

---

## Approval

```json
{
  "approved_by": "ml-engineer",
  "approved_at": "2026-05-10T10:00:00Z"
}
```

---

## Lineage

```json
{
  "dataset_id": "dataset-v5",
  "experiment_id": "exp-12",
  "run_id": "run-45"
}
```

---

# API Overview

| API                 | Purpose                  |
| ------------------- | ------------------------ |
| Register Model      | Create model version     |
| Get Model           | Retrieve model metadata  |
| List Models         | Search registry          |
| Get Version         | Retrieve version details |
| Approve Model       | Promote model            |
| Reject Model        | Reject model             |
| Archive Model       | Archive model            |
| Get Latest Approved | Deployment lookup        |
| Get Lineage         | Traceability             |
| Compare Versions    | Version comparison       |

---

# API 1

# Register Model

Creates a new model version after training.

---

## Endpoint

```http
POST /api/v1/models/register
```

---

## Request

```json
{
  "model_name": "heart-stroke-predictor",
  "artifact_uri": "s3://artifacts/model-v17/",
  "experiment_id": "exp-123",
  "run_id": "run-456",
  "metrics": {
    "accuracy": 0.94,
    "f1_score": 0.91
  }
}
```

---

## Validation Rules

```text
Model Name Required

Artifact URI Required

Run ID Required

Experiment ID Required
```

---

## Response

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 17,
  "status": "draft"
}
```

---

## Called By

```text
Training Capability
```

---

# API 2

# Get Model

Returns model metadata.

---

## Endpoint

```http
GET /api/v1/models/{model_name}
```

---

## Example

```http
GET /api/v1/models/heart-stroke-predictor
```

---

## Response

```json
{
  "model_name": "heart-stroke-predictor",
  "latest_version": 17,
  "status": "approved"
}
```

---

# API 3

# List Models

Searches registry.

---

## Endpoint

```http
GET /api/v1/models
```

---

## Query Parameters

```text
model_name

owner

status

tag

created_after

created_before
```

---

## Example

```http
GET /api/v1/models?status=approved
```

---

## Response

```json
{
  "models": [
    {
      "model_name": "heart-stroke-predictor",
      "version": 17
    }
  ]
}
```

---

# API 4

# Get Version

Returns version details.

---

## Endpoint

```http
GET /api/v1/models/{model_name}/versions/{version}
```

---

## Example

```http
GET /api/v1/models/heart-stroke-predictor/versions/17
```

---

## Response

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 17,
  "status": "approved",
  "artifact_uri": "s3://artifacts/model-v17/"
}
```

---

# API 5

# Approve Model

Approves a validated model.

---

## Endpoint

```http
POST /api/v1/models/{model_name}/versions/{version}/approve
```

---

## Request

```json
{
  "approved_by": "ml-engineer"
}
```

---

## Response

```json
{
  "status": "approved"
}
```

---

## Preconditions

```text
Model Exists

Version Exists

Version Validated
```

---

# API 6

# Reject Model

Rejects a version.

---

## Endpoint

```http
POST /api/v1/models/{model_name}/versions/{version}/reject
```

---

## Request

```json
{
  "reason": "Failed performance threshold"
}
```

---

## Response

```json
{
  "status": "rejected"
}
```

---

# API 7

# Archive Model

Archives a version.

---

## Endpoint

```http
POST /api/v1/models/{model_name}/versions/{version}/archive
```

---

## Response

```json
{
  "status": "archived"
}
```

---

## Rules

Archived versions:

```text
Cannot Be Deployed

Remain Searchable

Remain Auditable
```

---

# API 8

# Get Latest Approved Model

Primary deployment API.

---

## Endpoint

```http
GET /api/v1/models/{model_name}/latest-approved
```

---

## Example

```http
GET /api/v1/models/heart-stroke-predictor/latest-approved
```

---

## Response

```json
{
  "version": 17,
  "artifact_uri": "s3://artifacts/model-v17/",
  "status": "approved"
}
```

---

## Called By

```text
Deployment Capability
```

---

# API 9

# Get Model Lineage

Returns model traceability information.

---

## Endpoint

```http
GET /api/v1/models/{model_name}/versions/{version}/lineage
```

---

## Response

```json
{
  "dataset_id": "dataset-v5",
  "feature_version": "feature-v3",
  "experiment_id": "exp-12",
  "run_id": "run-45"
}
```

---

# API 10

# Compare Versions

Compares model versions.

---

## Endpoint

```http
POST /api/v1/models/compare
```

---

## Request

```json
{
  "model_name": "heart-stroke-predictor",
  "versions": [15, 16, 17]
}
```

---

## Response

```json
{
  "versions": [
    {
      "version": 15,
      "accuracy": 0.89
    },
    {
      "version": 16,
      "accuracy": 0.91
    },
    {
      "version": 17,
      "accuracy": 0.94
    }
  ]
}
```

---

# Lifecycle State API Rules

Supported states:

```text
Draft

Validated

Approved

Rejected

Archived
```

---

## Allowed Transitions

```text
Draft
  │
  ▼

Validated
  │
 ┌┴────────┐
 ▼         ▼

Approved Rejected
   │
   ▼

Archived
```

---

## Invalid Transitions

```text
Archived → Approved

Rejected → Approved

Draft → Archived
```

---

# Error Model

## Validation Error

```json
{
  "error": "INVALID_REQUEST",
  "message": "artifact_uri is required"
}
```

---

## Not Found

```json
{
  "error": "MODEL_NOT_FOUND"
}
```

---

## Permission Error

```json
{
  "error": "ACCESS_DENIED"
}
```

---

## Invalid State Transition

```json
{
  "error": "INVALID_STATE_TRANSITION"
}
```

---

# Authentication

Startup Version:

```text
IAM-Based Access

Internal Platform Access
```

---

## Training Permissions

Allowed:

```text
Register Model

Read Metadata
```

---

## Deployment Permissions

Allowed:

```text
Read Approved Models
```

---

## Governance Permissions

Allowed:

```text
Approve Models

Reject Models

Archive Models
```

---

# Rate Limiting

Startup platform assumptions:

| API Type          | Limit    |
| ----------------- | -------- |
| Read APIs         | 1000/min |
| Registration APIs | 100/min  |
| Approval APIs     | 50/min   |

These limits are primarily protective rather than scaling requirements.

---

# API Consumers

| Consumer              | APIs Used                |
| --------------------- | ------------------------ |
| Training Capability   | Register Model           |
| Deployment Capability | Latest Approved Model    |
| Governance Capability | Approve, Reject          |
| Monitoring Capability | Version Metadata         |
| Platform UI           | Search, Compare, Lineage |

---

# Startup Implementation Mapping

| Logical API     | MLflow Operation                 |
| --------------- | -------------------------------- |
| Register Model  | register_model()                 |
| Get Model       | get_registered_model()           |
| Get Version     | get_model_version()              |
| Approve Model   | transition_model_version_stage() |
| Latest Approved | search_model_versions()          |
| Archive Model   | transition_model_version_stage() |

---

# Future API Evolution

Future versions may support:

```text
Bulk Registration

Automated Approval APIs

Policy Evaluation APIs

Risk Assessment APIs

Multi-Registry Federation

Cross-Region Queries
```

without changing the core contract.

---

# Summary

The Model Registry API Contract defines the interfaces used to manage model lifecycle metadata across the platform. It supports model registration, version management, lineage retrieval, approval workflows, deployment lookup, and governance operations. The APIs establish the registry as the authoritative source of truth for deployable machine learning models while remaining implementation-independent and aligned with the MLflow-based startup architecture.
