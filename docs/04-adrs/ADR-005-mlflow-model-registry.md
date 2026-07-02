# ADR-005: MLflow Model Registry for Model Lifecycle Management

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform supports multiple machine learning applications that continuously produce new model versions through experimentation and retraining.

Without a centralized registry:

- Models become difficult to discover.
- Production deployments lose traceability.
- Rollbacks become unreliable.
- Lineage between experiments and deployments is lost.
- Governance becomes increasingly difficult.

The platform therefore requires a standardized mechanism for managing production-ready models throughout their lifecycle.

---

# Problem Statement

How should trained models be managed so that:

- Every model is versioned
- Lineage is preserved
- Deployments are reproducible
- Rollbacks are simple
- Governance is standardized
- Multiple projects can share common workflows

while remaining lightweight enough for startup environments?

---

# Decision

The platform adopts **MLflow Model Registry** as the centralized model lifecycle management system.

Every production model must be registered before deployment.

The registry becomes the authoritative source for:

- Model versions
- Model metadata
- Training lineage
- Deployment eligibility
- Approval status
- Artifact references

No model may be deployed directly from a training job.

---

# Why MLflow Model Registry Was Chosen

## Native Integration with Experiment Tracking

Every registered model is directly linked to the experiment that produced it.

This preserves:

- Parameters
- Metrics
- Dataset versions
- Artifacts
- Training metadata

No additional lineage system is required.

---

## Version Management

Each registration creates a new immutable version.

For example:

```text
HeartStrokeModel

Version 1
Version 2
Version 3
Version 4
```

Historical versions remain accessible.

---

## Simplified Rollback

If production issues occur, deployment can reference a previous version rather than retraining.

Rollback becomes a metadata operation rather than a development effort.

---

## Centralized Governance

Model approval occurs independently of training.

A trained model may exist without being eligible for production deployment.

This separation improves quality control.

---

## Framework Independence

MLflow supports multiple model frameworks without changing registry workflows.

Projects remain free to choose the most appropriate algorithms.

---

# Alternatives Considered

## Option 1: Store Models Directly in S3

### Advantages

- Simple
- Low cost

### Disadvantages

- No version management
- No lineage
- No approval workflow
- Difficult discovery
- Manual governance

Rejected.

---

## Option 2: Git-Based Model Storage

### Advantages

- Version control

### Disadvantages

- Large binary files
- Poor metadata management
- No deployment lifecycle
- Not designed for ML artifacts

Rejected.

---

## Option 3: SageMaker Model Registry

### Advantages

- Native AWS integration

### Disadvantages

- Increased vendor dependence
- Reduced portability
- Less consistency with experiment tracking

Not selected.

---

## Option 4: MLflow Model Registry (Selected)

### Advantages

- Native experiment linkage
- Strong versioning
- Open ecosystem
- Portable workflows
- Lightweight governance

Chosen for the startup platform.

---

# Model Lifecycle

Every model progresses through the same lifecycle.

```text
Experiment
      │
      ▼
Training
      │
      ▼
Evaluation
      │
      ▼
Register Model
      │
      ▼
Approval
      │
      ▼
Deployment
      │
      ▼
Monitoring
      │
      ▼
Retraining
```

The registry serves as the control point between experimentation and production.

---

# Registration Requirements

Every registered model records:

- Model name
- Version
- Source experiment
- Dataset version
- Git commit
- Docker image
- Metrics
- Artifact location
- Creation timestamp

This metadata provides complete traceability.

---

# Versioning Strategy

Versions are immutable.

For example:

```text
FraudDetection

v1
v2
v3
v4
```

Modifications require creation of a new version rather than editing an existing one.

---

# Relationship with Experiment Tracking

Experiments produce candidate models.

The registry promotes selected candidates.

```text
MLflow Experiment
        │
        ▼
Best Run
        │
        ▼
Model Registry
        │
        ▼
Deployment
```

Not every experiment becomes a registered model.

---

# Relationship with Artifact Storage

