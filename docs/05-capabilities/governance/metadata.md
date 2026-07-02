# Metadata

## Purpose

This document defines the metadata management strategy within the Governance Capability.

Metadata provides the contextual information required to understand, govern, approve, audit, and operate machine learning models throughout their lifecycle.

Without metadata, a model becomes an isolated artifact with little operational or governance value.

Metadata answers questions such as:

```text
What is this model?

Who owns it?

Why was it created?

What version is running?

What is its approval status?

What dataset produced it?
```

---

# Why Metadata Exists

A model artifact alone is insufficient.

Example:

```text
model.pkl
```

This tells us nothing about:

```text
Owner

Purpose

Version

Approval

Lineage

Deployment Status
```

Metadata transforms an artifact into a governed asset.

---

# Governance Objectives

Metadata enables:

```text
Traceability

Ownership

Auditability

Approval Workflows

Operational Visibility

Lifecycle Management
```

---

# Position in Platform Architecture

Metadata is consumed across multiple capabilities.

```text
Training

    │

    ▼

Experiment Tracking

    │

    ▼

Model Registry

    │

    ▼

Governance Metadata

    │

    ▼

Deployment

    │

    ▼

Monitoring
```

---

# Metadata Scope

The Governance Capability owns:

```text
Governance Metadata

Ownership Metadata

Approval Metadata

Lifecycle Metadata

Operational Metadata
```

---

# Governance Does Not Own

```text
Training Metrics

Training Parameters

Feature Values

Model Artifacts
```

Those belong to Training, Experiment Tracking, and Model Registry.

---

# Metadata Philosophy

Startup V1 follows:

```text
Minimal

Required

Auditable

Extensible
```

Only metadata that supports governance and operations should be stored.

---

# Metadata Categories

Startup V1 organizes metadata into six categories.

---

# Category 1

## Model Identity Metadata

Defines what the model is.

---

# Fields

```text
Model ID

Model Name

Version

Description
```

---

# Example

```json
{
  "model_id": "stroke-predictor",
  "model_name": "Stroke Prediction Model",
  "version": "2.1.0"
}
```

---

# Purpose

Answers:

```text
What Model Is This?
```

---

# Category 2

## Ownership Metadata

Defines accountability.

---

# Fields

```text
Owner

Team

Business Unit

Contact
```

---

# Example

```json
{
  "owner": "ml-platform-team",
  "team": "data-science"
}
```

---

# Purpose

Answers:

```text
Who Owns This Model?
```

---

# Governance Rule

Every model must have an owner.

---

# Category 3

## Lineage Metadata

Links governance with lineage.

---

# Fields

```text
Dataset Version

Feature Version

Experiment ID

Training Run ID
```

---

# Example

```json
{
  "dataset_version": "v5",
  "experiment_id": "exp-102"
}
```

---

# Purpose

Answers:

```text
Where Did This Model Come From?
```

---

# Governance Rule

Lineage metadata is mandatory.

---

# Category 4

## Approval Metadata

Stores governance decisions.

---

# Fields

```text
Approval Status

Reviewer

Approval Timestamp

Approval Reason
```

---

# Example

```json
{
  "approval_status": "approved",
  "reviewer": "ml-lead"
}
```

---

# Purpose

Answers:

```text
Can This Model Be Deployed?
```

---

# Approval States

```text
Pending

Approved

Rejected
```

---

# Category 5

## Lifecycle Metadata

Tracks model progression.

---

# Fields

```text
Current State

Created At

Updated At

Archived At
```

---

# Example

```json
{
  "lifecycle_state": "approved"
}
```

---

# Supported States

```text
Draft

Registered

Pending Approval

Approved

Rejected

Deployed

Archived
```

---

# Purpose

Answers:

```text
Where Is The Model In Its Lifecycle?
```

---

# Category 6

## Deployment Metadata

Tracks production status.

---

# Fields

```text
Environment

Deployment ID

Deployment Timestamp

Active Version
```

---

# Example

```json
{
  "deployment_id": "prod-01",
  "environment": "production"
}
```

---

# Purpose

Answers:

```text
Which Version Is Running?
```

---

# Metadata Model

Startup V1 uses a structured metadata record.

---

# Example

```json
{
  "model_id": "stroke-predictor",
  "version": "2.1.0",
  "owner": "ml-platform-team",
  "experiment_id": "exp-102",
  "approval_status": "approved",
  "lifecycle_state": "deployed"
}
```

---

# Required Metadata

The following fields are mandatory.

| Field           | Required |
| --------------- | -------- |
| model_id        | ✓        |
| version         | ✓        |
| owner           | ✓        |
| experiment_id   | ✓        |
| approval_status | ✓        |
| lifecycle_state | ✓        |

---

# Optional Metadata

Startup V1 allows:

```text
Description

Business Unit

Tags

Comments
```

---

# Metadata Validation

