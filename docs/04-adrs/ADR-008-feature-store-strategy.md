# ADR-008: Offline-First Feature Store Strategy

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

Machine learning applications depend on consistent feature definitions across training and inference.

Without centralized feature management:

* Feature engineering is duplicated.
* Training and inference pipelines diverge.
* Data leakage becomes more likely.
* Feature lineage is difficult to track.
* Reproducibility suffers.

The platform therefore requires a standardized feature management strategy.

However, the startup environment is characterized by:

* 3–5 ML applications
* 6–10 deployed models
* Primarily batch-oriented workloads
* Moderate inference traffic
* Cost-sensitive infrastructure
* Limited platform engineering resources

An enterprise-grade online feature store would introduce unnecessary complexity.

---

# Problem Statement

How should features be managed so that they are:

* Reusable
* Consistent
* Versioned
* Discoverable
* Reproducible
* Shared across projects

while avoiding premature infrastructure complexity?

---

# Decision

The platform adopts an **offline-first feature store strategy**.

Features are centrally defined, versioned, and materialized into batch-accessible storage.

Training and batch inference consume these standardized feature datasets.

Real-time online feature serving is intentionally deferred until business requirements justify it.

The platform exposes a **Feature Store capability**, with the current implementation optimized for offline workloads.

---

# Why an Offline-First Strategy Was Chosen

## Startup Workloads Are Primarily Batch-Oriented

Most training pipelines naturally consume batch datasets.

The majority of startup prediction workloads do not require millisecond feature retrieval.

An offline feature store satisfies current requirements.

---

## Reduced Operational Complexity

Avoiding an online serving layer eliminates:

* Low-latency databases
* Cache synchronization
* Feature replication
* Streaming infrastructure
* Online consistency challenges

This keeps the platform maintainable by a small team.

---

## Feature Reuse

Centralized feature definitions can be shared across:

* Training pipelines
* Batch inference
* Data analysis
* Model retraining

Duplicate feature engineering is minimized.

---

## Training and Inference Consistency

Both training and inference consume the same feature definitions.

This reduces training-serving skew.

---

## Evolution Without Lock-In

The Feature Store is treated as a platform capability rather than a specific technology.

An online implementation can be introduced later without changing consumer interfaces.

---

# Alternatives Considered

## Option 1: No Feature Store

Each project computes its own features.

### Advantages

* Minimal infrastructure

### Disadvantages

* Duplicate logic
* Inconsistent transformations
* Poor reproducibility
* Difficult maintenance

Rejected.

---

## Option 2: Enterprise Online Feature Store

Deploy low-latency serving infrastructure from the beginning.

### Advantages

* Real-time serving
* Centralized features

### Disadvantages

* Operational complexity
* Higher costs
* Streaming requirements
* Unnecessary for startup scale

Rejected.

---

## Option 3: Offline-First Feature Store (Selected)

Batch-oriented feature management with future online extensibility.

### Advantages

* Simple
* Reusable
* Cost-effective
* Reproducible
* Evolvable

Chosen for the platform.

---

# Feature Lifecycle

Every feature follows a standardized lifecycle.

```text
Raw Data
     │
     ▼
Transformation
     │
     ▼
Feature Definition
     │
     ▼
Materialization
     │
     ▼
Versioned Feature Dataset
     │
     ▼
Training / Batch Inference
```

Feature computation is standardized across projects.

---

# Feature Definitions

Each feature includes metadata such as:

* Name
* Description
* Data type
* Transformation logic
* Owner
* Version
* Source datasets
* Update frequency

Definitions remain discoverable and reusable.

---

# Feature Versioning

Feature changes create new versions rather than modifying existing definitions.

Example:

```text
customer_age

v1
v2
v3
```

Historical training runs remain reproducible.

---

# Relationship with Training

Training pipelines consume versioned feature datasets.

```text
Feature Store
       │
       ▼
Training Pipeline
       │
       ▼
Model
```

Training never depends directly on raw source systems.

---

# Relationship with Batch Inference

Batch prediction uses the same feature generation logic.

```text
Feature Store
       │
       ▼
Batch Inference
       │
       ▼
Predictions
```

