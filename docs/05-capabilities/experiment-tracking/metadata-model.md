# Experiment Tracking Capability Metadata Model

## Purpose

This document defines the metadata model used by the Experiment Tracking Capability.

The metadata model establishes:

* What information is stored
* Entity relationships
* Ownership boundaries
* Lineage representation
* Search and query capabilities
* Integration contracts with other capabilities

The metadata model serves as the foundation for reproducibility, governance, auditing, and experiment comparison.

---

# Metadata Design Principles

## Metadata Over Data

The capability stores metadata, not actual datasets or artifacts.

Examples:

```text
Stored:
✓ Experiment Metadata
✓ Run Metadata
✓ Parameters
✓ Metrics
✓ Artifact References

Not Stored:
✗ Dataset Files
✗ Model Files
✗ Images
✗ Large Objects
```

---

## Immutable Experiment History

Completed experiment records are never modified.

This ensures:

* Reproducibility
* Auditability
* Historical accuracy

---

## Traceable Lineage

Every experiment should be traceable back to:

```text
Dataset Version
       ↓

Feature Version
       ↓

Training Run
       ↓

Model Version
       ↓

Deployment
```

---

# Metadata Domain Model

```text
Experiment
     │
     │ 1:N
     ▼

Run
 ├─────────────┐
 │             │
 ▼             ▼

Parameters   Metrics
 │             │
 └──────┬──────┘
        ▼

    Artifacts
        │
        ▼

     Lineage
```

---

# Core Entities

The Experiment Tracking Capability manages six primary entities.

| Entity             | Purpose                         |
| ------------------ | ------------------------------- |
| Experiment         | Logical project container       |
| Run                | Individual experiment execution |
| Parameter          | Training configuration          |
| Metric             | Experiment result               |
| Artifact Reference | Output metadata                 |
| Lineage Record     | Relationship metadata           |

---

# Entity 1: Experiment

## Purpose

Represents a logical experimentation project.

---

## Examples

```text
Heart Stroke Prediction

Customer Churn Prediction

Fraud Detection
```

---

## Schema

```json
{
  "experiment_id": "exp-001",
  "name": "heart-stroke-prediction",
  "description": "Heart Stroke Prediction Model",
  "owner": "ml-team",
  "created_at": "timestamp",
  "status": "active"
}
```

---

## Owned Attributes

| Field         | Description          |
| ------------- | -------------------- |
| experiment_id | Unique identifier    |
| name          | Experiment name      |
| description   | Business description |
| owner         | Owning team          |
| created_at    | Creation timestamp   |
| status        | Active/Archived      |

---

## Relationships

```text
Experiment
      │
      ▼

Multiple Runs
```

---

# Entity 2: Run

## Purpose

Represents a single training execution.

---

## Examples

```text
Run #145

Random Forest Training

XGBoost Experiment
```

---

## Schema

```json
{
  "run_id": "run-145",
  "experiment_id": "exp-001",
  "status": "completed",
  "created_at": "timestamp",
  "started_at": "timestamp",
  "ended_at": "timestamp",
  "duration_seconds": 1800
}
```

---

## Relationships

```text
Experiment
      │
      ▼

Run
 ├─────► Parameters
 ├─────► Metrics
 ├─────► Artifacts
 └─────► Lineage
```

---

# Run State Model

```text
Created
   │
   ▼

Pending
   │
   ▼

Running
   │
 ┌─┴────────┐
 ▼          ▼

Completed Failed
```

---

## State Definitions

| State     | Meaning               |
| --------- | --------------------- |
| Created   | Run initialized       |
| Pending   | Waiting for execution |
| Running   | Training active       |
| Completed | Finished successfully |
| Failed    | Execution failed      |

---

# Entity 3: Parameters

## Purpose

Capture experiment configuration.

---

## Examples

```text
learning_rate

epochs

batch_size

optimizer
```

---

## Schema

```json
{
  "run_id": "run-145",
  "parameter_name": "learning_rate",
  "parameter_value": "0.001"
}
```

---

## Example Parameter Set

```json
{
  "learning_rate": 0.001,
  "epochs": 100,
  "batch_size": 64,
  "optimizer": "adam"
}
```

---

## Characteristics

| Property                 | Value       |
| ------------------------ | ----------- |
| Mutable During Run       | Yes         |
| Mutable After Completion | No          |
| Searchable               | Yes         |
| Versioned                | Through Run |

---

# Entity 4: Metrics

## Purpose

Store experiment outcomes.

---

## Examples

```text
Accuracy

Precision

Recall

F1 Score

Loss
```

---

## Schema

```json
{
  "run_id": "run-145",
  "metric_name": "accuracy",
  "metric_value": 0.92,
  "timestamp": "timestamp"
}
```

---

## Example Metric Set

```json
{
  "accuracy": 0.92,
  "precision": 0.89,
  "recall": 0.87,
  "f1_score": 0.88
}
```

---

## Characteristics

| Property    | Value |
| ----------- | ----- |
| Numeric     | Yes   |
| Timestamped | Yes   |
| Searchable  | Yes   |
| Comparable  | Yes   |

---

