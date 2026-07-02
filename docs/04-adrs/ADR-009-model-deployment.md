# ADR-009: Standardized Model Deployment Strategy

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform supports multiple machine learning applications that require reliable and repeatable model deployment.

After a model has been:

* Trained
* Evaluated
* Registered
* Approved

it must be exposed as a production inference service.

The deployment mechanism should provide:

* Consistent interfaces
* Reproducible deployments
* Simple rollback
* Managed scaling
* Operational visibility
* Low maintenance overhead

while remaining suitable for startup-scale workloads.

---

# Problem Statement

How should production models be deployed so that:

* Every deployment is standardized
* Models can be updated safely
* Rollbacks are simple
* Infrastructure is reusable
* Applications remain independent of deployment details
* Platform engineers can manage deployments centrally

without introducing unnecessary operational complexity?

---

# Decision

The platform standardizes model deployment using **containerized inference services hosted on Amazon SageMaker Endpoints**.

Every production deployment follows the same workflow:

1. Retrieve an approved model version from the Model Registry.
2. Fetch associated artifacts from the Artifact Store.
3. Deploy the model as a Docker container.
4. Expose inference through a managed endpoint.
5. Monitor health and performance continuously.

Applications interact only with the prediction API and never with model artifacts directly.

---

# Why SageMaker Endpoints Were Chosen

## Managed Infrastructure

AWS provisions and manages inference infrastructure.

The platform avoids managing:

* EC2 instances
* Auto Scaling Groups
* Load balancers
* Container orchestration
* Health monitoring infrastructure

---

## Container-Based Serving

Inference executes inside immutable Docker images.

Benefits include:

* Environment consistency
* Dependency isolation
* Portable deployments
* Reproducible runtime behavior

---

## Native AWS Integration

Endpoints integrate naturally with:

* IAM
* CloudWatch
* S3
* EventBridge
* SageMaker Training
* VPC networking

The deployment architecture remains cohesive.

---

## Automatic Scaling

Inference capacity scales according to traffic.

The platform does not require manual provisioning for moderate workload growth.

---

## Operational Simplicity

Platform engineers focus on model lifecycle rather than infrastructure management.

---

# Alternatives Considered

## Option 1: Self-Managed EC2 Services

Deploy inference servers directly on EC2.

### Advantages

* Maximum control
* Flexible customization

### Disadvantages

* Infrastructure management
* Scaling complexity
* Higher operational burden

Rejected.

---

## Option 2: Kubernetes-Based Serving

Deploy models using Kubernetes and KServe or similar tooling.

### Advantages

* Cloud portability
* Advanced traffic management

### Disadvantages

* Cluster management
* Higher operational complexity
* Excessive for startup workloads

Rejected.

---

## Option 3: Serverless Functions

Deploy inference through Lambda.

### Advantages

* Serverless operations

### Disadvantages

* Cold starts
* Runtime limitations
* Poor suitability for larger ML models

Rejected.

---

## Option 4: SageMaker Endpoints (Selected)

Managed containerized inference.

### Advantages

* Managed infrastructure
* Autoscaling
* Native integration
* Simplified operations

Chosen for the platform.

---

# Deployment Lifecycle

Every production deployment follows a standardized lifecycle.

```text
MLflow Model Registry
          │
          ▼
Approved Version
          │
          ▼
Artifact Store (S3)
          │
          ▼
Deployment Pipeline
          │
          ▼
SageMaker Endpoint
          │
          ▼
Prediction API
```

No deployment bypasses the registry.

---

# Relationship with Model Registry

The deployment system always retrieves models from the registry.

Training outputs are never deployed directly.

```text
Training
    │
    ▼
Registry
    │
    ▼
Deployment
```

This guarantees governance and reproducibility.

---

# Relationship with Artifact Storage

The registry stores metadata.

Artifacts remain in S3.

Deployment retrieves artifacts through immutable references.

```text
Registry
    │
Artifact URI
    │
    ▼
Amazon S3
    │
    ▼
Deployment
```

---

# Container Strategy

Inference images are immutable.

Each deployment specifies:

* Docker image version
* Model artifact version
* Runtime configuration
* Environment variables

Configuration changes create new deployments rather than modifying running containers.

---

# API Standardization

All deployed models expose a common interface.

Typical contract:

```text
POST /predict

Input:
{
  "features": { ... }
}

Output:
{
  "prediction": ...
}
```

Applications consume prediction services without model-specific infrastructure knowledge.

---

# Version Management

Each deployment references a specific registered model version.

Example:

```text
HeartStrokeModel

v5 → Production
v4 → Rollback Candidate
v3 → Archived
```

Deployments remain reproducible over time.

---

