# Constraints

## Purpose

This document defines the business, technical, operational, and organizational constraints that shape the architecture of the Startup Data & AI Platform.

Unlike assumptions, which describe the expected operating environment, constraints represent conditions that the platform must satisfy or work within.

Every major architectural decision should be justifiable by one or more of the constraints documented here.

---

# Why Constraints Matter

Engineering is the process of making trade-offs under constraints.

Without constraints, every problem can be solved by adding more infrastructure, more services, or more complexity.

The purpose of this document is to establish realistic boundaries so that the resulting architecture is:

* Cost-effective
* Maintainable
* Operable by a small team
* Appropriate for startup scale
* Evolvable as requirements change

---

# Business Constraints

## C-01: Limited Budget

The platform must operate within the financial constraints of a startup.

Infrastructure choices should prioritize operational efficiency and managed services over expensive custom solutions.

### Implications

* Prefer managed AWS services
* Avoid over-provisioning
* Share infrastructure where practical
* Optimize idle resource costs
* Minimize operational headcount

---

## C-02: Rapid Delivery

Engineering teams must be able to deliver new machine learning products quickly.

Platform decisions should reduce development time rather than maximize architectural sophistication.

### Implications

* Favor standardization
* Automate repetitive workflows
* Provide reusable templates
* Minimize manual provisioning

---

## C-03: Small Engineering Team

The platform is expected to be operated by a small group of engineers.

The infrastructure should not require dedicated specialists for routine maintenance.

### Implications

* Low operational overhead
* Infrastructure as Code
* Managed services preferred
* Automated deployments
* Self-service capabilities

---

# Organizational Constraints

## C-04: Shared Internal Platform

The platform serves multiple internal teams rather than a single project.

Capabilities should be reusable and standardized across applications.

### Implications

* Platform-first design
* Shared services
* Common interfaces
* Central governance
* Consistent onboarding

---

## C-05: Separation of Responsibilities

Different user groups have different responsibilities.

For example:

* Data Engineers build data pipelines.
* Data Scientists develop models.
* ML Engineers productionize models.
* MLOps Engineers automate operations.
* Platform Engineers manage infrastructure.
* Data Analysts consume curated datasets.

The platform should reinforce these boundaries rather than blur them.

---

# Cloud Constraints

## C-06: Single Cloud Provider

AWS is the only supported cloud provider.

Multi-cloud support is intentionally excluded.

### Implications

* Native AWS integrations
* AWS IAM
* AWS networking
* AWS managed services

---

## C-07: Single AWS Account

The entire platform initially operates within a single AWS account.

Environment isolation should rely on logical boundaries rather than account boundaries.

### Implications

* Shared blast radius
* Shared quotas
* Shared IAM namespace
* Simpler management
* Lower cost

Future migration to multi-account architecture should remain possible.

---

# Infrastructure Constraints

## C-08: Managed Services Preferred

The platform should prefer managed infrastructure whenever it significantly reduces operational complexity.

Examples include:

* SageMaker
* S3
* EventBridge
* CloudWatch
* IAM

The platform should avoid self-hosted alternatives unless there is a measurable business benefit.

---

## C-09: Infrastructure as Code

No production infrastructure should be created manually.

All infrastructure must be reproducible using Terraform.

### Implications

* Version control
* Peer review
* Automated provisioning
* Repeatable environments

---

## C-10: Reusable Platform Modules

Infrastructure should be implemented as reusable modules rather than project-specific resources.

Applications consume platform capabilities instead of provisioning infrastructure independently.

---

# Data Constraints

## C-11: Data is a Shared Asset

Datasets and features should be reusable across multiple applications.

Duplicate pipelines and duplicate feature definitions should be avoided whenever possible.

---

## C-12: Offline Feature Serving

The initial platform only requires offline feature generation.

Real-time feature retrieval is outside the current scope.

### Implications

* Batch processing
* Simpler architecture
* Lower operational cost

Online feature stores may be introduced in future iterations.

---

# Machine Learning Constraints

## C-13: Reproducible Training

Every production training execution must be reproducible.

Training should capture:

* Code version
* Dataset version
* Hyperparameters
* Artifacts
* Metrics
* Environment configuration

No production model should depend on local developer state.

---

## C-14: Standardized Experiment Tracking

Every experiment should be tracked consistently across projects.

Tracking should occur automatically as part of the training workflow.

---

## C-15: Mandatory Model Registration

Every deployed model must originate from the centralized model registry.

Direct deployment from local artifacts is prohibited.

This ensures traceability and governance.

---

# Operational Constraints

## C-16: Automation First

Manual operational work should be minimized.

The platform should automate:

* Training
* Deployment
* Monitoring
* Retraining
* Infrastructure provisioning

Human intervention should be reserved for approvals and exceptional situations.

---

## C-17: Observable by Default

Every platform capability should expose logs, metrics, and health information.

Operational visibility should not require custom instrumentation for every project.

---

## C-18: Standardized Deployments

Every deployed model should follow the same deployment workflow.

Project-specific deployment pipelines should be avoided unless technically necessary.

---

# Security Constraints

## C-19: Least Privilege

Access should follow least-privilege principles wherever practical.

Users and services should receive only the permissions required to perform their responsibilities.

---

## C-20: Encryption

Sensitive information should be protected through:

* Encryption at rest
* Encryption in transit
* Managed secret storage

Security should be built into the platform rather than added later.

---

## C-21: Internal Platform

The platform is intended for internal engineering teams.

It is not designed as a public multi-tenant SaaS platform.

This simplifies authentication, authorization, and governance requirements.

---

# Scalability Constraints

## C-22: Startup Scale

The architecture targets:

* 3–5 ML applications
* 6–10 deployed models
* Approximately 2,000 daily active users
* Moderate training frequency

Premature optimization for enterprise workloads is intentionally avoided.

---

## C-23: Evolution Without Rewrite

The platform should evolve incrementally.

Future requirements should be addressed by extending existing capabilities rather than replacing the entire architecture.

Examples include:

* Single account → Multi-account
* Offline features → Hybrid feature store
* SageMaker endpoints → Kubernetes serving
* Basic governance → Advanced policy engines

---

# Documentation Constraint

## C-24: Decisions Must Be Traceable

Every significant architectural decision should reference one or more documented constraints.

This ensures that technology choices are driven by business needs rather than personal preference.

For example:

| Decision             | Driven By        |
| -------------------- | ---------------- |
| Single AWS Account   | C-01, C-03, C-07 |
| SageMaker Training   | C-03, C-08       |
| Shared Feature Store | C-10, C-11       |
| MLflow Registry      | C-13, C-15       |
| Terraform Modules    | C-09, C-10       |

---

# Summary

The constraints defined in this document intentionally shape the platform toward simplicity, standardization, automation, and maintainability.

Rather than attempting to solve every possible future problem, the platform focuses on satisfying today's business requirements while preserving clear evolution paths as the organization grows.

Every Architecture Decision Record, infrastructure module, and platform capability documented in this repository should be explainable in terms of these constraints.