Training-serving consistency is preserved.

---

# Relationship with Data Platform

The Data Platform produces validated datasets.

The Feature Store transforms those datasets into reusable feature representations.

```text
Raw Data
     │
     ▼
Data Platform
     │
     ▼
Feature Store
```

Responsibilities remain separated.

---

# Online Serving Considerations

Real-time serving is intentionally deferred.

Current workloads do not justify:

* Online key-value databases
* Streaming pipelines
* Low-latency synchronization
* Event-driven feature computation

The architecture preserves a future migration path.

---

# Future Evolution

If real-time requirements emerge:

```text
                 Feature Store
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
Offline Materialization      Online Serving Layer
        │                           │
        ▼                           ▼
Training                 Real-Time Inference
```

Consumers continue using the same logical capability.

---

# Security Considerations

Feature datasets inherit platform security controls.

Access is governed through:

* IAM roles
* Dataset permissions
* Least privilege
* Encryption at rest
* Encryption in transit

Sensitive features remain protected.

---

# Cost Considerations

Batch feature storage minimizes infrastructure costs.

No dedicated serving clusters are required.

Materialization schedules can be optimized according to business needs.

---

# Failure Handling

Feature generation failures:

* Block downstream training
* Prevent stale datasets
* Trigger alerts
* Preserve previous valid versions

Invalid features must never silently propagate.

---

# Consequences

## Positive Consequences

* Shared feature definitions
* Reduced duplication
* Improved reproducibility
* Lower operational complexity
* Consistent training and inference
* Easy evolution

---

## Negative Consequences

* No millisecond online serving
* Batch latency
* Requires materialization pipelines

These trade-offs are appropriate for startup workloads.

---

# Rules Enforced

## Rule 1

Features are defined centrally.

---

## Rule 2

Training consumes versioned features.

---

## Rule 3

Feature definitions are immutable once published.

---

## Rule 4

Feature changes create new versions.

---

## Rule 5

Training and inference use identical transformations.

---

## Rule 6

Raw data should not bypass feature generation.

---

## Rule 7

Online serving is optional and introduced only when justified.

---

## Rule 8

Projects reuse shared features whenever possible.

---

# Impact on Platform Architecture

## Data Platform Layer

Produces validated datasets used to generate features.

---

## ML Services Layer

Consumes feature datasets during training and inference.

---

## Application Layer

Uses prediction services rather than interacting directly with feature storage.

---

## Consumer Layer

Remains unaware of internal feature management.

---

# Scalability Implications

As the platform grows:

* Additional projects reuse existing features.
* Materialization pipelines scale independently.
* Online serving can be introduced incrementally.
* Existing consumers remain unchanged.

The architecture evolves without breaking interfaces.

---

# When This Decision Should Be Revisited

An online feature store should be considered when:

* Real-time inference becomes business critical
* Sub-second feature retrieval is required
* Streaming architectures become common
* Multiple applications require shared online state
* Feature freshness requirements tighten significantly

Until then, offline-first remains the preferred strategy.

---

# Trade-off Summary

| Aspect                 | Offline-First Strategy |
| ---------------------- | ---------------------- |
| Operational Complexity | Low                    |
| Reproducibility        | Excellent              |
| Feature Reuse          | High                   |
| Cost Efficiency        | High                   |
| Real-Time Support      | Limited                |
| Scalability            | High                   |
| Startup Suitability    | Excellent              |

---

# Decision Outcome

The Startup Data & AI Platform standardizes an offline-first feature store strategy.

Features are centrally defined, versioned, materialized, and reused across training and batch inference while intentionally avoiding unnecessary online serving infrastructure.

By treating the Feature Store as a platform capability rather than a specific implementation, the architecture supports current startup needs while preserving a clear migration path toward future real-time feature serving.

---

# References

* ADR-003: SageMaker Training
* ADR-004: MLflow Experiment Tracking
* Data Platform Layer
* ML Services Layer
* Training Flow
* Startup Assumptions

This ADR establishes the Feature Store capability as a reusable platform service and defines an offline-first implementation strategy aligned with startup-scale requirements.
