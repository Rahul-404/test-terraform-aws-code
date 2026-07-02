# ADR-011: Modular Terraform Architecture

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform provisions cloud infrastructure for:

* Networking
* Security
* Storage
* Compute
* Machine learning services
* Monitoring
* Governance
* CI/CD integrations

As the platform grows, infrastructure must remain:

* Reusable
* Testable
* Consistent
* Versioned
* Easy to maintain

Managing infrastructure through large monolithic Terraform configurations would increase duplication and make change management difficult.

The platform therefore requires a modular Infrastructure as Code strategy.

---

# Problem Statement

How should Terraform code be organized so that infrastructure can be:

* Reused across projects
* Independently versioned
* Easily tested
* Composed into larger systems
* Maintained by small engineering teams
* Extended without duplication

while preserving consistency across environments?

---

# Decision

The platform adopts a **modular Terraform architecture**.

Every reusable infrastructure capability is implemented as an independent Terraform module with clearly defined inputs and outputs.

Platform deployments compose these modules rather than duplicating infrastructure definitions.

Infrastructure modules become reusable building blocks for every project.

---

# Why Modular Terraform Was Chosen

## Reusability

Common infrastructure components should be implemented once and reused everywhere.

Examples include:

* VPCs
* IAM roles
* S3 buckets
* SageMaker resources
* Monitoring infrastructure

This minimizes duplication.

---

## Separation of Responsibilities

Each module owns a single infrastructure concern.

For example:

* Networking
* Security
* Storage
* Compute

Changes remain localized.

---

## Easier Maintenance

Updating one module automatically benefits every consumer after version adoption.

Infrastructure becomes easier to evolve.

---

## Consistent Standards

Naming conventions, tagging, encryption, and security policies are enforced centrally through shared modules.

---

## Testability

Individual modules can be validated independently before platform-wide deployment.

Testing becomes practical and repeatable.

---

# Alternatives Considered

## Option 1: Single Monolithic Terraform Project

All resources defined in one configuration.

### Advantages

* Simple initially

### Disadvantages

* Poor reuse
* Difficult maintenance
* High coupling
* Large change surface

Rejected.

---

## Option 2: Copy Infrastructure Between Projects

Duplicate Terraform files for each project.

### Advantages

* Fast initial setup

### Disadvantages

* Drift
* Duplication
* Difficult upgrades
* Inconsistent standards

Rejected.

---

## Option 3: Modular Terraform (Selected)

Reusable infrastructure modules.

### Advantages

* Composable
* Maintainable
* Reusable
* Testable

Chosen for the platform.

---

# Module Philosophy

Each module should represent a single platform capability.

Examples:

```text id="u2w4np"
modules/

├── vpc/
├── iam/
├── s3/
├── ecr/
├── sagemaker/
├── eventbridge/
├── monitoring/
├── mlflow/
└── networking/
```

Modules expose stable interfaces regardless of implementation details.

---

# Module Design Principles

Every module should:

* Have a single responsibility
* Expose explicit inputs
* Expose useful outputs
* Avoid hidden dependencies
* Be independently testable
* Support versioning
* Be idempotent

Modules should remain composable.

---

# Inputs and Outputs

Consumers interact through declared variables.

Example:

```text id="hdf6uq"
Input Variables
        │
        ▼
Terraform Module
        │
        ▼
Outputs
```

Internal implementation details remain encapsulated.

---

# Composition Strategy

Platform deployments assemble infrastructure through module composition.

```text id="f2mqfc"
Bootstrap
     │
     ▼
Network Module
     │
     ▼
Security Module
     │
     ▼
Platform Module
     │
     ▼
ML Services Module
```

No module directly owns unrelated concerns.

---

# Versioning Strategy

Modules are versioned independently.

Example:

```text id="2b2bgj"
network-module

v1.0
v1.1
v2.0
```

Consumers upgrade intentionally rather than automatically.

---

# Environment Reuse

The same module supports:

* Development
* Testing
* Staging
* Production

Behavior changes through configuration rather than code duplication.

---

# Relationship with Layered Architecture

Terraform modules map naturally to platform layers.

Example:

| Layer                   | Example Modules          |
| ----------------------- | ------------------------ |
| Bootstrap               | Backend state, providers |
| Organization & Security | IAM, KMS, Secrets        |
| Network                 | VPC, Subnets, Routing    |
| Connectivity            | VPC Endpoints, DNS       |
| Platform Foundation     | S3, ECR, Logging         |
| Data Platform           | Databases, Storage       |
| ML Services             | SageMaker, MLflow        |
| Application             | APIs, Services           |

Infrastructure reflects architectural boundaries.

---

# Relationship with CI/CD

CI pipelines:

* Validate modules
* Run formatting
* Execute static analysis
* Run tests
* Generate plans

Only approved changes are applied.

Infrastructure changes follow the same engineering standards as application code.

---

# Testing Strategy

Every module should support:

* Validation
* Static analysis
* Unit-style testing
* Integration testing
* Plan verification

Testing occurs before production deployment.

---

# State Management

Terraform state remains centralized.

Requirements include:

* Remote backend
* State locking
* Version protection
* Backup
* Controlled access

State consistency is critical.

---

# Security Considerations

Modules enforce:

* Encryption by default
* Least privilege IAM
* Secure defaults
* Standard tagging
* Auditability

Security should not depend on consumers.

---

# Failure Handling

Module failures:

* Abort deployment
* Preserve existing infrastructure
* Produce deterministic plans
* Avoid partial configuration drift

Infrastructure changes remain predictable.

---

# Consequences

## Positive Consequences

* High reuse
* Clear ownership
* Easier testing
* Consistent infrastructure
* Reduced duplication
* Better scalability
* Simplified maintenance

---

## Negative Consequences

* More initial design effort
* Module version management
* Additional abstraction layer

These trade-offs improve long-term maintainability.

---

# Rules Enforced

## Rule 1

Infrastructure must be implemented through reusable modules.

---

## Rule 2

Modules own one responsibility only.

---

## Rule 3

Modules expose explicit inputs and outputs.

---

## Rule 4

Consumers must not modify module internals.

---

## Rule 5

Shared infrastructure should never be duplicated.

---

## Rule 6

Modules should be independently testable.

---

## Rule 7

Version upgrades are explicit.

---

## Rule 8

Infrastructure changes occur through code review and CI/CD.

---

# Impact on Platform Architecture

## Bootstrap Layer

Creates foundational infrastructure required by all modules.

---

## Platform Foundation Layer

Provides reusable modules for shared services.

---

## ML Services Layer

Consumes infrastructure modules rather than provisioning resources manually.

---

## Application Layer

Deploys onto standardized infrastructure created through composition.

---

# Scalability Implications

As the platform expands:

* New projects reuse existing modules.
* Teams compose infrastructure rapidly.
* Standards remain consistent.
* Maintenance costs grow slowly.

Infrastructure evolves predictably.

---

# Future Evolution

The module ecosystem may later include:

* Internal module registry
* Automated version publishing
* Policy-as-code validation
* Multi-account composition
* Cross-region deployments
* Organization-wide reusable libraries

These enhancements build on the same modular foundation.

---

# When This Decision Should Be Revisited

Alternative approaches should be considered if:

* Infrastructure moves away from Terraform
* Organization-wide platform standards change
* New provisioning technologies replace current workflows

Until then, modular Terraform remains the preferred strategy.

---

# Trade-off Summary

| Aspect                  | Modular Terraform |
| ----------------------- | ----------------- |
| Reusability             | Excellent         |
| Maintainability         | Excellent         |
| Testability             | High              |
| Scalability             | High              |
| Initial Complexity      | Moderate          |
| Operational Consistency | Excellent         |
| Startup Suitability     | Excellent         |

---

# Decision Outcome

The Startup Data & AI Platform standardizes infrastructure provisioning through reusable Terraform modules.

Each module encapsulates a single platform capability with well-defined interfaces, enabling infrastructure to be composed, versioned, tested, and reused across projects and environments.

This decision transforms Infrastructure as Code into a maintainable engineering product rather than a collection of deployment scripts, providing a scalable foundation for long-term platform evolution.

---

# References

* ADR-001: Single AWS Account
* ADR-002: Layered Architecture
* Bootstrap Layer
* Platform Foundation Layer
* ML Services Layer
* CI/CD Documentation

This ADR establishes modular Terraform as the standard approach for provisioning and evolving infrastructure throughout the Startup Data & AI Platform.