# Entity 5: Artifact Reference

## Purpose

Store references to generated artifacts.

---

## Important

Artifacts are not stored here.

Only metadata is stored.

---

## Actual Storage

```text
Amazon S3
```

---

## Schema

```json
{
  "artifact_id": "artifact-001",
  "run_id": "run-145",
  "artifact_name": "model.pkl",
  "artifact_type": "model",
  "artifact_uri": "s3://artifacts/model.pkl",
  "checksum": "sha256-value"
}
```

---

## Examples

```text
model.pkl

evaluation.json

feature_importance.png

confusion_matrix.png
```

---

## Artifact Types

| Type          | Example              |
| ------------- | -------------------- |
| Model         | model.pkl            |
| Evaluation    | metrics.json         |
| Visualization | confusion_matrix.png |
| Report        | evaluation.pdf       |

---

# Entity 6: Lineage Record

## Purpose

Track relationships across the ML lifecycle.

---

## Schema

```json
{
  "lineage_id": "lin-001",
  "run_id": "run-145",
  "dataset_version": "dataset-v3",
  "feature_version": "feature-v2",
  "model_version": "model-v7"
}
```

---

## Lineage Graph

```text
Dataset Version
       │
       ▼

Feature Version
       │
       ▼

Run
       │
       ▼

Model Version
       │
       ▼

Deployment
```

---

## Benefits

Supports:

* Governance
* Compliance
* Auditing
* Reproducibility
* Root Cause Analysis

---

# Entity Relationships

## Experiment → Run

```text
1 Experiment
      │
      ▼

Many Runs
```

---

## Run → Parameters

```text
1 Run
      │
      ▼

Many Parameters
```

---

## Run → Metrics

```text
1 Run
      │
      ▼

Many Metrics
```

---

## Run → Artifacts

```text
1 Run
      │
      ▼

Many Artifacts
```

---

## Run → Lineage

```text
1 Run
      │
      ▼

One Lineage Record
```

---

# Metadata Ownership

The capability owns:

| Metadata            | Owned |
| ------------------- | ----- |
| Experiments         | Yes   |
| Runs                | Yes   |
| Parameters          | Yes   |
| Metrics             | Yes   |
| Artifact References | Yes   |
| Lineage Records     | Yes   |

---

# External Ownership

The capability does not own:

| Asset          | Owner                 |
| -------------- | --------------------- |
| Datasets       | Data Platform         |
| Features       | Feature Store         |
| Models         | Model Registry        |
| Deployments    | Deployment Capability |
| Infrastructure | Infrastructure Layer  |
| Artifacts      | S3 Storage            |

---

# Search Indexing Model

The following metadata should be searchable.

---

## Experiment Fields

```text
Experiment Name
Owner
Status
Created Date
```

---

## Run Fields

```text
Run ID
Status
Duration
Timestamp
```

---

## Parameter Fields

```text
Learning Rate
Epochs
Batch Size
Optimizer
```

---

## Metric Fields

```text
Accuracy
Recall
Precision
F1 Score
Loss
```

---

## Lineage Fields

```text
Dataset Version
Feature Version
Model Version
```

---

# Audit Metadata

Every entity should include audit fields.

---

## Standard Audit Schema

```json
{
  "created_by": "training-service",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

---

## Purpose

Supports:

* Governance
* Compliance
* Security investigations

---

# Metadata Retention

## Startup Phase

Retain all metadata indefinitely.

Reason:

```text
Low Storage Cost
High Learning Value
```

---

## Growth Phase

Introduce retention rules.

Examples:

```text
Completed Runs > 2 Years

Archived Experiments > 3 Years
```

---

## Enterprise Phase

Introduce:

* Tiered storage
* Metadata archival
* Compliance retention policies

---

# Metadata Lifecycle

```text
Created
   │
   ▼

Active
   │
   ▼

Searchable
   │
   ▼

Archived
   │
   ▼

Deleted (Optional)
```

---

# MLflow Mapping

The metadata model maps directly to MLflow.

| Metadata Entity     | MLflow Component  |
| ------------------- | ----------------- |
| Experiment          | MLflow Experiment |
| Run                 | MLflow Run        |
| Parameters          | MLflow Params     |
| Metrics             | MLflow Metrics    |
| Artifact References | MLflow Artifacts  |
| Lineage             | Tags + Metadata   |

---

# Future Metadata Extensions

Potential future additions:

### Cost Tracking

```json
{
  "training_cost_usd": 12.45
}
```

---

### Infrastructure Metadata

```json
{
  "instance_type": "ml.m5.large"
}
```

---

### Dataset Statistics

```json
{
  "row_count": 100000
}
```

---

### Benchmark Metadata

```json
{
  "benchmark_score": 0.91
}
```

---

### Model Explainability Metadata

```json
{
  "shap_report": "artifact_uri"
}
```

---

# Summary

The Experiment Tracking Metadata Model defines the core entities, relationships, lineage structure, ownership boundaries, and lifecycle rules used to manage machine learning experimentation across the platform.

It provides a scalable and auditable foundation for experiment management while remaining independent from training execution, artifact storage, model deployment, and infrastructure concerns.
