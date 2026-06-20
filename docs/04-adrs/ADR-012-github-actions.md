# ADR-012: GitHub Actions for CI/CD Automation

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform contains multiple components that evolve independently, including:

* Infrastructure
* Data pipelines
* Machine learning code
* Model training pipelines
* APIs
* Monitoring configurations
* Governance policies

Manual deployment of these components introduces:

* Human error
* Inconsistent processes
* Delayed releases
* Configuration drift
* Poor reproducibility

The platform therefore requires a standardized Continuous Integration and Continuous Delivery (CI/CD) solution.

---

# Problem Statement

How should platform changes be validated and deployed so that they are:

* Automated
* Repeatable
* Auditable
* Secure
* Consistent
* Easy for small teams to maintain

while minimizing operational overhead?

---

# Decision

The platform standardizes **GitHub Actions** as the CI/CD automation framework.

Every code change is validated through automated workflows before promotion.

GitHub Actions orchestrates:

* Infrastructure validation
* Terraform planning
* Application testing
* Docker image creation
* Container publishing
* Model deployment pipelines
* Documentation generation

CI/CD becomes a shared platform capability rather than project-specific automation.

---

# Why GitHub Actions Was Chosen

## Native GitHub Integration

Source code already resides in GitHub.

Using GitHub Actions removes the need for additional CI infrastructure.

Repository events automatically trigger workflows.

---

## Fully Managed

No dedicated CI servers require maintenance.

The platform avoids managing:

* Jenkins controllers
* Build agents
* Worker nodes
* Plugin ecosystems

Operational burden remains low.

---

## Workflow as Code

Pipelines are version-controlled alongside application code.

Every workflow becomes:

* Reviewable
* Reproducible
* Auditable

Pipeline changes follow the same engineering process as source code.

---

## Flexible Automation

GitHub Actions supports:

* Build jobs
* Test jobs
* Matrix execution
* Artifact publishing
* Scheduled workflows
* Manual approvals
* Reusable workflows

The platform can standardize delivery across multiple projects.

---

## Cost-Effective

For startup-scale teams, hosted runners provide sufficient capacity without dedicated infrastructure investment.

---

# Alternatives Considered

## Option 1: Manual Deployment

Developers execute deployment steps manually.

### Advantages

* No CI infrastructure

### Disadvantages

* Human error
* Poor reproducibility
* No audit trail
* Slow releases

Rejected.

---

## Option 2: Jenkins

Self-hosted automation server.

### Advantages

* Highly customizable

### Disadvantages

* Requires maintenance
* Plugin management
* Infrastructure overhead

Rejected.

---

## Option 3: GitLab CI

Integrated CI/CD platform.

### Advantages

* Rich features

### Disadvantages

* Repository migration required
* Additional platform complexity

Rejected.

---

## Option 4: GitHub Actions (Selected)

Managed automation tightly integrated with GitHub.

### Advantages

* Native integration
* Minimal operations
* Flexible workflows
* Infrastructure as code

Chosen for the platform.

---

# CI/CD Philosophy

Every change follows the same lifecycle.

```text
Developer
     │
     ▼
Git Push
     │
     ▼
GitHub Actions
     │
     ▼
Validation
     │
     ▼
Build
     │
     ▼
Test
     │
     ▼
Deploy
```

Automation replaces manual execution wherever practical.

---

# Infrastructure Pipeline

Infrastructure changes follow:

```text
Terraform Code
        │
        ▼
Format
        │
        ▼
Validate
        │
        ▼
Static Analysis
        │
        ▼
Plan
        │
        ▼
Approval
        │
        ▼
Apply
```

No infrastructure changes bypass review.

---

# Application Pipeline

Application services follow:

```text
Code
 │
 ▼
Tests
 │
 ▼
Docker Build
 │
 ▼
Push to ECR
 │
 ▼
Deployment
```

Runtime artifacts remain reproducible.

---

# Machine Learning Pipeline

ML projects integrate with CI/CD by validating:

* Code quality
* Unit tests
* Docker images
* Training containers
* Configuration
* Packaging

Production training remains an independent runtime operation.

The CI pipeline validates the ability to train rather than performing expensive training jobs on every commit.

---

# Documentation Pipeline

Documentation is automatically:

* Built
* Validated
* Published

The documentation remains synchronized with the codebase.

---

# Relationship with Terraform

GitHub Actions executes:

