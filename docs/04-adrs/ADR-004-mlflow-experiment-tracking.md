# ADR-004: MLflow for Experiment Tracking

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform supports multiple machine learning projects that continuously iterate on models through experimentation.

Data Scientists perform numerous training runs while adjusting:

* Algorithms
* Hyperparameters
* Feature engineering
* Dataset versions
* Preprocessing techniques
* Evaluation strategies

Without centralized experiment tracking, reproducing results becomes difficult, collaboration suffers, and identifying the best-performing models becomes unreliable.

The platform therefore requires a standardized experiment management system.

---

# Problem Statement

How should machine learning experiments be tracked so that:

* Results are reproducible
* Metrics are centralized
* Artifacts are discoverable
* Collaboration is simplified
* Training lineage is preserved
* Future deployments remain auditable

while minimizing operational complexity?

---

# Decision

The platform adopts **MLflow Tracking** as the centralized experiment tracking system.

Every production training execution will automatically log:

* Experiment name
* Run metadata
* Parameters
* Metrics
* Dataset version
* Docker image version
* Git commit
* Artifacts
* Execution timestamps
* Environment information

MLflow becomes the authoritative source for experiment history across all projects.

---

# Why MLflow Was Chosen

## Open Standard

MLflow is widely adopted across the machine learning ecosystem.

It integrates with numerous frameworks while remaining implementation independent.

The platform avoids vendor-specific experiment formats.

---

## Framework Agnostic

MLflow supports models built using:

* Scikit-learn
* XGBoost
* LightGBM
* PyTorch
* TensorFlow
* Hugging Face
* Custom Python code

The platform can standardize experimentation without restricting model choices.

---

## Native Artifact Management

Experiments automatically associate artifacts with execution metadata.

Typical artifacts include:

* Model files
* Plots
* Metrics
* Evaluation reports
* Configuration files
* Feature importance visualizations

This improves reproducibility.

---

## Strong Integration with Existing Workflow

MLflow integrates naturally with:

* SageMaker Training Jobs
* Docker containers
* S3 artifact storage
* Model Registry
* CI/CD pipelines

It fits well within the platform architecture.

---

## Reproducibility

Every experiment records sufficient metadata to recreate historical executions.

No experiment should depend on undocumented local environments.

---

# Alternatives Considered

## Option 1: No Experiment Tracking

Developers manually save results.

### Advantages

* Zero infrastructure

### Disadvantages

* No reproducibility
* Lost history
* Difficult collaboration
* Poor governance

Rejected.

---

## Option 2: Custom Database

Build an internal experiment tracking service.

### Advantages

* Full customization
* Complete ownership

### Disadvantages

* Significant engineering effort
* Maintenance burden
* Reinvents existing solutions

Rejected.

---

## Option 3: SageMaker Experiments

Use AWS-native experiment tracking.

### Advantages

* Native integration
* Managed service

### Disadvantages

* AWS-specific implementation
* Reduced portability
* Smaller ecosystem

Not selected.

---

## Option 4: MLflow Tracking (Selected)

Centralized experiment management independent of training infrastructure.

### Advantages

* Open ecosystem
* Framework agnostic
* Portable
* Well understood
* Easy integration
* Strong community support

Chosen for this platform.

---

# Experiment Lifecycle

Every experiment follows the same lifecycle.

```text
Start Run
     │
     ▼
Log Parameters
     │
     ▼
Execute Training
     │
     ▼
Log Metrics
     │
     ▼
Store Artifacts
     │
     ▼
Record Dataset Version
     │
     ▼
Record Git Commit
     │
     ▼
Complete Run
```

This structure provides complete execution history.

---

# Metadata Captured

Each run records:

## Parameters

* Hyperparameters
* Training configuration
* Random seeds
* Environment variables

---

## Metrics

* Accuracy
* Precision
* Recall
* F1 Score
* ROC-AUC
* RMSE
* MAE
* Custom business metrics

---

## Artifacts

* Trained models
* Evaluation reports
* Confusion matrices
* Visualizations
* Logs

---

## Lineage

* Dataset version
* Docker image
* Git SHA
* Feature version
* Training timestamp

