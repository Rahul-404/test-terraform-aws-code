# Feature Store API Contract

## Purpose

This document defines the API contract exposed by the Feature Store Capability.

The API provides a standardized interface for:

* Feature registration
* Feature discovery
* Feature retrieval
* Feature version management
* Feature lifecycle management
* Feature lineage access

The API is designed to be consumed by:

* Data Scientists
* ML Engineers
* Training Services
* Retraining Services
* Governance Services
* Platform Administrators

---

# Design Principles

The Feature Store API follows these principles:

### Metadata First

Metadata is queried far more frequently than feature data.

### Immutable Versions

Versions cannot be modified after creation.

### API Stability

Backward compatibility is preferred.

### Ownership Enforcement

Feature ownership is validated.

### Auditability

All mutations generate audit events.

### Idempotency

Repeated requests produce consistent results.

---

# API Overview

```text
Base URL

/api/v1/features
```

---

# Resource Model

The API exposes five primary resources.

```text
Feature

Feature Version

Feature Lineage

Feature Lifecycle

Feature Search
```

---

# Feature Object

## Example

```json
{
  "feature_id": "feat_123",
  "name": "customer_risk_score",
  "description": "Customer fraud risk score",
  "owner": "fraud-team",
  "status": "ACTIVE",
  "current_version": "v3",
  "created_at": "2026-01-10T10:00:00Z"
}
```

---

# Feature Version Object

## Example

```json
{
  "feature_id": "feat_123",
  "version": "v3",
  "storage_uri": "s3://feature-store/customer_risk_score/v3/",
  "schema_version": "1.0",
  "created_at": "2026-03-12T10:00:00Z"
}
```

---

# Feature Lineage Object

## Example

```json
{
  "feature_id": "feat_123",
  "version": "v3",
  "source_dataset": "transactions",
  "transformation_job": "fraud-feature-pipeline",
  "dependent_models": [
    "fraud_model_v7",
    "fraud_model_v8"
  ]
}
```

---

# Endpoint Categories

```text
Feature Registration

Feature Discovery

Feature Retrieval

Version Management

Lineage

Lifecycle Management
```

---

# Endpoint 1

# Register Feature

## Purpose

Create a new feature definition.

---

## Request

```http
POST /api/v1/features
```

---

## Request Body

```json
{
  "name": "customer_risk_score",
  "description": "Fraud risk score",
  "owner": "fraud-team",
  "source_dataset": "transactions",
  "tags": [
    "fraud",
    "risk"
  ]
}
```

---

## Success Response

```http
201 Created
```

```json
{
  "feature_id": "feat_123",
  "status": "ACTIVE"
}
```

---

## Validation Rules

Required:

```text
name

description

owner

source_dataset
```

---

## Failure Codes

| Code | Meaning                |
| ---- | ---------------------- |
| 400  | Invalid Request        |
| 409  | Feature Already Exists |
| 500  | Internal Error         |

---

# Endpoint 2

# Get Feature

## Purpose

Retrieve feature metadata.

---

## Request

```http
GET /api/v1/features/{feature_id}
```

---

## Example

```http
GET /api/v1/features/feat_123
```

---

## Response

```json
{
  "feature_id": "feat_123",
  "name": "customer_risk_score",
  "owner": "fraud-team",
  "status": "ACTIVE",
  "current_version": "v3"
}
```

---

# Endpoint 3

# List Features

## Purpose

Retrieve registered features.

---

## Request

```http
GET /api/v1/features
```

---

## Query Parameters

| Parameter | Description               |
| --------- | ------------------------- |
| owner     | Filter by owner           |
| tag       | Filter by tag             |
| status    | Filter by lifecycle state |
| limit     | Pagination size           |
| offset    | Pagination offset         |

---

## Example

```http
GET /api/v1/features?owner=fraud-team
```

---

## Response

```json
{
  "features": [
    {
      "feature_id": "feat_123",
      "name": "customer_risk_score"
    }
  ]
}
```

---

# Endpoint 4

# Search Features

## Purpose

Discover reusable features.

---

## Request

```http
GET /api/v1/features/search
```

---

## Query Parameters

| Parameter | Description  |
| --------- | ------------ |
| query     | Search text  |
| tag       | Tag filter   |
| owner     | Owner filter |

---

## Example

```http
GET /api/v1/features/search?query=customer
```

---

## Response

```json
{
  "results": [
    {
      "feature_id": "feat_123",
      "name": "customer_risk_score"
    }
  ]
}
```

---

# Endpoint 5

# Create Feature Version

## Purpose

Publish a new feature version.

---

## Request

```http
POST /api/v1/features/{feature_id}/versions
```

---

## Request Body

```json
{
  "version": "v4",
  "storage_uri": "s3://feature-store/customer_risk_score/v4/",
  "change_reason": "Updated feature logic"
}
```

---

## Success Response

```http
201 Created
```

```json
{
  "feature_id": "feat_123",
  "version": "v4"
}
```

---

## Version Rules

```text
Versions Are Immutable

Version Numbers Must Be Unique

Historical Versions Cannot Be Modified
```

---

# Endpoint 6

# List Feature Versions

