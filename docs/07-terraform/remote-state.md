# Remote State

## Purpose

This document defines how Terraform state is stored, secured, accessed, and managed across the platform.

Terraform state is the source of truth for infrastructure resources managed by Terraform.

The remote state strategy provides:

* Team collaboration
* State durability
* State locking
* Disaster recovery support
* Environment isolation
* Operational safety

Local Terraform state files are not used for shared infrastructure deployments.

---

# Why Remote State Exists

Terraform maintains infrastructure state in a state file.

The state file tracks:

* Managed resources
* Resource attributes
* Resource dependencies
* Terraform metadata

Without state, Terraform cannot safely determine:

```text id="z7p4xq"
What exists

What changed

What should be created

What should be destroyed
```

---

# Design Principles

## Single Source of Truth

Infrastructure state should exist in exactly one authoritative location.

Benefits:

* Consistency
* Predictability
* Reduced conflicts

---

## Durability

State must survive:

* Machine failures
* Developer workstation loss
* CI/CD failures
* Infrastructure incidents

---

## Security

State files may contain sensitive information.

Examples:

```text id="m5n7ya"
Resource IDs

Endpoints

Configuration Data

Infrastructure Metadata
```

State must be protected accordingly.

---

## Isolation

Each environment and infrastructure domain should maintain independent state.

Benefits:

* Reduced blast radius
* Faster deployments
* Easier recovery

---

## Locking

Only one Terraform operation should modify a state at a time.

Benefits:

* Prevents corruption
* Avoids race conditions
* Improves deployment safety

---

# State Architecture

The platform uses a remote backend architecture.

```text id="v9k3qt"
Terraform
     │
     ▼

Remote Backend
     │
     ▼

State Storage
```

State is never committed to source control.

---

# Backend Strategy

The platform uses:

```text id="n8r1yp"
S3
 +
DynamoDB Locking
```

Components:

| Component  | Purpose          |
| ---------- | ---------------- |
| S3         | State Storage    |
| DynamoDB   | State Locking    |
| IAM        | Access Control   |
| Versioning | Recovery Support |

---

# State Storage Architecture

```text id="x4f8hm"
Terraform
      │
      ▼

S3 Backend
      │
      ▼

State Versioning
```

Benefits:

* Durable storage
* Historical versions
* Recovery support

---

# State Locking

Concurrent Terraform executions are prevented through locking.

Architecture:

```text id="w2r5cz"
Terraform Apply
        │
        ▼

Acquire Lock
        │
        ▼

Modify State
        │
        ▼

Release Lock
```

Benefits:

* Prevents corruption
* Prevents overlapping deployments
* Improves operational safety

---

# State Isolation Strategy

State files align with environment boundaries.

Example:

```text id="q8u1vl"
dev
staging
prod
```

Each environment maintains separate state.

---

Example:

```text id="f7d3ks"
dev-network.tfstate

staging-network.tfstate

prod-network.tfstate
```

This aligns with the Environment Strategy document.

---

# Domain-Based State Isolation

Each infrastructure domain owns an independent state.

Examples:

```text id="g9r4ow"
network

compute

storage

monitoring

security
```

---

Example layout:

```text id="m6p8vc"
dev-network.tfstate

dev-storage.tfstate

dev-compute.tfstate

dev-monitoring.tfstate
```

Benefits:

* Smaller plans
* Faster execution
* Reduced risk

---

# State Ownership

Each state should have a clearly defined ownership boundary.

Example:

```text id="h4v7kb"
network state
```

Owns:

```text id="z1m9fw"
VPC

Subnets

Routing

NAT
```

---

Example:

```text id="u8n3pt"
compute state
```

Owns:

```text id="b5r2dx"
EKS

Node Groups

Compute Resources
```

Resources should never be managed by multiple states.

---

# State Naming Convention

Pattern:

```text id="s9j6rw"
<environment>-<domain>.tfstate
```

Examples:

```text id="y3f8ol"
dev-network.tfstate

dev-compute.tfstate

staging-monitoring.tfstate

prod-storage.tfstate
```

Benefits:

* Consistency
* Discoverability
* Easier troubleshooting

---

# State Access Control

Access to Terraform state should be restricted.

Principles:

* Least privilege
* Environment separation
* Auditable access

---

Examples:

| Role              | Access                  |
| ----------------- | ----------------------- |
| Platform Engineer | Read/Write              |
| CI/CD Pipeline    | Read/Write              |
| Developer         | Read Only (if required) |

---

# Sensitive Data Considerations

Terraform state may contain:

```text id="d5w7qa"
Database Endpoints

IAM Metadata

Network Configuration

Resource Attributes
```

Because of this:

* State storage must be encrypted
* Access must be restricted
* Auditing should be enabled

---

# State Encryption

State storage should use encryption at rest.

Example:

```text id="x7k1ps"
Terraform State
       │
       ▼

Encrypted Storage
```

Benefits:

* Improved security
* Reduced exposure risk

---

# State Versioning

Versioning must be enabled for state storage.

Benefits:

* Recovery from accidental changes
* Rollback support
* Disaster recovery

---

Recovery example:

```text id="t2m6dy"
Current State
      │
      ▼

Previous Version
      │
      ▼

Restore
```

---

# Remote State Consumption

Some infrastructure domains require outputs from other states.

Example:

```text id="q1p9uv"
Network State
      │
      ▼

vpc_id

private_subnet_ids

      │
      ▼

Compute State
```

Pattern:

```text id="r8f5kx"
Remote State
       │
       ▼

Outputs
       │
       ▼

Consumer State
```

---

# Allowed Remote State Usage

Acceptable examples:

```text id="w4v3mn"
Network → Compute

Network → Monitoring

Network → Security
```

These represent clear infrastructure dependencies.

---

# Avoiding State Coupling

Remote state dependencies should remain limited.

Avoid:

```text id="o9n7cx"
State A → State B

State B → State C

State C → State D

State D → State E
```

Long dependency chains increase complexity.

---

Preferred:

```text id="v5t8pr"
Network
    │
    ├── Compute

    ├── Monitoring

    └── Security
```

---

# CI/CD Integration

Terraform pipelines interact directly with remote state.

Deployment workflow:

```text id="e7n2ku"
Git Commit
      │
      ▼

Terraform Validate
      │
      ▼

Terraform Plan
      │
      ▼

State Lock
      │
      ▼

Terraform Apply
      │
      ▼

State Update
```

State locking protects concurrent deployments.

---

# Disaster Recovery

Terraform state is considered a critical platform asset.

Recovery capabilities include:

* State versioning
* Backup retention
* Controlled restoration
* Auditability

---

Recovery process:

```text id="p4r8nm"
State Corruption
       │
       ▼

Version Restore
       │
       ▼

Terraform Validation
```

---

# Bootstrap Problem

Remote state infrastructure must exist before Terraform can use it.

Bootstrap resources include:

```text id="l8f2qc"
State Bucket

Lock Table

IAM Policies
```

These are created through a controlled bootstrap process.

---

# State Lifecycle

Typical lifecycle:

```text id="n7m3wo"
Create State
      │
      ▼

Manage Infrastructure
      │
      ▼

Version Updates
      │
      ▼

Archive
```

State should remain associated with the infrastructure it manages.

---

# Anti-Patterns

## Local State

```text id="j2q8pu"
❌ terraform.tfstate
stored on engineer laptop
```

Problems:

* No collaboration
* No durability
* No locking

---

## Shared Monolithic State

```text id="h6v4zr"
❌ Entire platform
in one state file
```

Problems:

* Large blast radius
* Slow plans
* Difficult recovery

---

## State in Git

```text id="w3f7ny"
❌ terraform.tfstate
committed to repository
```

Problems:

* Security risk
* Merge conflicts
* State corruption

---

## Manual State Editing

```text id="q5n1kc"
❌ Direct state modification
```

Problems:

* Corruption risk
* Drift introduction

---

## Circular Dependencies

```text id="a8t6xs"
State A → State B

State B → State A
```

Problems:

* Deployment deadlocks
* Operational complexity

---

# Example Platform State Layout

```text id="u9r2mv"
remote-state/
│
├── dev-network.tfstate
├── dev-storage.tfstate
├── dev-compute.tfstate
├── dev-monitoring.tfstate
│
├── staging-network.tfstate
├── staging-storage.tfstate
├── staging-compute.tfstate
├── staging-monitoring.tfstate
│
├── prod-network.tfstate
├── prod-storage.tfstate
├── prod-compute.tfstate
└── prod-monitoring.tfstate
```

This structure aligns with environment isolation and infrastructure ownership boundaries.

---

# Future Evolution

As the platform grows, remote state management may evolve to support:

* Multi-account deployments
* Multi-region infrastructure
* State governance policies
* Advanced audit controls
* Automated state validation

The core principles of durability, security, isolation, and controlled access should remain unchanged.

---

# Related Documents

* State Isolation
* Environment Strategy
* Account Strategy
* Outputs
* Disaster Recovery
* Repository Layout
