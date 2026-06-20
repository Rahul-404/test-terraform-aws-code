# Model Registry Capability Architecture

## Purpose

This document describes the internal architecture of the Model Registry Capability and explains how model lifecycle management is implemented within the platform.

The architecture is designed to:

* Maintain model lifecycle metadata
* Manage model versions
* Support governance workflows
* Enable deployment decisions
* Preserve model lineage
* Provide auditability

The capability is intentionally lightweight in Startup V1 while supporting future evolution toward enterprise-scale governance.

---

# Architectural Goals

The architecture is designed around the following objectives:

```text
Single Source Of Truth For Models

Version Management

Lifecycle Management

Deployment Governance

Auditability

Reproducibility

Low Operational Complexity
```

---

# Capability Position In Platform

```text
                    Training Capability
                             │
                             ▼

                  Experiment Tracking
                             │
                             ▼

                    Model Registry
                             │
                             ▼

                  Deployment Capability
                             │
                             ▼

                   Production Serving
```

The Model Registry sits between model creation and model deployment.

---

# High-Level Architecture

```text
                ┌────────────────────┐
                │ Training Capability │
                └──────────┬─────────┘
                           │
                           ▼

                ┌────────────────────┐
                │ Model Registration │
                │      Service       │
                └──────────┬─────────┘
                           │
                           ▼

                ┌────────────────────┐
                │   Model Registry   │
                │      (MLflow)      │
                └──────────┬─────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼

  Version Mgmt      Lifecycle Mgmt      Lineage Mgmt

                           │
                           ▼

                ┌────────────────────┐
                │ Deployment Service │
                └────────────────────┘
```

---

# Architecture Principles

## Principle 1

### Registry Stores Metadata

The registry does not store large model files.

Instead it stores:

```text
Model Metadata

Version Metadata

Lifecycle State

Lineage Metadata

Artifact References
```

Actual model artifacts reside in S3.

---

## Principle 2

### Deployment Pulls From Registry

Deployments never use arbitrary model artifacts.

Deployment capability must request:

```text
Latest Approved Model
```

from the registry.

---

## Principle 3

### Models Are Immutable

Once a model version is created:

```text
Version = Immutable
```

Only metadata fields may change.

Example:

```text
Allowed:

Draft → Approved

Approved → Archived
```

Not Allowed:

```text
Replace Model Artifact
```

---

# Internal Components

The capability contains five logical components.

```text
Model Registration

Version Management

Lifecycle Management

Lineage Management

Approval Management
```

---

# Component 1

# Model Registration

## Purpose

Creates model entries after successful training.

---

## Inputs

```text
Training Run ID

Experiment ID

Artifact URI

Metrics

Tags
```

---

## Outputs

```text
Registered Model

Version Number

Lifecycle State
```

---

## Example

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 7,
  "stage": "draft"
}
```

---

# Component 2

# Version Management

## Purpose

Manages model version history.

---

## Responsibilities

```text
Create Version

Retrieve Version

Compare Versions

Archive Version
```

---

## Example

```text
HeartStrokeModel

v1
v2
v3
v4
```

---

# Component 3

# Lifecycle Management

## Purpose

Controls model state transitions.

---

## Lifecycle States

```text
Draft

Validated

Approved

Rejected

Archived
```

---

## Example

```text
Draft
   │
   ▼

Validated
   │
   ▼

Approved
```

---

## Validation Rules

Example:

```text
Only Approved Models
Can Be Deployed
```

---

# Component 4

# Lineage Management

## Purpose

Maintains relationships between platform entities.

---

## Example

```text
Dataset
   │
   ▼

Feature Version
   │
   ▼

Experiment
   │
   ▼

Training Run
   │
   ▼

Model Version
```

---

## Benefits

```text
Traceability

Reproducibility

Auditing
```

---

# Component 5

# Approval Management

## Purpose

Controls model promotion.

---

## Startup Workflow

```text
Training Complete
        │
        ▼

Register Model
        │
        ▼

Manual Review
        │
        ▼

Approve
        │
        ▼

Deploy
```

---

## Future Workflow

```text
Automated Validation

Risk Scoring

Policy Evaluation

Approval Automation
```

---

# Metadata Architecture

## Core Metadata Model

```text
Model
   │
   ├── Versions
   │
   ├── Lifecycle State
   │
   ├── Metrics
   │
   ├── Tags
   │
   └── Artifact Reference
