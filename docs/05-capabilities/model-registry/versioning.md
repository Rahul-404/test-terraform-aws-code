# Model Registry Versioning Strategy

## Purpose

This document defines the versioning strategy used by the Model Registry Capability.

Versioning enables the platform to:

* Track model evolution
* Compare model performance over time
* Support reproducibility
* Enable safe deployments
* Support rollbacks
* Preserve auditability

Every model registered in the platform must be versioned.

No model may exist without a version identifier.

---

# Why Versioning Exists

Machine learning models evolve continuously.

Examples:

```text
Model v1 → Initial Baseline

Model v2 → Better Features

Model v3 → Improved Hyperparameters

Model v4 → New Dataset
```

Without versioning:

```text
No Deployment History

No Rollback Capability

No Audit Trail

No Reproducibility

No Governance
```

Versioning solves these problems.

---

# Versioning Principles

## Principle 1

### Models Are Immutable

Once a version is created:

```text
Version = Immutable
```

The artifact cannot be modified.

---

### Allowed

```text
Add Tags

Add Approval Metadata

Change Lifecycle State
```

---

### Not Allowed

```text
Replace Artifact

Modify Metrics

Replace Training Outputs
```

---

## Principle 2

### Every Training Run Creates A New Version

A successful training run always generates:

```text
New Model Version
```

Even if the performance does not improve.

Example:

```text
Run-101 → v17

Run-102 → v18

Run-103 → v19
```

This preserves history.

---

## Principle 3

### Version Numbers Are Sequential

Startup V1 uses simple integer versioning.

Example:

```text
heart-stroke-predictor

v1
v2
v3
v4
v5
```

This approach is:

```text
Simple

Predictable

Easy To Audit
```

---

## Principle 4

### Deployment References Versions

Deployments must use a specific version.

Never:

```text
Deploy Latest File From S3
```

Always:

```text
Deploy Model Version v17
```

---

# Version Hierarchy

The platform uses two versioning levels.

---

## Model Level

Represents the logical model.

Example:

```text
Heart Stroke Predictor
```

---

## Model Version Level

Represents a specific trained artifact.

Example:

```text
Heart Stroke Predictor

├── v15
├── v16
├── v17
└── v18
```

---

# Version Creation Workflow

```text
Training Job
      │
      ▼

Training Complete
      │
      ▼

Register Model
      │
      ▼

Create New Version
      │
      ▼

Draft State
```

---

# Example Version History

```text
Heart Stroke Predictor

v1  Baseline Model

v2  Better Features

v3  Improved Hyperparameters

v4  Larger Dataset

v5  Production Candidate
```

---

# Version Metadata

Each version stores its own metadata.

---

## Example

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 17,
  "status": "approved",
  "artifact_uri": "s3://artifacts/model-v17/",
  "experiment_id": "exp-123",
  "run_id": "run-456"
}
```

---

# Version Components

Every version contains:

| Component        | Purpose                |
| ---------------- | ---------------------- |
| Version ID       | Unique identifier      |
| Artifact URI     | Model location         |
| Metrics          | Evaluation results     |
| Parameters       | Training configuration |
| Tags             | Search and governance  |
| Lifecycle State  | Approval status        |
| Lineage Metadata | Reproducibility        |

---

# Version Lineage

Each version is linked to upstream assets.

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

## Example

```text
Model Version = v17

Dataset = dataset-v5

Feature Version = feature-v3

Experiment = exp-123

Run = run-456
```

---

# Lifecycle And Versioning

Versioning and lifecycle state are separate concepts.

---

## Example

```text
Version = v17

State = Draft
```

Later:

```text
Version = v17

State = Approved
```

The version never changes.

Only the state changes.

---

# Version State Example

```text
v17
 │
 ▼

Draft
 │
 ▼

Validated
 │
 ▼

Approved
 │
 ▼

Archived
```

---

# Version Comparison

The registry supports comparison between versions.

---

## Example

| Version | Accuracy | Recall | F1   |
| ------- | -------- | ------ | ---- |
| v15     | 0.89     | 0.84   | 0.86 |
| v16     | 0.91     | 0.87   | 0.89 |
| v17     | 0.94     | 0.90   | 0.91 |

---

## Usage

Comparison supports:

```text
Deployment Decisions

Approval Decisions

Rollback Decisions

Model Selection
```

---

# Production Versioning

At any time:

```text
Many Versions

One Production Version
```

Example:

```text
Heart Stroke Predictor

v15

v16

v17  ← Production

v18
```

---

# Rollback Strategy

Versioning enables rapid rollback.

---

## Example

```text
Current Production = v17

Issue Detected
```

Rollback:

```text
v17
 │
 ▼

Rollback

 ▼

v16
```

No retraining required.

---

# Artifact Versioning

Artifacts are stored separately for each version.

---

## Example

```text
s3://artifacts/

 ├── heart-stroke/
 │
 ├── v15/
 │
 ├── v16/
 │
 └── v17/
```

This prevents accidental overwrites.

---

# Deployment Eligibility

Only versions meeting governance requirements are deployable.

---

## Deployable

```text
Approved

Artifact Exists

Lineage Complete
```

---

## Not Deployable

```text
Draft

Rejected

Archived
```

---

# Search And Discovery

Version metadata enables discovery.

---

## Example Queries

```text
Latest Approved Version

Best Accuracy Version

Models Created This Month

Models From Dataset-v5
```

---

# Audit Requirements

The registry must answer:

```text
Which Version Was Deployed?

Who Approved It?

Which Run Created It?

Which Dataset Produced It?
```

Versioning makes these questions answerable.

---

# Startup Versioning Strategy

Startup V1 uses:

```text
MLflow Model Registry

Sequential Integer Versions

Single Registry

Single Region
```

Benefits:

```text
Simple

Low Maintenance

Easy Rollback

Easy Auditing
```

---

# Future Evolution

As the platform grows, versioning may expand to support:

```text
Semantic Versioning

Champion-Challenger Models

Multi-Team Registries

Cross-Region Replication

Advanced Release Channels
```

Example:

```text
v1.0.0

v1.1.0

v2.0.0
```

However Startup V1 intentionally avoids this complexity.

---

# Versioning Anti-Patterns

The platform explicitly prohibits:

---

## Overwriting Versions

```text
v17 Artifact

Replace With New Artifact
```

❌ Not Allowed

---

## Deploying Unversioned Models

```text
latest-model.pkl
```

❌ Not Allowed

---

## Deleting Historical Versions

```text
Remove v10
```

❌ Not Allowed

---

## Skipping Registry

```text
Training → S3 → Deployment
```

❌ Not Allowed

Must be:

```text
Training
   │
   ▼

Registry
   │
   ▼

Deployment
```

---

# Version Lifecycle Example

```text
Training Run #456
        │
        ▼

Create Version v17
        │
        ▼

Draft
        │
        ▼

Validated
        │
        ▼

Approved
        │
        ▼

Production
        │
        ▼

Archived
```

---

# Success Criteria

The versioning strategy is successful when:

```text
Every Model Is Versioned

Versions Are Immutable

Deployments Reference Versions

Rollbacks Are Instant

Lineage Exists For Every Version

Version History Is Preserved
```

---

# Summary

The Model Registry Versioning Strategy ensures that every machine learning model is tracked as an immutable, traceable, and auditable version. Each training run generates a new version linked to its dataset, features, experiment, and training run. Deployments reference approved versions rather than raw artifacts, enabling governance, reproducibility, and safe rollback capabilities while maintaining simplicity through MLflow's sequential versioning model in Startup V1.
