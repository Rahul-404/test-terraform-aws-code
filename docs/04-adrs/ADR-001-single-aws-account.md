# ADR-001: Single AWS Account Strategy

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform is designed for early-stage organizations that need production-grade machine learning capabilities while operating under limited engineering resources and infrastructure budgets.

The expected operating environment includes:

* 3–5 machine learning applications
* 6–10 production models
* Approximately 2,000 daily active users
* A small engineering team
* Limited DevOps and platform staffing
* Strong preference for managed services
* Fast delivery over enterprise-scale complexity

One of the earliest architectural decisions is determining whether the platform should adopt:

* A single AWS account, or
* A multi-account AWS organization

This decision significantly impacts infrastructure complexity, operational overhead, governance, and future scalability.

---

# Problem Statement

How should cloud resources be organized to balance:

* Operational simplicity
* Cost efficiency
* Engineering velocity
* Security
* Future scalability

while remaining appropriate for startup-scale workloads?

---

# Decision

The platform will operate within **a single AWS account**.

Development, staging, and production environments will coexist within the same account while being logically isolated through:

* IAM roles
* Resource tagging
* Naming conventions
* Separate Terraform workspaces or state files
* Environment-specific variables
* Security boundaries where appropriate

This approach intentionally optimizes for simplicity and delivery speed during the startup phase.

---

# Rationale

A single-account strategy offers several advantages for the target operating model.

## Lower Operational Complexity

Only one account must be managed.

This reduces:

* Identity management overhead
* Cross-account permissions
* Networking complexity
* Infrastructure duplication

The platform team can focus on delivering business capabilities instead of maintaining account boundaries.

---

## Faster Engineering Velocity

Developers can provision and test resources without coordinating across multiple accounts.

Deployment pipelines remain simpler because:

* Credentials are centralized
* Resources are directly accessible
* Infrastructure dependencies are easier to manage

This improves iteration speed during rapid product development.

---

## Reduced Cost

Multiple AWS accounts often require duplicated infrastructure.

Examples include:

* VPCs
* NAT Gateways
* Monitoring stacks
* Logging infrastructure
* Shared networking

A single account minimizes unnecessary duplication and reduces startup operating costs.

---

## Simpler Terraform Architecture

Terraform modules can reference shared resources directly.

Examples include:

* Shared networking
* Shared observability
* Shared artifact storage
* Shared IAM roles

Cross-account providers and role assumptions are unnecessary.

---

## Easier Onboarding

New engineers require access to only one account.

Documentation, debugging, and operational procedures remain straightforward.

This is particularly valuable for small platform teams.

---

# Alternatives Considered

## Option 1: Multi-Account Architecture

Separate accounts for:

* Development
* Staging
* Production

### Advantages

* Strong isolation
* Reduced blast radius
* Better compliance
* Independent quotas
* Easier cost separation

### Disadvantages

* Higher complexity
* Cross-account IAM management
* More networking configuration
* Increased Terraform complexity
* Greater maintenance burden

For startup-scale workloads, these costs outweigh the benefits.

---

## Option 2: Separate AWS Accounts Per Team

Each engineering team owns its own account.

### Advantages

* Team autonomy
* Independent governance
* Resource isolation

### Disadvantages

* Significant operational overhead
* Complex shared services
* Difficult platform standardization
* Increased networking challenges

This approach is more suitable for large enterprises.

---

## Option 3: Single Account with Logical Isolation (Selected)

All environments share one account while maintaining separation through configuration and policy.

### Advantages

* Simple operations
* Lower cost
* Faster development
* Minimal infrastructure duplication
* Easy onboarding

### Disadvantages

* Larger blast radius
* Shared quotas
* Weaker isolation
* Compliance limitations

The trade-offs are acceptable given current requirements.

---

# Consequences

## Positive Consequences

* Faster infrastructure provisioning
* Simpler Terraform modules
* Lower operational burden
* Reduced AWS costs
* Easier debugging
* Shared platform services
* Faster experimentation
* Simplified CI/CD pipelines

