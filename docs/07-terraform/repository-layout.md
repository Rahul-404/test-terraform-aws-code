# Repository Layout

## Purpose

This document defines the Terraform repository structure used across the platform.

The repository layout is designed to support:

* Infrastructure scalability
* Environment isolation
* Module reusability
* Team collaboration
* Deployment safety
* Long-term maintainability

The structure follows Infrastructure as Code (IaC) principles while remaining practical for startup-scale engineering teams.

---

# Design Principles

## Separation of Concerns

Reusable infrastructure logic should be separated from environment-specific configuration.

Benefits:

* Reduced duplication
* Easier maintenance
* Improved consistency

---

## Environment Isolation

Each environment should maintain independent infrastructure configuration.

Benefits:

* Reduced deployment risk
* Safer experimentation
* Independent infrastructure lifecycle

---

## Reusability

Infrastructure patterns should be implemented once and reused across environments.

Examples:

* VPC
* EKS
* S3
* Monitoring
* IAM

---

## Scalability

The repository should support future platform growth without requiring structural redesign.

---

# Repository Structure

The Terraform repository follows the structure below.

```text
terraform/
│
├── modules/
│
├── environments/
│
├── shared/
│
├── scripts/
│
└── docs/
```

Each directory serves a specific purpose.

---

# High-Level Layout

```text
terraform/
│
├── modules/
│   ├── network/
│   ├── eks/
│   ├── s3/
│   ├── ecr/
│   ├── monitoring/
│   └── iam/
│
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
│
├── shared/
│
├── scripts/
│
└── docs/
```

---

# Modules Directory

## Purpose

The modules directory contains reusable infrastructure components.

These modules represent building blocks that can be deployed into multiple environments.

---

## Examples

```text
modules/
│
├── network/
├── eks/
├── s3/
├── ecr/
├── monitoring/
├── iam/
└── mlflow/
```

---

## Module Responsibilities

Each module should:

* Manage a single infrastructure domain
* Expose clearly defined inputs
* Expose useful outputs
* Remain environment agnostic

Example:

```text
modules/eks
```

Should not contain:

```text
❌ dev-specific logic
❌ prod-specific logic
❌ environment names
```

Environment-specific configuration belongs elsewhere.

---

# Environment Directory

## Purpose

The environments directory defines actual deployments.

This layer composes reusable modules into complete infrastructure environments.

---

## Structure

```text
environments/
│
├── dev/
├── staging/
└── prod/
```

Each environment represents a deployable infrastructure boundary.

---

# Environment Layout

Example:

```text
environments/
│
├── dev/
│   ├── network/
│   ├── storage/
│   ├── compute/
│   └── monitoring/
│
├── staging/
│   ├── network/
│   ├── storage/
│   ├── compute/
│   └── monitoring/
│
└── prod/
    ├── network/
    ├── storage/
    ├── compute/
    └── monitoring/
```

This structure aligns with the State Isolation strategy.

---

# Infrastructure Domains

Each infrastructure domain owns a dedicated Terraform state.

Examples:

| Domain     | Responsibility         |
| ---------- | ---------------------- |
| network    | VPC, subnets, routing  |
| storage    | S3, backups            |
| compute    | EKS, EC2               |
| monitoring | Prometheus, Grafana    |
| security   | IAM, security controls |

Benefits:

* Reduced blast radius
* Smaller plans
* Faster deployments
* Easier recovery

---

# Shared Directory

## Purpose

Contains reusable assets shared across environments.

Examples:

```text
shared/
│
├── locals/
├── policies/
├── tags/
└── templates/
```

---

## Typical Contents

### Common Tags

```text
Project
Environment
ManagedBy
Owner
```

---

### IAM Policies

Reusable security policies.

---

### Templates

Shared configuration templates used by multiple modules.

---

# Scripts Directory

## Purpose

Contains automation utilities supporting Terraform workflows.

Examples:

```text
scripts/
│
├── bootstrap.sh
├── validate.sh
├── plan.sh
└── destroy.sh
```

---

## Responsibilities

Examples:

* Environment bootstrapping
* Validation
* CI/CD helpers
* Local developer workflows

Scripts should never replace Terraform functionality.

---

# Documentation Directory

## Purpose

Contains Terraform-specific documentation.

Examples:

```text
docs/
│
├── module-guides/
├── architecture/
└── onboarding/
```

Documentation should evolve alongside infrastructure code.

---

# Example Environment Deployment

The production environment may look like:

```text
prod/
│
├── network/
│
├── storage/
│
├── compute/
│
├── monitoring/
│
└── security/
```

Deployment order:

```text
network
   │
   ▼

storage
   │
   ▼

security
   │
   ▼

compute
   │
   ▼

monitoring
```

This minimizes dependency issues.

---

# Module Consumption Pattern

Environment deployments consume reusable modules.

Example:

```text
modules/
    │
    ▼

Environment Configuration
    │
    ▼

Terraform State
    │
    ▼

Infrastructure
```

This pattern keeps reusable logic separate from deployment configuration.

---

# State Alignment

Repository structure mirrors Terraform state ownership.

Example:

```text
dev/network
```

Owns:

```text
dev-network.tfstate
```

---

```text
prod/compute
```

Owns:

```text
prod-compute.tfstate
```

Benefits:

* Easier troubleshooting
* Clear ownership boundaries
* Simplified recovery

---

# CI/CD Alignment

Repository structure supports infrastructure pipelines.

Example:

```text
Git Commit
     │
     ▼

Terraform Validate
     │
     ▼

Terraform Plan
     │
     ▼

Approval
     │
     ▼

Terraform Apply
```

Changes remain scoped to the affected infrastructure domain.

---

# Example Repository Tree

```text
terraform/
│
├── modules/
│   ├── network/
│   ├── eks/
│   ├── s3/
│   ├── ecr/
│   ├── monitoring/
│   └── iam/
│
├── environments/
│   ├── dev/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── compute/
│   │   └── monitoring/
│   │
│   ├── staging/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── compute/
│   │   └── monitoring/
│   │
│   └── prod/
│       ├── network/
│       ├── storage/
│       ├── compute/
│       └── monitoring/
│
├── shared/
│
├── scripts/
│
└── docs/
```

This structure balances simplicity, scalability, and operational safety.

---

# Anti-Patterns

The following repository structures should be avoided.

### Monolithic Terraform

```text
❌ main.tf

Everything in one directory
```

Problems:

* Large plans
* High blast radius
* Difficult maintenance

---

### Environment-Specific Modules

```text
❌ dev-vpc-module

❌ prod-vpc-module
```

Problems:

* Code duplication
* Maintenance burden

---

### Shared State for Everything

```text
❌ One state file for all resources
```

Problems:

* Risky deployments
* Slow execution
* Difficult recovery

---

# Future Evolution

As the platform grows, the repository may expand to include:

* Additional infrastructure domains
* Multi-account support
* Multi-region deployments
* Shared services infrastructure
* Platform-specific modules

The core structure should remain stable to minimize operational disruption.

---

# Related Documents

* Module Design
* Naming Conventions
* Variable Conventions
* Outputs
* Remote State
* Reusable Patterns

Together, these documents define how Terraform code is organized, maintained, deployed, and evolved across the platform lifecycle.