Together these provide complete reproducibility.

---

# Relationship with SageMaker

SageMaker performs computation.

MLflow records metadata.

The responsibilities remain separate.

```text
Docker Image
      │
      ▼
SageMaker Training
      │
      ▼
MLflow Tracking
      │
      ▼
Artifacts + Metrics + Metadata
```

Compute and tracking evolve independently.

---

# Artifact Storage Strategy

Artifacts logged through MLflow are stored in centralized object storage.

Typical outputs include:

* Models
* Evaluation reports
* Charts
* Logs
* Supporting files

MLflow manages references while storage remains external.

---

# Integration with Model Registry

Only selected experiments proceed to registration.

Typical promotion flow:

```text
Experiment
      │
      ▼
Evaluation
      │
      ▼
Best Candidate
      │
      ▼
Model Registry
      │
      ▼
Deployment
```

Experiment tracking does not imply production approval.

---

# Security Considerations

Access to experiment data is restricted through IAM and platform permissions.

Users should have access appropriate to their role.

Sensitive artifacts remain protected through centralized storage policies.

---

# Cost Considerations

Experiment metadata is lightweight.

Primary storage costs originate from:

* Artifacts
* Large model files
* Visualizations
* Logs

Lifecycle policies should archive or remove obsolete artifacts where appropriate.

---

# Failure Handling

If experiment logging fails:

* Training status should be reported.
* Failure should be visible.
* Partial metadata should be preserved where possible.
* Silent failures are unacceptable.

Experiment history must remain trustworthy.

---

# Consequences

## Positive Consequences

* Reproducible experiments
* Centralized metadata
* Better collaboration
* Easy comparison of runs
* Simplified debugging
* Improved governance
* Standardized workflows

---

## Negative Consequences

* Additional infrastructure
* Artifact storage costs
* Operational dependency on tracking service

These costs are justified by improved engineering quality.

---

# Rules Enforced

Every experiment must satisfy the following rules.

## Rule 1

Every production training run creates an MLflow run.

---

## Rule 2

Every run records parameters.

---

## Rule 3

Every run records metrics.

---

## Rule 4

Every run records dataset version.

---

## Rule 5

Every run records Git revision.

---

## Rule 6

Every run records Docker image version.

---

## Rule 7

Artifacts are stored centrally.

---

## Rule 8

Experiments cannot be modified after completion.

Historical records remain immutable.

---

# Impact on Platform Architecture

## ML Services Layer

Provides experiment tracking capability.

---

## Data Platform Layer

Supplies versioned datasets referenced by experiments.

---

## Platform Foundation Layer

Provides storage and observability.

---

## Application Layer

Does not interact directly with experiment tracking.

Experimentation remains an internal platform concern.

---

# Scalability Implications

As projects increase:

* Thousands of experiments can coexist.
* Multiple teams share one tracking service.
* Training infrastructure scales independently.
* Experiment history remains centralized.

The architecture supports long-term growth without redesign.

---

# When This Decision Should Be Revisited

Alternative tracking systems may be considered if:

* Enterprise governance requires different tooling
* Cross-cloud portability requirements change
* Organization-wide standardization mandates another platform
* MLflow no longer satisfies operational requirements

Until then, MLflow remains the preferred solution.

---

# Trade-off Summary

| Aspect                 | MLflow Tracking |
| ---------------------- | --------------- |
| Reproducibility        | Excellent       |
| Framework Support      | Excellent       |
| Portability            | High            |
| Operational Complexity | Low             |
| Ecosystem              | Strong          |
| Vendor Lock-in         | Low             |
| Startup Suitability    | Excellent       |

---

# Decision Outcome

The Startup Data & AI Platform standardizes experiment tracking using MLflow.

Every production training execution records parameters, metrics, artifacts, lineage, and execution metadata in a centralized tracking system, enabling reproducibility, collaboration, governance, and reliable model selection while remaining independent of the underlying training infrastructure.

---

# References

* ADR-003: SageMaker Training
* ADR-005: MLflow Model Registry
* ML Services Layer
* Training Flow
* Startup Assumptions

This ADR establishes MLflow as the authoritative system for recording and managing machine learning experiments across the platform.
