# ADR-002: Layered Architecture

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform is intended to support multiple machine learning and AI applications while minimizing duplicated infrastructure and operational complexity.

The platform must provide reusable capabilities such as:

- Data ingestion
- Experiment tracking
- Model training
- Feature management
- Model registry
- Deployment
- Monitoring
- Governance

while simultaneously allowing independent business applications to evolve without modifying core platform components.

Without a clear architectural structure, responsibilities become mixed, services become tightly coupled, and platform evolution becomes increasingly difficult.

---

# Problem Statement

How should responsibilities be organized so that:

- Infrastructure remains reusable
- Business applications remain independent
- Machine learning capabilities are standardized
- Platform evolution is predictable
- Teams can work with clear ownership boundaries

while avoiding duplicated implementations across projects?

---

# Decision

The platform adopts a **layered architecture**.

Each layer owns a well-defined set of responsibilities and exposes capabilities to higher layers while depending only on lower layers.

The architecture consists of the following layers:

1. Bootstrap Layer
2. Organization & Security Layer
3. Network Layer
4. Connectivity Layer
5. Platform Foundation Layer
6. Data Platform Layer
7. ML Services Layer
8. Application Layer
9. Consumer Layer

Every platform component belongs to exactly one layer.

---

# Architectural Principles

## Separation of Concerns

Each layer has a single primary responsibility.

For example:

- Network infrastructure belongs to the Network Layer.
- Datasets belong to the Data Platform Layer.
- Model lifecycle belongs to the ML Services Layer.
- Business logic belongs to the Application Layer.

Responsibilities should not overlap.

---

## Downward Dependencies Only

A layer may consume capabilities only from layers beneath it.

```text
Consumer
    │
    ▼
Application
    │
    ▼
ML Services
    │
    ▼
Data Platform
    │
    ▼
Platform Foundation
    │
    ▼
Connectivity
    │
    ▼
Network
    │
    ▼
Organization & Security
    │
    ▼
Bootstrap
```

Reverse dependencies are prohibited.

---

## Stable Contracts

Higher layers should depend on interfaces rather than implementation details.

Examples:

- Applications request predictions rather than invoking training logic.
- ML Services consume versioned datasets rather than raw storage.
- Consumers call application APIs rather than platform internals.

Implementations may change without affecting consumers.

---

## Reusability

Platform capabilities should be implemented once and reused by multiple projects.

Examples include:

- Experiment tracking
- Model registry
- Training pipelines
- Monitoring
- Governance

Applications consume these services instead of creating project-specific implementations.

---

## Independent Evolution

Each layer should evolve without requiring redesign of unrelated layers.

For example:

- Switching experiment tracking tools should not affect business applications.
- Replacing storage technology should not require changes to consumers.
- Introducing online features should not modify networking architecture.

---

# Why a Layered Architecture Was Chosen

The layered approach provides several advantages.

## Clear Ownership

Every capability has an obvious owner.

This simplifies maintenance and onboarding.

---

## Reduced Coupling

Applications do not depend directly on infrastructure.

Machine learning services do not depend on user interfaces.

Changes remain localized.

---

## Higher Reuse

Shared capabilities are implemented once.

Multiple projects can use:

- Shared training
- Shared deployment
- Shared governance
- Shared monitoring

without duplication.

---

## Easier Scaling

Each layer can scale independently according to demand.

For example:

- More inference traffic affects Applications.
- Larger datasets affect the Data Platform.
- More experiments affect ML Services.

Scaling decisions become targeted rather than global.

---

## Better Documentation

Architecture diagrams naturally align with layer boundaries.

This improves communication across engineering teams.

---

# Alternatives Considered

## Option 1: Monolithic Platform

All responsibilities implemented together.

### Advantages

- Simple initial implementation
- Fewer services

### Disadvantages

- Tight coupling
- Difficult maintenance
- Poor scalability
- Limited reuse

Rejected.

---

## Option 2: Pure Microservices

Every capability implemented as an independent service.

### Advantages

- Fine-grained ownership
- Independent deployment

### Disadvantages

- Excessive operational complexity
- Difficult orchestration
- Significant networking overhead
- Too costly for startup scale

Rejected.

---

## Option 3: Layered Architecture (Selected)