# Rollback Strategy

Rollback simply redeploys a previously approved version.

```text
Current Endpoint
        │
        ▼
Rollback
        │
        ▼
Previous Registered Version
```

Retraining is not required.

---

# Blue-Green and Progressive Delivery

The initial platform supports full replacement deployments.

Future enhancements may introduce:

* Blue-green deployments
* Canary releases
* Shadow deployments
* Weighted traffic routing

These capabilities can be added without changing application interfaces.

---

# Security Considerations

Endpoints execute with dedicated IAM roles.

Access follows least privilege principles.

Applications authenticate through standardized APIs rather than accessing model artifacts directly.

---

# Monitoring Integration

Every deployment emits operational metrics including:

* Request count
* Latency
* Error rate
* Availability
* Resource utilization

Machine learning metrics such as drift and prediction distributions are monitored separately.

---

# Failure Handling

If deployment fails:

* Existing production endpoints remain active.
* New versions are not promoted.
* Rollback remains available.
* Alerts are generated.

Failed deployments must never interrupt production traffic.

---

# Cost Considerations

Managed endpoints incur ongoing infrastructure costs.

Startup optimization strategies include:

* Autoscaling
* Right-sized instances
* Scheduled endpoint shutdown (where appropriate)
* Shared inference infrastructure for low-volume workloads

Operational simplicity is prioritized over maximal cost optimization.

---

# Consequences

## Positive Consequences

* Standardized deployments
* Managed infrastructure
* Easy rollback
* Consistent APIs
* Reproducible runtime
* Centralized governance
* Simplified operations

---

## Negative Consequences

* AWS dependency
* Managed service costs
* Less flexibility than self-hosted infrastructure

These trade-offs align with startup priorities.

---

# Rules Enforced

## Rule 1

Every production deployment originates from the Model Registry.

---

## Rule 2

Applications never deploy models directly.

---

## Rule 3

Inference executes inside immutable containers.

---

## Rule 4

Deployments reference immutable artifact versions.

---

## Rule 5

Rollback uses previously approved model versions.

---

## Rule 6

Production endpoints expose standardized prediction interfaces.

---

## Rule 7

Deployment and training remain independent lifecycle stages.

---

## Rule 8

All deployments are observable and monitored.

---

# Impact on Platform Architecture

## ML Services Layer

Owns deployment capabilities and endpoint lifecycle.

---

## Platform Foundation Layer

Provides infrastructure, networking, and observability.

---

## Data Platform Layer

Supplies features and datasets consumed before deployment.

---

## Application Layer

Consumes prediction APIs without awareness of deployment mechanics.

---

# Scalability Implications

As the platform grows:

* Multiple models reuse identical deployment workflows.
* New projects inherit standardized infrastructure.
* Scaling policies remain centralized.
* Rollback procedures remain consistent.

Deployment complexity grows predictably.

---

# Future Evolution

As business requirements evolve, the deployment capability may expand to support:

* Multi-model endpoints
* GPU inference
* Real-time A/B testing
* Canary releases
* Multi-region deployments
* Kubernetes-based serving
* Edge inference

These enhancements build upon the same deployment abstraction.

---

# When This Decision Should Be Revisited

Alternative serving strategies should be considered when:

* Traffic exceeds managed endpoint economics
* Multi-cloud deployment becomes mandatory
* Ultra-low latency requirements emerge
* Complex traffic routing is required
* Organization-wide Kubernetes adoption occurs

Until then, managed endpoints remain the preferred deployment strategy.

---

# Trade-off Summary

| Aspect                 | SageMaker Endpoints |
| ---------------------- | ------------------- |
| Operational Complexity | Low                 |
| Reproducibility        | Excellent           |
| Autoscaling            | High                |
| Rollback               | Excellent           |
| AWS Integration        | Excellent           |
| Flexibility            | Moderate            |
| Startup Suitability    | Excellent           |

---

# Decision Outcome

The Startup Data & AI Platform standardizes production model deployment using containerized Amazon SageMaker Endpoints.

Models are deployed exclusively from approved registry versions, retrieve immutable artifacts from centralized storage, expose standardized prediction APIs, and remain fully observable throughout their lifecycle.

This decision separates deployment from training, centralizes operational responsibility within the platform, and provides a scalable foundation that supports current startup needs while enabling future enhancements such as progressive delivery and advanced traffic management.

---

# References

* ADR-003: SageMaker Training
* ADR-005: MLflow Model Registry
* ADR-006: Amazon S3 Artifact Storage
* Deployment Flow
* ML Services Layer
* Platform Foundation Layer

This ADR establishes deployment as a reusable platform capability and defines the standard mechanism for promoting approved machine learning models into production.