* `terraform fmt`
* `terraform validate`
* Static security checks
* `terraform plan`
* Controlled `terraform apply`

Infrastructure changes become predictable and auditable.

---

# Relationship with Docker

Container images are built automatically.

```text
Code
 │
 ▼
Docker Build
 │
 ▼
Container Registry
 │
 ▼
Deployment
```

Every deployed image corresponds to a source revision.

---

# Relationship with Deployment

Deployment pipelines retrieve:

* Approved container images
* Approved model versions
* Immutable artifacts

Promotion becomes deterministic.

---

# Security Considerations

Secrets are managed through:

* GitHub encrypted secrets
* OIDC federation to AWS
* IAM roles
* Least privilege permissions

Long-lived cloud credentials should be avoided whenever possible.

---

# Approval Strategy

Critical environments may require:

* Pull request review
* Manual approval
* Protected branches
* Required status checks

Production changes remain controlled.

---

# Failure Handling

Pipeline failures:

* Block deployment
* Report diagnostics
* Preserve existing production systems
* Require corrective action before promotion

Failed builds never reach production.

---

# Cost Considerations

Hosted runners eliminate dedicated build infrastructure.

Costs scale with workflow execution time.

For startup workloads, this model remains operationally efficient.

---

# Consequences

## Positive Consequences

* Automated validation
* Consistent deployments
* Version-controlled pipelines
* Faster releases
* Reduced human error
* Improved auditability
* Low operational overhead

---

## Negative Consequences

* Dependency on GitHub ecosystem
* Workflow execution limits
* Hosted runner costs for large workloads

These trade-offs align with startup priorities.

---

# Rules Enforced

## Rule 1

Every code change passes through CI.

---

## Rule 2

Infrastructure changes require automated validation.

---

## Rule 3

Docker images are built automatically.

---

## Rule 4

Deployments originate only from approved pipeline outputs.

---

## Rule 5

Production deployments are reproducible.

---

## Rule 6

Pipelines are stored as code within repositories.

---

## Rule 7

Secrets are never hardcoded.

---

## Rule 8

Manual deployment is the exception rather than the default.

---

# Impact on Platform Architecture

## Bootstrap Layer

Establishes repositories and remote state used by CI.

---

## Platform Foundation Layer

Provides registries, storage, and deployment targets consumed by pipelines.

---

## ML Services Layer

Receives validated training containers and deployment artifacts.

---

## Application Layer

Uses standardized delivery workflows without implementing custom automation.

---

# Scalability Implications

As the platform grows:

* Additional repositories reuse common workflows.
* Automation standards remain consistent.
* New services inherit existing pipelines.
* Delivery complexity scales predictably.

---

# Future Evolution

Future enhancements may include:

* Reusable workflow libraries
* Self-hosted runners for specialized workloads
* Multi-environment promotion pipelines
* Security policy enforcement
* Automated release management
* Progressive delivery integration

These capabilities extend the existing CI/CD foundation.

---

# When This Decision Should Be Revisited

Alternative CI/CD platforms should be considered if:

* Repository hosting changes
* Organization-wide standards require different tooling
* Specialized compute requirements exceed hosted runners
* Multi-cloud deployment orchestration becomes necessary

Until then, GitHub Actions remains the preferred automation platform.

---

# Trade-off Summary

| Aspect                    | GitHub Actions |
| ------------------------- | -------------- |
| Operational Complexity    | Low            |
| Native GitHub Integration | Excellent      |
| Automation Capability     | High           |
| Auditability              | Excellent      |
| Reproducibility           | Excellent      |
| Startup Suitability       | Excellent      |
| Infrastructure Overhead   | Minimal        |

---

# Decision Outcome

The Startup Data & AI Platform standardizes GitHub Actions as its CI/CD automation framework.

All infrastructure, application, and platform changes are validated and promoted through version-controlled workflows, ensuring consistent delivery, reproducible builds, and automated quality gates.

By treating CI/CD as a shared platform capability rather than project-specific scripting, the architecture enables rapid iteration while maintaining production-grade engineering standards.

---

# References

* ADR-001: Single AWS Account
* ADR-003: SageMaker Training
* ADR-009: Model Deployment
* ADR-011: Modular Terraform Architecture
* Platform Foundation Layer
* Bootstrap Layer

This ADR establishes GitHub Actions as the standard automation engine for building, validating, and delivering every component of the Startup Data & AI Platform.
