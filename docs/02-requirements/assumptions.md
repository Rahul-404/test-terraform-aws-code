# Requirements Assumptions

## Purpose

This document captures the technical and operational assumptions that underpin the functional and non-functional requirements of the Startup Data & AI Platform.

These assumptions define the expected operating conditions under which the platform is designed and help explain why certain architectural and implementation decisions are appropriate.

If any of these assumptions change significantly, the requirements and architecture should be re-evaluated.

---

# Relationship to Startup Assumptions

The assumptions in this document are focused on **platform behavior and engineering workflows**.

They complement, rather than replace, the business-oriented assumptions documented in `01-startup-context/startup-assumptions.md`.

---

# RA-001: Infrastructure is Provisioned as Code

All production infrastructure is assumed to be provisioned and managed through Terraform.

Manual creation of cloud resources is considered exceptional and should not be part of normal operations.

## Impact

* Reproducible environments
* Version-controlled infrastructure
* Automated provisioning

---

# RA-002: Containerized Workloads

All production training and inference workloads are assumed to execute inside standardized container images.

This ensures consistency across environments.

## Impact

* Portable workloads
* Reproducible execution
* Simplified deployment

---

# RA-003: Local Experimentation, Centralized Production

Data Scientists may experiment locally using personal development environments.

However, any model intended for production must be retrained through the standardized platform pipeline.

## Impact

* Reproducibility
* Consistent environments
* Reliable lineage tracking

---

# RA-004: Shared Platform Capabilities

Applications consume shared platform services instead of implementing project-specific infrastructure.

Examples include:

* Experiment tracking
* Model registry
* Training orchestration
* Deployment pipelines
* Monitoring

## Impact

* Reduced duplication
* Easier maintenance
* Consistent workflows

---

# RA-005: Immutable Production Artifacts

Once registered, production artifacts are treated as immutable.

Any modification results in a new version rather than updating an existing artifact.

## Impact

* Traceability
* Safe rollbacks
* Reproducibility

---

# RA-006: Versioned Assets

The following assets are assumed to be versioned:

* Source code
* Datasets
* Features
* Models
* Container images
* Infrastructure

This enables complete lifecycle traceability.

---

# RA-007: Automated Metadata Capture

Metadata should be collected automatically wherever possible.

Examples include:

* Training parameters
* Metrics
* Dataset references
* Model versions
* Artifact locations
* Deployment history

Manual metadata entry should be minimized.

---

# RA-008: Standardized Training Interface

Regardless of project type, training jobs are expected to follow a common execution interface.

Typical inputs include:

* Dataset version
* Feature version
* Training configuration
* Container image
* Hyperparameters

This enables reusable orchestration.

---

# RA-009: Deployment from Registry Only

Production deployments are assumed to originate exclusively from the centralized model registry.

Deploying directly from local artifacts or ad hoc files is outside the supported workflow.

---

# RA-010: Monitoring by Default

Every deployed service is expected to expose metrics, logs, and health information without requiring project-specific implementation.

Observability is considered a platform capability rather than an application responsibility.

---

# RA-011: Retraining Reuses Existing Pipelines

Retraining should invoke the same standardized training pipeline used for initial model development.

Separate retraining implementations should be avoided.

---

# RA-012: Platform APIs Remain Stable

Internal platform interfaces should remain stable across projects.

Implementation details may evolve, but consuming teams should not require significant changes when platform internals are updated.

---

# RA-013: Startup-Scale Traffic

The platform is designed around moderate workloads:

* Approximately 2,000 daily active users
* 3–5 machine learning applications
* 6–10 deployed models
* Low double-digit peak requests per second

Requirements beyond this scale may require architectural evolution.

---

# RA-014: Managed Services Are Preferred

Where practical, managed cloud services are preferred over self-managed alternatives.

The objective is to reduce operational overhead while allowing engineers to focus on business value.

---

# RA-015: Security Is Platform Managed

Authentication, authorization, secret management, and encryption are assumed to be handled through centralized platform mechanisms.

Individual projects should not implement their own security frameworks unless specifically required.

---

# RA-016: Platform Is Internal

The Startup Data & AI Platform is intended for internal engineering teams.

It is not designed as a public multi-tenant service and therefore assumes trusted internal users with role-based access controls.

---

# RA-017: Evolution Over Replacement

The platform is expected to evolve incrementally.

Future enhancements should extend existing capabilities rather than replace them entirely.

Examples include:

* Single account → Multi-account
* Offline feature store → Hybrid feature store
* Managed endpoints → Kubernetes serving
* Basic governance → Advanced policy engines

---

# Assumption Traceability

| Assumption                             | Influences                      |
| -------------------------------------- | ------------------------------- |
| RA-001 Infrastructure as Code          | Terraform Modules, CI/CD        |
| RA-002 Containerized Workloads         | Training, Deployment            |
| RA-003 Centralized Production Training | Experiment Tracking, Governance |
| RA-004 Shared Platform Capabilities    | System Architecture             |
| RA-005 Immutable Artifacts             | Model Registry, Rollbacks       |
| RA-006 Versioned Assets                | Reproducibility, Lineage        |
| RA-007 Automated Metadata              | Governance, Auditability        |
| RA-008 Standardized Training           | Training Capability             |
| RA-009 Deployment from Registry        | Deployment Pipeline             |
| RA-010 Monitoring by Default           | Observability                   |
| RA-011 Reused Retraining Pipeline      | Retraining                      |
| RA-012 Stable Platform APIs            | Application Integration         |
| RA-013 Startup-Scale Traffic           | Scale Estimation                |
| RA-014 Managed Services                | Technology Selection            |
| RA-015 Platform-Managed Security       | IAM and Secrets                 |
| RA-016 Internal Platform               | Access Control Model            |
| RA-017 Evolution Over Replacement      | ADRs and Roadmap                |

---

# When Assumptions Should Be Revisited

These assumptions should be reviewed when:

* Traffic increases significantly
* Multiple AWS accounts are introduced
* Real-time feature serving becomes necessary
* Independent business units require isolation
* Regulatory or compliance requirements change
* Platform consumers expand beyond internal teams
* New operational constraints emerge

Revisiting assumptions ensures that requirements and architecture continue to reflect actual business needs.

---

# Summary

The assumptions documented here establish the technical foundation for the platform requirements and architecture.

By making these expectations explicit, the platform remains easier to reason about, easier to evolve, and easier to validate as organizational needs grow.

Whenever an assumption changes, its downstream impact on requirements, architecture, and implementation should be assessed before introducing new capabilities.