## Purpose

Retrieve version history.

---

## Request

```http
GET /api/v1/features/{feature_id}/versions
```

---

## Response

```json
{
  "versions": [
    "v1",
    "v2",
    "v3",
    "v4"
  ]
}
```

---

# Endpoint 7

# Get Feature Version

## Purpose

Retrieve a specific version.

---

## Request

```http
GET /api/v1/features/{feature_id}/versions/{version}
```

---

## Example

```http
GET /api/v1/features/feat_123/versions/v3
```

---

## Response

```json
{
  "version": "v3",
  "storage_uri": "s3://feature-store/customer_risk_score/v3/"
}
```

---

# Endpoint 8

# Retrieve Training Feature Dataset

## Purpose

Provide versioned features for training jobs.

---

## Request

```http
GET /api/v1/features/{feature_id}/dataset/{version}
```

---

## Response

```json
{
  "feature_id": "feat_123",
  "version": "v3",
  "dataset_uri": "s3://feature-store/customer_risk_score/v3/"
}
```

---

## Consumer

```text
Training Service

Retraining Service
```

---

# Endpoint 9

# Get Feature Lineage

## Purpose

Retrieve lineage information.

---

## Request

```http
GET /api/v1/features/{feature_id}/lineage
```

---

## Response

```json
{
  "source_dataset": "transactions",
  "dependent_models": [
    "fraud_model_v7"
  ]
}
```

---

# Endpoint 10

# Deprecate Feature

## Purpose

Mark a feature as deprecated.

---

## Request

```http
POST /api/v1/features/{feature_id}/deprecate
```

---

## Request Body

```json
{
  "reason": "Replaced by customer_risk_score_v2"
}
```

---

## Response

```json
{
  "status": "DEPRECATED"
}
```

---

# Endpoint 11

# Archive Feature

## Purpose

Archive a deprecated feature.

---

## Request

```http
POST /api/v1/features/{feature_id}/archive
```

---

## Response

```json
{
  "status": "ARCHIVED"
}
```

---

# Lifecycle State Contract

## Supported States

```text
DRAFT

VALIDATED

ACTIVE

DEPRECATED

ARCHIVED
```

---

## Allowed Transitions

```text
DRAFT
   ↓

VALIDATED
   ↓

ACTIVE
   ↓

DEPRECATED
   ↓

ARCHIVED
```

---

# Pagination Contract

Large queries use pagination.

---

## Request

```http
GET /api/v1/features?limit=50&offset=100
```

---

## Response

```json
{
  "total": 500,
  "limit": 50,
  "offset": 100,
  "items": []
}
```

---

# Error Contract

## Standard Response

```json
{
  "error": {
    "code": "FEATURE_NOT_FOUND",
    "message": "Feature does not exist"
  }
}
```

---

# Common Error Codes

| Code                   | Meaning           |
| ---------------------- | ----------------- |
| FEATURE_NOT_FOUND      | Feature missing   |
| VERSION_NOT_FOUND      | Version missing   |
| FEATURE_ALREADY_EXISTS | Duplicate feature |
| INVALID_REQUEST        | Invalid payload   |
| ACCESS_DENIED          | Unauthorized      |
| VALIDATION_FAILED      | Validation error  |
| INTERNAL_ERROR         | Server error      |

---

# Authentication Contract

Startup V1 uses:

```text
AWS IAM

API Gateway Authorization

Service Roles
```

---

## Human Users

```text
Platform Admin

ML Engineer

Data Scientist
```

---

## Services

```text
Training Service

Retraining Service

Governance Service
```

---

# Authorization Rules

| Operation         | Owner | Admin | Training Service |
| ----------------- | ----- | ----- | ---------------- |
| Register Feature  | Yes   | Yes   | No               |
| Create Version    | Yes   | Yes   | No               |
| Read Metadata     | Yes   | Yes   | Yes              |
| Read Dataset      | Yes   | Yes   | Yes              |
| Deprecate Feature | Yes   | Yes   | No               |
| Archive Feature   | No    | Yes   | No               |

---

# Audit Events

Every mutation generates an audit event.

Tracked operations:

```text
Feature Registration

Version Creation

Metadata Updates

Deprecation

Archival

Ownership Transfer
```

---

# API Versioning Strategy

Startup V1 uses:

```text
/api/v1/
```

Future changes:

```text
/api/v2/
```

Breaking changes never occur within the same API version.

---

# Startup V1 Constraints

The API intentionally excludes:

```text
Online Feature Serving

Streaming Features

Real-Time Materialization

Feature Computation APIs

Cross-Region APIs
```

to maintain operational simplicity.

---

# Success Criteria

The API contract is successful when:

```text
Features Can Be Registered Reliably

Versions Are Immutable

Discovery Is Easy

Training Remains Reproducible

Governance Is Enforced

Lineage Is Accessible

Backward Compatibility Is Maintained
```

---

# Summary

The Feature Store API Contract provides a stable interface for feature registration, discovery, retrieval, versioning, lineage tracking, and lifecycle management. The API follows immutable versioning principles, strong governance controls, and startup-focused simplicity while establishing a clear foundation for future platform evolution.