Model binaries remain stored in object storage.

The registry maintains references and metadata rather than duplicating artifacts.

This separation keeps storage scalable.

---

# Approval Workflow

Before deployment, models may undergo:

- Metric validation
- Manual review
- Automated quality checks
- Business approval
- Security validation

Registration alone does not imply deployment authorization.

---

# Deployment Integration

Deployment pipelines retrieve models from the registry rather than training outputs.

```text
Registry
     │
     ▼
Deployment Pipeline
     │
     ▼
Inference Endpoint
```

This guarantees that only managed models reach production.

---

# Rollback Strategy

If deployment fails:

```text
Current Version
        │
        ▼
Rollback
        │
        ▼
Previous Registered Version
```

Rollback does not require retraining.

Production stability improves significantly.

---

# Security Considerations

Registry access is controlled through IAM and platform permissions.

Only authorized users may:

- Register models
- Approve models
- Promote versions
- Archive models

Deployment systems receive read-only access where appropriate.

---

# Cost Considerations

Registry metadata storage is minimal.

Primary costs originate from:

- Model artifacts
- Object storage
- Long-term retention

Lifecycle policies should archive obsolete versions where practical.

---

# Failure Handling

Registry failures must never silently bypass governance.

If registration fails:

- Deployment must stop.
- Errors must be visible.
- Artifacts remain preserved.
- Retry mechanisms may be invoked.

No production deployment should occur without successful registration.

---

# Consequences

## Positive Consequences

- Complete version history
- Strong lineage
- Easy rollback
- Standardized governance
- Simplified deployments
- Better collaboration
- Centralized model discovery

---

## Negative Consequences

- Additional operational component
- Metadata maintenance
- Approval workflow overhead

These trade-offs are acceptable given the benefits.

---

# Rules Enforced

## Rule 1

Every production model must be registered.

---

## Rule 2

Model versions are immutable.

---

## Rule 3

Deployments use registry versions rather than training outputs.

---

## Rule 4

Every registered model references its originating experiment.

---

## Rule 5

Every model references versioned artifacts.

---

## Rule 6

Rollback uses previous registry versions.

---

## Rule 7

Approval and registration are separate concepts.

---

## Rule 8

Models may not bypass the registry.

---

# Impact on Platform Architecture

## ML Services Layer

Owns the registry capability.

---

## Data Platform Layer

Provides dataset lineage associated with registered models.

---

## Platform Foundation Layer

Provides artifact storage and supporting infrastructure.

---

## Application Layer

Consumes deployed endpoints without awareness of registry internals.

---

# Scalability Implications

As projects increase:

- Hundreds of models can coexist.
- Multiple teams share governance.
- Rollback remains simple.
- Deployment pipelines remain standardized.

Registry complexity grows linearly rather than exponentially.

---

# When This Decision Should Be Revisited

Alternative registry solutions may become appropriate if:

- Enterprise governance requires different tooling
- Organization-wide standards mandate another registry
- Cross-cloud portability changes significantly
- MLflow no longer satisfies operational needs

Until then, MLflow remains the preferred registry implementation.

---

# Trade-off Summary

| Aspect | MLflow Model Registry |
|----------|----------------------|
| Versioning | Excellent |
| Lineage | Excellent |
| Rollback | Excellent |
| Governance | High |
| Portability | High |
| Operational Complexity | Low |
| Startup Suitability | Excellent |

---

# Decision Outcome

The Startup Data & AI Platform standardizes model lifecycle management using MLflow Model Registry.

Every production model is versioned, linked to its originating experiment, governed through standardized workflows, and deployed exclusively from the registry.

This decision establishes a single authoritative source for model management while providing reproducibility, traceability, and controlled promotion from experimentation to production.

---

# References

- ADR-003: SageMaker Training
- ADR-004: MLflow Experiment Tracking
- Deployment Flow
- ML Services Layer
- Governance Documentation

This ADR establishes MLflow Model Registry as the control plane for model lifecycle management across the platform.
