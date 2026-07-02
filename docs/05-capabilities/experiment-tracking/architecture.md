# Experiment Tracking Capability Architecture

## Purpose

This document describes the internal architecture of the Experiment Tracking Capability, including its components, responsibilities, data ownership, integration points, and interactions with other platform capabilities.

The objective is to explain:

* How experiment metadata flows through the system
* Which components exist inside the capability
* What state is managed
* How integrations occur
* How scalability and reliability are achieved

---

# Architectural Goals

The Experiment Tracking Capability is designed to provide:

* Reproducibility
* Auditability
* Searchability
* Metadata consistency
* Capability independence
* Low operational complexity

---

# High-Level Architecture

```text
                    Training Capability
                            │
                            ▼

                 Experiment Tracking API
                            │
                            ▼

                  MLflow Tracking Server
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
         ▼                  ▼                  ▼

 Experiment Store    Run Metadata Store   Lineage Store

         │                  │                  │
         └──────────────────┼──────────────────┘
                            │
                            ▼

                     Query Layer
                            │
                            ▼

                 Platform Consumers
```

---

# Capability Position

Within the platform:

```text
Feature Store
       │
       ▼

Training
       │
       ▼

Experiment Tracking
       │
       ▼

Model Registry
       │
       ▼

Deployment
```

Experiment Tracking acts as the metadata bridge between model development and model lifecycle management.

---

# Internal Components

The capability consists of six logical components.

| Component         | Responsibility              |
| ----------------- | --------------------------- |
| Experiment API    | External interface          |
| Run Manager       | Run lifecycle management    |
| Metadata Manager  | Parameter & metric tracking |
| Artifact Registry | Artifact references         |
| Lineage Manager   | Relationship tracking       |
| Query Layer       | Search and retrieval        |

---

# Component 1: Experiment API

## Purpose

Provides external access to experiment tracking functionality.

Acts as the capability boundary.

---

## Responsibilities

Expose APIs for:

```text
Create Experiment
Create Run
Log Parameters
Log Metrics
Register Artifacts
Query Metadata
```

---

## Consumers

* Training Capability
* Model Registry
* Governance
* Platform UI

---

## Does Not Do

* Execute training
* Store artifacts
* Deploy models

---

# Component 2: Run Manager

## Purpose

Manages experiment run lifecycle.

---

## Responsibilities

Track:

```text
Run Creation
Run Start
Run Completion
Run Failure
Run Cancellation
```

---

## Run State Model

```text
Pending
    │
    ▼

Running
    │
 ┌──┴──┐
 ▼     ▼

Success Failed
```

---

## Stored Metadata

Examples:

```text
Run ID
Experiment ID
Start Time
End Time
Status
Owner
```

---

# Component 3: Metadata Manager

## Purpose

Stores experiment configuration and outcomes.

---

## Responsibilities

Track:

### Parameters

```text
learning_rate
epochs
batch_size
```

### Metrics

```text
accuracy
precision
recall
f1_score
```

---

## Benefits

Supports:

* Experiment comparison
* Model evaluation
* Reproducibility

---

# Component 4: Artifact Registry

## Purpose

Tracks artifacts generated during experiments.

Important:

The capability stores references, not files.

---

## Example Artifacts

```text
model.pkl
evaluation.json
feature_importance.png
```

---

## Stored Information

```text
Artifact Name
Artifact Type
Version
Storage Location
Checksum
```

---

## Artifact Ownership

Actual files remain in:

```text
S3
```

Experiment Tracking stores only metadata.

---

# Component 5: Lineage Manager

## Purpose

Maintains relationships between ML assets.

---

## Lineage Graph

```text
Dataset
    │
    ▼

Feature Set
    │
    ▼

Training Run
    │
    ▼

Model Version
    │
    ▼

Deployment
```

---

## Responsibilities

Track relationships between:

* Dataset versions
* Feature versions
* Training runs
* Models
* Deployments

---

## Benefits

Supports:

* Auditing
* Governance
* Root cause analysis
* Compliance

---

# Component 6: Query Layer

## Purpose

Provides discovery and retrieval capabilities.

---

## Example Queries

```text
Show all runs
for project X
```

```text
Best model
by F1 Score
```

```text
Runs using
dataset version 3
```

---

## Consumers

* Engineers
* Governance
* Model Registry
* Monitoring

---

# Technology Mapping

The capability is implemented using MLflow.

| Logical Component | Technology               |
| ----------------- | ------------------------ |
| Experiment API    | MLflow API               |
| Run Manager       | MLflow Runs              |
| Metadata Manager  | MLflow Tracking          |
| Artifact Registry | MLflow Artifact Metadata |
| Lineage Manager   | MLflow Tags + Metadata   |
| Query Layer       | MLflow Search APIs       |

---

# Data Model

## Experiment

Represents a logical project.

Example:

```json
{
  "experiment_id": "heart-stroke",
  "name": "Heart Stroke Prediction"
}
```

---

## Run

Represents a single execution.

Example:

```json
{
  "run_id": "run-145",
  "status": "completed"
}
```

---

## Parameters

Example:

```json
{
  "learning_rate": 0.01,
  "epochs": 100
}
```

---

## Metrics

Example:

```json
{
  "accuracy": 0.91,
  "f1_score": 0.89
}
```

---

## Artifact Metadata

Example:

```json
{
  "artifact_name": "model.pkl",
  "artifact_uri": "s3://bucket/model.pkl"
}
```

---

# Data Ownership

The capability owns:

### Experiment Metadata

```text
Experiment IDs
Experiment Names
Ownership
```

---

### Run Metadata

```text
Run State
Timestamps
Status
```

---

### Parameter Metadata

```text
Hyperparameters
Configurations
```

---

### Metric Metadata

```text
Accuracy
Loss
Precision
Recall
```

---

### Artifact References

```text
Artifact URI
Artifact Metadata
```

---

### Lineage Metadata

```text
Relationships
Dependencies
```

---

# State Boundaries

The capability intentionally avoids owning:

| State          | Owner                 |
| -------------- | --------------------- |
| Training Jobs  | Training Capability   |
| Models         | Model Registry        |
| Deployments    | Deployment Capability |
| Artifacts      | S3 Storage            |
| Infrastructure | Infrastructure Layer  |

This separation prevents capability coupling.

---

# Integration Architecture

## Training Integration

```text
Training Job
      │
      ▼

Experiment API
```

Training publishes:

* Parameters
* Metrics
* Artifacts

---

## Model Registry Integration

```text
Experiment Tracking
        │
        ▼
Model Registry
```

Registry consumes:

* Run metadata
* Metrics
* Artifact references

---

## Governance Integration

```text
Experiment Tracking
        │
        ▼
Governance
```

Consumes:

* Lineage
* Audit metadata

---

## Monitoring Integration

```text
Monitoring
      │
      ▼
Experiment Tracking
```

Consumes:

* Service health
* Operational metrics

---

# Failure Handling Architecture

Failures may occur at multiple stages.

---

## Metadata Logging Failure

Example:

```text
Metrics cannot be written
```

Action:

```text
Retry
Alert
Log Failure
```

---

## MLflow Unavailable

Example:

```text
Tracking service unavailable
```

Action:

```text
Fail Run Registration
Alert Platform Team
```

---

## Artifact Registration Failure

Example:

```text
Artifact URI missing
```

Action:

```text
Mark Run Incomplete
Generate Alert
```

---

# Security Architecture

Access is controlled through IAM roles.

---

## Training Role

Permissions:

```text
Write Experiments
Write Metrics
Write Parameters
```

---

## Registry Role

Permissions:

```text
Read Experiments
Read Metrics
Read Artifacts
```

---

## Governance Role

Permissions:

```text
Read Metadata
Read Lineage
```

---

## Principle

```text
Least Privilege Access
```

---

# Observability Architecture

The capability emits operational telemetry.

---

## Metrics

Examples:

```text
Experiments Created
Runs Created
Metric Writes
Artifact Registrations
```

---

## Logs

Examples:

```text
Run Lifecycle Events
API Requests
Errors
```

---

## Alerts

Examples:

```text
Tracking Service Down
Metadata Write Failure
Storage Error
```

---

# Scalability Architecture

The capability is designed for gradual growth.

---

## Startup Scale

```text
1–50 Runs Per Day
```

Simple deployment.

---

## Growth Scale

```text
100–1000 Runs Per Day
```

Introduce:

* Metadata optimization
* Query tuning
* Retention policies

---

## Enterprise Scale

```text
Thousands of Runs Per Day
```

Potential future additions:

* Metadata partitioning
* Read replicas
* Multi-region replication

---

# Architectural Decisions

| Decision                         | Rationale             |
| -------------------------------- | --------------------- |
| MLflow for Tracking              | Industry standard     |
| S3 for Artifacts                 | Durable and scalable  |
| Metadata Separate from Artifacts | Improved scalability  |
| Capability Isolation             | Independent evolution |
| API-Driven Access                | Loose coupling        |
| Immutable Run History            | Reproducibility       |

---

# Future Architecture Evolution

Potential future enhancements:

* Metadata warehouse
* Advanced lineage graph engine
* Cross-project search
* Cost attribution tracking
* Multi-region metadata replication
* Experiment recommendation systems
* OpenLineage integration

These should be introduced only when justified by platform scale.

---

# Summary

The Experiment Tracking Capability is a metadata-centric service responsible for managing experiments, runs, parameters, metrics, artifact references, and lineage information.

Its architecture is intentionally separated from training execution, artifact storage, deployment, and governance, allowing it to act as the central system of record for machine learning experimentation across the platform.
