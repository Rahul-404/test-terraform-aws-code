# ADR-006: Amazon S3 for Artifact Storage

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform generates numerous artifacts throughout the machine learning lifecycle.

These artifacts include:

* Trained models
* Checkpoints
* Evaluation reports
* Feature statistics
* Data validation reports
* Visualizations
* Configuration files
* Logs
* Model explanations
* Supporting metadata

These files must be durable, versioned, highly available, and accessible across multiple platform capabilities.

The platform therefore requires a centralized artifact storage solution.

---

# Problem Statement

How should machine learning artifacts be stored so that they are:

* Durable
* Cost-effective
* Highly available
* Easily shareable
* Scalable
* Independent of compute infrastructure
* Accessible across platform services

while minimizing operational overhead?

---

# Decision

The platform adopts **Amazon S3 as the centralized artifact storage system**.

All machine learning artifacts generated throughout the lifecycle are stored in S3.

Platform services store references to artifacts rather than embedding binary data directly.

S3 becomes the authoritative storage layer for persistent artifacts.

---

# Why Amazon S3 Was Chosen

## High Durability

Amazon S3 provides highly durable object storage suitable for long-term artifact retention.

Artifacts remain available independently of compute resources.

---

## Native AWS Integration

S3 integrates directly with:

* SageMaker
* MLflow
* IAM
* CloudWatch
* EventBridge
* Lambda
* CI/CD pipelines

This minimizes integration complexity.

---

## Cost Efficiency

Storage costs scale with usage.

Lifecycle policies allow:

* Archiving
* Intelligent tiering
* Automatic expiration

Unused artifacts can be moved to lower-cost storage classes.

---

## Virtually Unlimited Scalability

Object storage grows independently of training or inference workloads.

No redesign is required as artifact volume increases.

---

## Decoupling Compute and Storage

Training jobs terminate after completion.

Artifacts persist independently.

Deployment systems retrieve artifacts from storage without requiring access to historical compute environments.

---

# Alternatives Considered

## Option 1: Local Disk Storage

Store artifacts on compute instances.

### Advantages

* Simple implementation

### Disadvantages

* Ephemeral
* Non-shareable
* No durability
* Lost when instances terminate

Rejected.

---

## Option 2: EBS Volumes

Persist artifacts on attached block storage.

### Advantages

* Persistent

### Disadvantages

* Limited sharing
* Manual management
* Scaling challenges

Rejected.

---

## Option 3: Database Storage

Store binary artifacts inside relational databases.

### Advantages

* Centralized management

### Disadvantages

* Poor performance
* Expensive
* Difficult scaling
* Not designed for large binaries

Rejected.

---

## Option 4: Amazon S3 (Selected)

Object storage dedicated to machine learning artifacts.

### Advantages

* Durable
* Cost-effective
* Scalable
* Shared
* Native AWS integration

Chosen for the platform.

---

# Artifact Categories

The platform stores several classes of artifacts.

## Model Artifacts

Examples:

* Serialized models
* ONNX exports
* Torch checkpoints
* TensorFlow SavedModels

---

## Evaluation Artifacts

Examples:

* Metrics reports
* ROC curves
* Confusion matrices
* Feature importance plots

---

## Data Artifacts

Examples:

* Validation reports
* Profiling outputs
* Statistics
* Feature summaries

---

## Operational Artifacts

Examples:

* Logs
* Configuration files
* Pipeline outputs
* Metadata snapshots

---

## Governance Artifacts

Examples:

* Approval records
* Audit reports
* Compliance documentation
* Model cards

---

# Storage Organization

Artifacts follow a standardized hierarchical structure.

Example:

```text
s3://ml-platform-artifacts/

├── experiments/
├── models/
├── deployments/
├── evaluations/
├── monitoring/
├── feature-store/
├── governance/
└── backups/
```

Projects use consistent naming conventions to simplify discovery.

---

# Relationship with MLflow

MLflow stores metadata.

S3 stores binaries.

```text
MLflow
   │
   ▼
Artifact Reference
   │
   ▼
Amazon S3
```

This separation keeps tracking lightweight while allowing artifacts to scale independently.

---

# Relationship with Model Registry

The registry references artifacts stored in S3.

```text
Model Registry
        │
        ▼
Artifact URI
        │
        ▼
Amazon S3
```

Model versions remain lightweight while binaries remain centralized.

---

# Relationship with Training