Responsibilities grouped by abstraction level.

### Advantages

- Clear ownership
- Controlled dependencies
- High reuse
- Modular evolution
- Simpler governance

Chosen for this platform.

---

# Layer Responsibilities

## Bootstrap Layer

Owns Terraform backend and infrastructure bootstrapping.

---

## Organization & Security Layer

Owns IAM, security policies, encryption, and identity.

---

## Network Layer

Owns networking infrastructure.

---

## Connectivity Layer

Owns service communication and traffic flow.

---

## Platform Foundation Layer

Owns reusable operational capabilities such as:

- CI/CD
- Observability
- Artifact management
- Configuration
- Notifications

---

## Data Platform Layer

Owns:

- Datasets
- ETL
- Metadata
- Validation
- Lineage

---

## ML Services Layer

Owns:

- Experiment tracking
- Feature store
- Training
- Registry
- Deployment
- Monitoring
- Retraining
- Governance

---

## Application Layer

Owns:

- Business logic
- APIs
- Domain workflows

---

## Consumer Layer

Owns:

- External interaction
- Users
- Systems
- Clients

---

# Consequences

## Positive Consequences

- Clear service ownership
- Easier onboarding
- Consistent architecture
- Higher reuse
- Easier maintenance
- Platform standardization
- Better scalability

---

## Negative Consequences

- Additional abstraction
- Initial design effort
- Documentation requirements
- Strict dependency enforcement

These costs are acceptable given the long-term benefits.

---

# Rules Enforced

Every implementation should satisfy the following rules.

## Rule 1

Business logic belongs only in the Application Layer.

---

## Rule 2

Model lifecycle belongs only in the ML Services Layer.

---

## Rule 3

Dataset management belongs only in the Data Platform Layer.

---

## Rule 4

Operational tooling belongs only in the Platform Foundation Layer.

---

## Rule 5

Infrastructure provisioning belongs only in lower infrastructure layers.

---

## Rule 6

Consumers never bypass the Application Layer.

---

## Rule 7

Layers communicate only through defined contracts.

---

## Rule 8

A layer must never depend on a higher layer.

---

# Impact on Development

Every new project follows the same pattern.

For example:

```text
Consumer
      │
      ▼
Heart Stroke API
      │
      ▼
Prediction Service
      │
      ▼
Feature Store
      │
      ▼
Versioned Dataset
```

The project reuses platform capabilities instead of implementing them again.

---

# Impact on Terraform

Infrastructure modules mirror architectural layers.

Example:

```text
terraform/
├── bootstrap/
├── organization-security/
├── network/
├── connectivity/
├── platform-foundation/
├── data-platform/
├── ml-services/
└── applications/
```

This alignment improves maintainability and ownership.

---

# Scalability Implications

As the organization grows:

- Additional applications reuse existing ML services.
- New ML projects reuse existing data pipelines.
- Infrastructure evolves independently.
- Platform capabilities expand without affecting consumers.

Layer boundaries remain stable even as implementations change.

---

# When This Decision Should Be Revisited

The layered architecture should be reconsidered only if:

- Platform responsibilities fundamentally change
- Domain boundaries become incorrect
- Independent product lines require separate platforms
- Organizational structure changes significantly

Otherwise, evolution should occur within layers rather than replacing the architecture.

---

# Trade-off Summary

| Aspect | Layered Architecture |
|----------|---------------------|
| Separation of Concerns | Excellent |
| Reusability | High |
| Scalability | High |
| Maintainability | High |
| Initial Complexity | Moderate |
| Documentation Effort | Moderate |
| Long-term Flexibility | Excellent |

---

# Decision Outcome

The Startup Data & AI Platform adopts a layered architecture with strict ownership boundaries and downward-only dependencies.

Each layer provides reusable capabilities to higher layers while maintaining clear responsibility for its own state and interfaces.

This architecture balances startup simplicity with long-term extensibility, enabling multiple applications to share common infrastructure and machine learning services without introducing unnecessary coupling.

---

# References

- Architecture Overview
- Layered Architecture
- Service Boundaries
- Data Flow
- Request Flow
- Training Flow
- Deployment Flow

This ADR defines the structural foundation upon which every platform capability and application is built.