```

---

## Model Record Example

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 4,
  "owner": "ml-team",
  "stage": "approved",
  "artifact_uri": "s3://ml-artifacts/models/v4/",
  "experiment_id": "exp-123",
  "run_id": "run-456"
}
```

---

# Data Storage Architecture

## Metadata Storage

Startup V1 uses:

```text
MLflow Backend Database
(PostgreSQL)
```

Stores:

```text
Model Records

Version Metadata

Lifecycle State

Lineage Metadata
```

---

## Artifact Storage

Stores:

```text
Model Files

Pickle Files

ONNX Models

Torch Models

TensorFlow Models
```

Location:

```text
Amazon S3
```

---

## Registry Relationship

```text
Model Registry
        │
        ▼

Artifact URI
        │
        ▼

S3 Object
```

Registry stores references only.

---

# Integration Architecture

## Integration With Training

Training registers models after successful execution.

```text
Training Job
      │
      ▼

Register Model
      │
      ▼

Registry Creates Version
```

---

## Integration With Experiment Tracking

Registry receives lineage metadata.

```text
Experiment
      │
      ▼

Run Metadata
      │
      ▼

Registry Reference
```

---

## Integration With Deployment

Deployment retrieves approved models.

```text
Deployment Service
          │
          ▼

Query Registry
          │
          ▼

Latest Approved Model
```

---

## Integration With Governance

Governance validates approvals.

```text
Governance Rules
        │
        ▼

Registry State Transition
```

---

# Security Architecture

## Access Model

```text
Data Scientist
      │
      ├── Register Model
      └── View Models

ML Engineer
      │
      ├── Approve Model
      └── Archive Model

Deployment Service
      │
      └── Read Approved Models
```

---

## IAM Controls

Startup:

```text
Basic IAM Roles
```

Future:

```text
Fine-Grained RBAC
```

---

# Request Flow

## Model Registration

```text
Training Job
      │
      ▼

Registry API
      │
      ▼

Version Created
      │
      ▼

Metadata Stored
```

---

## Deployment Lookup

```text
Deployment Service
       │
       ▼

Registry Query
       │
       ▼

Approved Version
       │
       ▼

Artifact URI
```

---

# Failure Isolation

The registry is intentionally separated from:

```text
Training

Deployment

Serving

Monitoring
```

Failures remain localized.

---

## Example

If deployment fails:

```text
Deployment Down

Registry Healthy
```

If registry fails:

```text
Training Continues

Model Registration Delayed
```

---

# Scalability Design

## Startup

```text
Single MLflow Registry

Single PostgreSQL Backend

Single Region
```

---

## Growth

```text
Multiple Registry Instances

Load Balancer

Read Replicas
```

---

## Enterprise

```text
Global Registry

Multi-Region Replication

Advanced Governance
```

---

# Architectural Decisions

| Decision                   | Reason                              |
| -------------------------- | ----------------------------------- |
| MLflow Registry            | Integrated with experiment tracking |
| PostgreSQL Backend         | Reliable metadata storage           |
| S3 Artifact Storage        | Cheap and scalable                  |
| Immutable Versions         | Auditability                        |
| Manual Approval            | Startup simplicity                  |
| Registry Before Deployment | Governance enforcement              |

---

# Startup Architecture Diagram

```text
                   ┌──────────────────────┐
                   │ Training Capability  │
                   └──────────┬───────────┘
                              │
                              ▼

                   ┌──────────────────────┐
                   │  MLflow Registry     │
                   │  Model Metadata      │
                   └───────┬───────┬──────┘
                           │       │
                           │       ▼

                           │   PostgreSQL
                           │
                           ▼

                      S3 Artifacts
                           │
                           ▼

                   Deployment Capability
```

---

# Summary

The Model Registry Capability architecture is built around MLflow Model Registry as the authoritative source of truth for machine learning model lifecycle metadata. The capability manages model registration, versioning, lineage, lifecycle states, approvals, and deployment eligibility while storing actual artifacts in S3 and metadata in PostgreSQL. Its architecture deliberately separates governance from training and deployment concerns, providing a simple startup-friendly design that can evolve into an enterprise-grade model governance platform without requiring fundamental architectural changes.