Governance validates metadata before approval.

---

# Validation Rules

## Rule 1

Model ID must exist.

---

## Rule 2

Owner must exist.

---

## Rule 3

Version must exist.

---

## Rule 4

Experiment ID must exist.

---

## Rule 5

Approval status must be valid.

---

# Example

Valid:

```json
{
  "model_id": "stroke-predictor",
  "owner": "ml-team"
}
```

---

Invalid:

```json
{
  "owner": "ml-team"
}
```

Missing:

```text
model_id
```

---

# Metadata Lifecycle

Metadata evolves with the model.

---

# Registration

Metadata created.

```text
Registered
```

---

# Approval

Approval metadata updated.

```text
Pending

↓

Approved
```

---

# Deployment

Deployment metadata added.

```text
Deployment ID

Environment
```

---

# Archival

Lifecycle updated.

```text
Archived
```

---

# Metadata Storage

Startup V1 stores metadata in:

```text
PostgreSQL
```

---

# Example Table

```text
model_metadata
```

---

# Example Schema

```text
model_id

version

owner

approval_status

lifecycle_state

created_at
```

---

# Metadata API Usage

Metadata is consumed by:

```text
Governance

Deployment

Monitoring

Audit
```

---

# Example Query

Find model owner.

```sql
SELECT owner
FROM model_metadata
WHERE model_id='stroke-predictor';
```

---

# Governance Integration

Metadata drives governance workflows.

---

# Approval Workflow

```text
Metadata Validation

       │

       ▼

Approval Review
```

---

# Example

Missing owner:

```text
Approval Blocked
```

---

# Deployment Integration

Deployment checks metadata.

---

Required:

```text
Approval Status

Lifecycle State
```

---

Example:

```text
Approved

↓

Deploy
```

---

# Audit Integration

Metadata changes generate audit records.

---

Example

```json
{
  "action": "metadata_updated",
  "field": "owner"
}
```

---

# Audit Information

Capture:

```text
Who

What

When
```

---

# Metadata Events

Examples:

```text
MetadataCreated

MetadataUpdated

MetadataValidated
```

---

# Example Event

```json
{
  "event": "metadata_updated",
  "model_id": "stroke-predictor"
}
```

---

# Metadata Observability

Metrics:

```text
metadata_records_total

metadata_validation_failures_total
```

---

# Dashboard Examples

```text
Models Missing Metadata

Ownership Distribution

Approval Status Distribution
```

---

# Security Requirements

Metadata contains operational information.

---

Access should be restricted.

---

Allowed:

```text
ML Engineers

Platform Engineers

Governance Reviewers
```

---

Restricted:

```text
Anonymous Users
```

---

# Startup V1 Limitations

Not supported:

```text
Metadata Schemas Per Team

Dynamic Metadata Policies

Business Risk Metadata

Compliance Metadata
```

---

# Growth V2 Evolution

Introduce:

```text
Metadata Templates

Validation Rules

Metadata Quality Checks
```

---

# Example

```text
Production Model

↓

Must Have

↓

Business Owner
```

---

# Scale V3 Evolution

Introduce:

```text
Metadata Catalog

Advanced Search

Metadata Relationships
```

---

# Enterprise V4 Evolution

Introduce:

```text
Compliance Metadata

Risk Metadata

Regulatory Metadata

Policy-Aware Metadata
```

---

# Metadata Maturity Model

| Capability          | Startup V1 | Growth V2 | Scale V3 | Enterprise V4 |
| ------------------- | ---------- | --------- | -------- | ------------- |
| Basic Metadata      | ✓          | ✓         | ✓        | ✓             |
| Validation          | ✓          | ✓         | ✓        | ✓             |
| Templates           | ✗          | ✓         | ✓        | ✓             |
| Metadata Catalog    | ✗          | ✗         | ✓        | ✓             |
| Compliance Metadata | ✗          | ✗         | ✗        | ✓             |

---

# Requirement → Owner → Verification

| Requirement                        | Owner                 | Verification        |
| ---------------------------------- | --------------------- | ------------------- |
| Every model must have metadata     | Governance Capability | Metadata validation |
| Ownership metadata must exist      | Governance Capability | Approval testing    |
| Metadata changes must be auditable | Governance Capability | Audit review        |
| Metadata must support lineage      | Governance Capability | Lineage validation  |
| Deployment must validate metadata  | Deployment Capability | Integration testing |
| Metadata access must be controlled | Governance Capability | Security review     |

---

# Summary

Metadata is the contextual foundation of the Governance Capability. It transforms model artifacts into managed platform assets by providing identity, ownership, lineage, approval, lifecycle, and deployment information. Startup V1 focuses on mandatory governance metadata stored in PostgreSQL and validated during approval workflows. As the platform matures, metadata evolves into a richer catalog supporting compliance, risk management, policy enforcement, and enterprise governance requirements.