Training jobs produce artifacts directly into S3.

```text
SageMaker Training
         │
         ▼
Generate Model
         │
         ▼
Store in S3
```

Compute resources terminate after upload.

---

# Relationship with Deployment

Deployment pipelines retrieve approved artifacts from S3.

```text
Registry
     │
     ▼
Artifact URI
     │
     ▼
S3
     │
     ▼
Deployment
```

Deployments never depend on historical training environments.

---

# Security Considerations

Artifact access is controlled through IAM.

Policies enforce:

* Least privilege
* Encryption at rest
* Encryption in transit
* Role-based access

Sensitive artifacts remain protected.

---

# Versioning Strategy

Artifact versioning is preserved through:

* Model versions
* Experiment identifiers
* Dataset versions
* Immutable object paths

Existing artifacts are never overwritten.

New versions create new objects.

---

# Lifecycle Management

Lifecycle rules automatically manage retention.

Typical policies include:

* Archive old artifacts
* Delete temporary files
* Transition infrequently accessed objects
* Preserve production models

Storage costs remain predictable.

---

# Backup Strategy

S3 durability minimizes backup complexity.

Critical governance metadata may additionally be replicated or exported when required.

Platform recovery procedures reference immutable object storage.

---

# Failure Handling

If artifact upload fails:

* Training is marked unsuccessful.
* Registration does not proceed.
* Deployment is blocked.
* Alerts are generated.

Incomplete artifacts must never enter production workflows.

---

# Consequences

## Positive Consequences

* Durable storage
* Shared artifact repository
* Decoupled compute
* Simple deployments
* Low operational overhead
* Native AWS integration
* Excellent scalability

---

## Negative Consequences

* AWS dependency
* Storage costs increase with usage
* Object management requires lifecycle policies

These trade-offs align with startup priorities.

---

# Rules Enforced

## Rule 1

Every production artifact is stored in S3.

---

## Rule 2

Artifacts are immutable.

---

## Rule 3

Platform metadata stores references rather than binary content.

---

## Rule 4

Training outputs upload artifacts before completion.

---

## Rule 5

Deployments retrieve artifacts only from approved locations.

---

## Rule 6

Artifacts are versioned through immutable paths.

---

## Rule 7

Lifecycle policies manage long-term retention.

---

## Rule 8

Direct manual modification of production artifacts is prohibited.

---

# Impact on Platform Architecture

## Platform Foundation Layer

Provides centralized object storage capability.

---

## ML Services Layer

Consumes artifact storage for experiments, models, monitoring, and governance.

---

## Data Platform Layer

May store validation and profiling artifacts.

---

## Application Layer

Does not access artifacts directly.

Applications consume deployed services rather than stored models.

---

# Scalability Implications

As the platform grows:

* Storage scales independently.
* New projects reuse the same bucket structure.
* Artifact volume increases without infrastructure redesign.
* Deployment pipelines remain unchanged.

Object storage becomes a shared platform capability.

---

# When This Decision Should Be Revisited

Alternative storage strategies may be considered if:

* Multi-cloud portability becomes mandatory
* Regulatory requirements require specialized storage
* Enterprise governance introduces new constraints
* Extremely large artifacts require different optimization

Until then, S3 remains the preferred artifact storage solution.

---

# Trade-off Summary

| Aspect                  | Amazon S3 |
| ----------------------- | --------- |
| Durability              | Excellent |
| Scalability             | Excellent |
| Cost Efficiency         | High      |
| Operational Complexity  | Low       |
| Native AWS Integration  | Excellent |
| Sharing Across Services | Excellent |
| Startup Suitability     | Excellent |

---

# Decision Outcome

The Startup Data & AI Platform standardizes Amazon S3 as the centralized artifact storage layer.

All persistent machine learning artifacts—including models, evaluation outputs, logs, reports, and supporting files—are stored in immutable S3 locations while platform services maintain lightweight references to those objects.

This decision decouples storage from compute, enables reproducible deployments, simplifies governance, and provides a scalable foundation for every stage of the machine learning lifecycle.

---

# References

* ADR-003: SageMaker Training
* ADR-004: MLflow Experiment Tracking
* ADR-005: MLflow Model Registry
* ML Services Layer
* Platform Foundation Layer
* Deployment Flow

This ADR establishes Amazon S3 as the canonical artifact storage system for the Startup Data & AI Platform.
