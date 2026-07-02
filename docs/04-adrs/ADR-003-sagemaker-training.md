# ADR-003: SageMaker Training for Production Model Training

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform requires a standardized mechanism for executing production machine learning training workloads.

The platform supports multiple applications and models while operating with:

* A single AWS account
* A small platform engineering team
* Limited operational resources
* Moderate training frequency
* Cost-sensitive infrastructure
* Preference for managed services

Data Scientists are expected to perform rapid experimentation locally using their own development environments. However, once an experiment is considered production-worthy, training should execute in a controlled, reproducible, and auditable environment.

The platform therefore requires a dedicated production training capability.

---

# Problem Statement

How should production model training be executed such that it provides:

* Reproducibility
* Scalability
* Standardization
* Auditability
* Resource isolation
* Easy integration with the ML lifecycle

while minimizing infrastructure management overhead?

---

# Decision

The platform will execute production training workloads using **Amazon SageMaker Training Jobs**.

Every production training execution will:

* Run inside a Docker container
* Use immutable training images
* Consume versioned datasets
* Produce versioned artifacts
* Record experiment metadata
* Execute on managed compute
* Integrate with downstream model registration

Local developer machines will **never** be considered production training environments.

---

# Why SageMaker Training Was Chosen

## Managed Compute

SageMaker provisions and terminates compute resources automatically.

The platform does not need to manage:

* EC2 lifecycle
* Auto Scaling Groups
* Instance cleanup
* Job scheduling infrastructure

Operational burden is significantly reduced.

---

## Container-Based Execution

Training logic is packaged as Docker images.

Benefits include:

* Environment consistency
* Dependency isolation
* Version control
* Reproducibility
* Portable execution

Every training run executes the exact same software environment.

---

## Reproducibility

Each training execution is associated with:

* Docker image version
* Git commit
* Dataset version
* Hyperparameters
* Environment configuration
* Generated artifacts

A historical training run can be recreated reliably.

---

## Resource Isolation

Each training job executes independently.

Benefits include:

* Fault isolation
* Independent scaling
* No shared runtime interference
* Simplified debugging

Multiple projects can train simultaneously.

---

## Native AWS Integration

Training jobs integrate naturally with:

* S3
* IAM
* CloudWatch
* EventBridge
* VPC networking
* SageMaker endpoints

The overall platform architecture remains cohesive.

---

# Alternatives Considered

## Option 1: EC2-Based Training

Dedicated EC2 instances execute training scripts.

### Advantages

* Maximum control
* Flexible customization
* Lower service abstraction

### Disadvantages

* Manual infrastructure management
* Capacity planning
* Cleanup complexity
* Scaling challenges
* Operational burden

Rejected.

---

## Option 2: Kubernetes Jobs

Training executes inside Kubernetes clusters.

### Advantages

* Unified orchestration
* Container-native workflows
* Flexible scheduling

### Disadvantages

* Cluster management
* Higher operational complexity
* Networking overhead
* Increased maintenance

Not justified for startup-scale workloads.

---

## Option 3: Local Training Only

Developers train models entirely on laptops or workstations.

### Advantages

* Simple workflow
* No cloud compute cost

### Disadvantages

* Non-reproducible
* Hardware dependent
* Difficult collaboration
* Poor governance
* No centralized tracking

Rejected for production workloads.

---

## Option 4: SageMaker Training Jobs (Selected)

Managed containerized training.

### Advantages

* Managed infrastructure
* Standardized execution
* Automatic provisioning
* Easy scaling
* Native AWS integration
* Strong reproducibility

Chosen for the startup platform.

---

# Training Workflow

Every production training execution follows the same lifecycle.

```text
Developer Experiment
        │
        ▼
Code Commit
        │
        ▼
Build Docker Image
        │
        ▼
Push Image to ECR
        │
        ▼
Trigger SageMaker Training Job
        │
        ▼
Load Versioned Dataset
        │
        ▼
Train Model
        │
        ▼
Store Artifacts in S3
        │
        ▼
Log Experiment
        │
        ▼
Register Model
```

This workflow ensures consistency across projects.

---

# Container Strategy

Every training workload is packaged as an immutable Docker image.

The image contains:

* Source code
* Dependencies
* Runtime environment
* Entry point
* Configuration defaults

The training job receives runtime parameters separately.

This separation enables image reuse across executions.

---

# Dataset Strategy

Training consumes only versioned datasets.

Training should never reference mutable production tables directly.

Inputs include:

* Dataset URI
* Dataset version
* Feature definitions
* Metadata

This guarantees reproducibility.

---

# Artifact Strategy

Training outputs include:

* Trained model
* Metrics
* Evaluation reports
* Feature metadata
* Logs
* Additional artifacts

Artifacts are stored in centralized object storage for downstream consumption.

---

# Experiment Tracking Integration

Every SageMaker job records:

* Parameters
* Metrics
* Dataset version
* Docker image
* Execution time
* Artifacts
* Git revision

Experiment tracking remains independent of compute execution.

---

# Model Registry Integration

Successful training does not automatically imply production readiness.

Models must:

1. Complete evaluation.
2. Pass validation.
3. Be registered.
4. Receive approval.
5. Proceed to deployment.

Training and deployment remain separate lifecycle stages.

---

# Trigger Mechanisms

Training may be initiated through:

* Manual execution
* Scheduled execution
* Drift detection
* Performance degradation
* CI/CD pipelines
* Business events

All triggers invoke the same standardized workflow.

---

# Security Considerations

Training jobs execute using dedicated IAM roles.

Access follows least privilege principles.

Jobs receive only:

* Required datasets
* Required artifact locations
* Required secrets
* Required services

Credentials are never embedded in images.

---

# Cost Considerations

Managed training introduces compute costs but reduces engineering costs.

Optimization strategies include:

* On-demand execution
* Automatic termination
* Right-sized instances
* Scheduled training
* Artifact lifecycle policies

The platform prioritizes operational simplicity over absolute infrastructure minimization.

---

# Failure Handling

Training failures should:

* Preserve logs
* Record execution metadata
* Report failure status
* Trigger notifications
* Avoid model registration

Partial failures must not produce production artifacts.

---

# Consequences

## Positive Consequences

* Standardized execution
* Reproducible training
* Managed infrastructure
* Easy scalability
* Container portability
* Native AWS integration
* Simplified governance

---

## Negative Consequences

* Vendor dependence
* Managed service cost
* Less infrastructure customization
* AWS service quotas

These trade-offs are acceptable for startup requirements.

---

# Rules Enforced

Every production training job must satisfy the following rules.

## Rule 1

Training executes only inside managed containers.

---

## Rule 2

Training consumes versioned datasets.

---

## Rule 3

Training images are immutable.

---

## Rule 4

Every execution is experiment tracked.

---

## Rule 5

Artifacts are stored centrally.

---

## Rule 6

Successful training does not imply deployment.

---

## Rule 7

Model registration is mandatory before production promotion.

---

## Rule 8

Local machines are never production training environments.

---

# Impact on Platform Architecture

The decision influences several platform components.

## ML Services Layer

Provides reusable training capability.

---

## Platform Foundation Layer

Provides container registry, CI/CD, and observability.

---

## Data Platform Layer

Provides versioned datasets.

---

## Application Layer

Consumes trained models without participating in training.

---

# Scalability Implications

As demand increases:

* Multiple training jobs execute concurrently.
* Different projects share the same training infrastructure.
* Compute scales independently of inference.
* New models reuse existing workflows.

The architecture scales horizontally without redesign.

---

# When This Decision Should Be Revisited

Alternative training infrastructure may become appropriate if:

* Large-scale distributed training becomes common
* GPU clusters require custom scheduling
* Multi-cloud support becomes necessary
* Cost optimization outweighs managed simplicity
* Enterprise-specific orchestration is required

Until then, managed training remains the preferred approach.

---

# Trade-off Summary

| Aspect                    | SageMaker Training |
| ------------------------- | ------------------ |
| Operational Complexity    | Low                |
| Reproducibility           | Excellent          |
| Scalability               | High               |
| Infrastructure Management | Minimal            |
| Standardization           | Excellent          |
| Vendor Lock-in            | Moderate           |
| Startup Suitability       | Excellent          |

---

# Decision Outcome

The platform standardizes production model training using Amazon SageMaker Training Jobs.

All production training workloads execute inside immutable Docker containers using versioned datasets and centralized artifact storage while integrating with experiment tracking and model registration.

This decision provides reproducibility, scalability, and operational simplicity that align with the platform's startup-first philosophy while leaving a clear path for future evolution.

---

# References

* ADR-001: Single AWS Account
* ADR-002: Layered Architecture
* Training Flow
* ML Services Layer
* Data Platform Layer
* Startup Assumptions

This ADR establishes the standard mechanism for executing production machine learning training workloads across every project built on the platform.