These benefits directly support startup priorities.

---

## Negative Consequences

The platform accepts several trade-offs.

### Shared Blast Radius

Infrastructure failures may affect multiple environments.

---

### Shared Service Limits

AWS quotas apply across all environments.

Unexpected resource consumption may impact unrelated workloads.

---

### Reduced Isolation

Production resources share the same account as development resources.

Strong IAM policies become increasingly important.

---

### Compliance Limitations

Certain regulatory requirements may recommend or require account-level isolation.

Meeting these requirements may necessitate architectural evolution.

---

# Risk Mitigation

To reduce the impact of operating within a single account, the platform adopts several safeguards.

## Logical Environment Separation

Resources are isolated using:

* Naming conventions
* Tags
* IAM policies
* Separate Terraform state
* Environment variables

---

## Least Privilege Access

Permissions are scoped according to engineering responsibilities.

Applications receive only the access required for operation.

---

## Infrastructure as Code

All infrastructure changes are managed through Terraform.

Manual changes are minimized to improve reproducibility.

---

## Standardized Resource Tagging

Every resource includes metadata such as:

* Environment
* Project
* Owner
* Managed By
* Cost Center

This improves governance and cost visibility.

---

## Monitoring and Auditing

Infrastructure changes and operational events are continuously monitored and logged.

Unexpected behavior can be investigated quickly.

---

# Impact on Platform Design

The single-account strategy influences multiple architectural decisions.

## Networking

A shared VPC can support multiple environments through subnet segmentation.

---

## IAM

Roles are scoped by environment and responsibility rather than account boundaries.

---

## Artifact Storage

Container images, model artifacts, and datasets can be shared more easily.

---

## Observability

Monitoring infrastructure can be centralized rather than duplicated.

---

## CI/CD

Deployment pipelines require fewer credentials and less orchestration.

---

## Platform Services

Reusable capabilities such as experiment tracking and model registry can operate as shared services.

---

# When This Decision Should Be Revisited

This ADR should be reconsidered if any of the following occur:

* Significant team growth
* Multiple independent business units
* Regulatory requirements
* Compliance mandates
* Large increases in infrastructure scale
* Tenant isolation requirements
* Multi-region expansion
* Enterprise security requirements

These conditions may justify migration to a multi-account architecture.

---

# Migration Strategy

Future migration should occur incrementally.

Potential phases include:

1. Separate production into its own account.
2. Introduce shared networking.
3. Configure cross-account IAM roles.
4. Replicate platform services where necessary.
5. Move toward organizational governance.

Because platform capabilities are modular, migration can occur without redesigning applications.

---

# Trade-off Summary

| Aspect                 | Single Account | Multi-Account |
| ---------------------- | -------------- | ------------- |
| Operational Complexity | Low            | High          |
| Infrastructure Cost    | Low            | Higher        |
| Engineering Velocity   | High           | Moderate      |
| Blast Radius           | Larger         | Smaller       |
| Isolation              | Logical        | Physical      |
| Compliance Readiness   | Moderate       | High          |
| Terraform Simplicity   | High           | Lower         |
| Onboarding             | Simple         | More Complex  |

Given the startup assumptions documented for this platform, the selected approach provides the best balance.

---

# Decision Outcome

The platform will adopt a **single AWS account strategy with logical environment isolation**.

This decision prioritizes engineering velocity, operational simplicity, and cost efficiency while accepting manageable trade-offs around isolation and scalability.

The architecture intentionally leaves a clear migration path toward a multi-account strategy when organizational growth or regulatory requirements justify the additional complexity.

---

# References

* Startup Context → `startup-assumptions.md`
* Constraints → `constraints.md`
* Scale Estimation → `scale-estimation.md`
* Architecture Overview → `architecture-overview.md`
* Layered Architecture → `layered-architecture.md`

This ADR provides the rationale for one of the foundational architectural decisions that shapes every subsequent platform capability.
