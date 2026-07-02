# Reusable Patterns

## Purpose

This document defines the reusable Terraform patterns used throughout the platform.

Reusable patterns provide a consistent approach for building infrastructure.

Benefits include:

* Reduced duplication
* Faster development
* Easier maintenance
* Improved consistency
* Lower operational risk

Engineers should prefer established patterns over creating custom implementations.

---

# Design Principles

## Consistency

Infrastructure should be built using common patterns.

Benefits:

* Easier onboarding
* Simpler troubleshooting
* Predictable deployments

---

## Reusability

Patterns should be applicable across:

```text id="p6a8yt"
dev

staging

prod
```

and across multiple infrastructure domains.

---

## Simplicity

Patterns should solve common problems without introducing unnecessary complexity.

---

## Composability

Patterns should work together.

Example:

```text id="s5r9ko"
Naming Pattern
        │
        ▼

Tagging Pattern
        │
        ▼

Module Pattern
```

Patterns should reinforce each other.

---

# Pattern Categories

The platform uses several reusable pattern categories.

```text id="x3w7qp"
Module Patterns

Tagging Patterns

Naming Patterns

State Patterns

Environment Patterns

Security Patterns

Composition Patterns
```

---

# Common Tag Pattern

All resources inherit a shared tag set.

Pattern:

```text id="f7u4dn"
global_tags
      │
      ▼

module_tags
      │
      ▼

resource_tags
```

---

Example:

```hcl id="e8j5pq"
locals {

  common_tags = merge(
    var.common_tags,
    {
      Service = var.service
    }
  )
}
```

---

Benefits:

* Consistent governance
* Cost allocation
* Easier resource discovery

---

# Standard Naming Pattern

Infrastructure resource names should follow:

```text id="r2m6yw"
project-environment-service-resource
```

Example:

```text id="d8k4vc"
mlops-prod-training-eks
```

---

Terraform local:

```hcl id="w9n2fj"
locals {

  resource_name =
    "${var.project}-${var.environment}-${var.service}"
}
```

Benefits:

* Predictable naming
* Easier operations
* Reduced collisions

---

# Standard Module Interface Pattern

Most modules should expose a common interface.

Example:

```hcl id="j4p7xs"
project

environment

service

common_tags
```

---

Benefits:

* Consistent module APIs
* Easier module consumption
* Reduced onboarding effort

---

# Resource Tagging Pattern

Resources should consume a shared tag object.

Example:

```hcl id="k7u5mz"
resource "aws_s3_bucket" "artifact_store" {

  tags = local.common_tags
}
```

Benefits:

* Eliminates duplication
* Ensures compliance

---

# Local Values Pattern

Derived values should be generated through locals.

Example:

```hcl id="q9v4pw"
locals {

  cluster_name =
    "${var.project}-${var.environment}"
}
```

Benefits:

* Cleaner resources
* Centralized naming logic

---

# Environment Configuration Pattern

Modules remain environment agnostic.

Environment-specific values belong outside modules.

Example:

```text id="a2f8mr"
environments/
│
├── dev/
├── staging/
└── prod/
```

---

Modules receive values through variables.

Example:

```hcl id="c8y6tn"
module "eks" {

  environment = "prod"

  node_count = 5
}
```

Benefits:

* Reusability
* Simpler modules

---

# Remote State Pattern

Infrastructure domains consume outputs from upstream states.

Example:

```text id="p5x3dv"
network state
      │
      ▼

vpc_id

      │
      ▼

compute state
```

---

Terraform Example:

```hcl id="h7k2qa"
data "terraform_remote_state" "network" {
  ...
}
```

Benefits:

* State isolation
* Clear ownership boundaries

---

# Module Composition Pattern

Complex infrastructure should be assembled from smaller modules.

Example:

```text id="y6m9wf"
network
     │
     ▼

eks
     │
     ▼

applications
```

---

Terraform Example:

```hcl id="r4j8cp"
module "network" {}

module "eks" {}

module "mlflow" {}
```

Benefits:

* Reusability
* Easier testing
* Reduced complexity

---

# Output Consumption Pattern

Modules communicate through outputs.

Example:

```hcl id="u5n3km"
module.network.vpc_id
```

Used as:

```hcl id="n2w8rs"
vpc_id = module.network.vpc_id
```

Benefits:

* Explicit dependencies
* Predictable behavior

---

# IAM Policy Pattern

Policies should be generated from structured data rather than embedded JSON.

Preferred:

```hcl id="m8f4qy"
data "aws_iam_policy_document"
```

---

Avoid:

```text id="v3k7dp"
inline JSON blobs
```

Benefits:

* Easier maintenance
* Better validation

---

# Security Group Pattern

Security groups should be narrowly scoped.

Preferred:

```text id="t7r9mx"
Application
     │
     ▼

Specific Port
     │
     ▼

Specific Source
```

---

Avoid:

```text id="b6n2zw"
0.0.0.0/0
all ports
```

unless explicitly required.

Benefits:

* Reduced attack surface

---

# Provider Configuration Pattern

Providers should be configured centrally.

Example:

```text id="w4q8kp"
providers.tf
```

---

Avoid:

```text id="c3j5dn"
provider blocks
duplicated throughout modules
```

Benefits:

* Consistency
* Easier upgrades

---

# Conditional Resource Pattern

Optional resources should use feature flags.

Example:

```hcl id="p8m6tv"
variable "enable_monitoring" {
  type = bool
}
```

---

Usage:

```hcl id="x5r2kn"
count = var.enable_monitoring ? 1 : 0
```

Benefits:

* Flexible deployments
* Reduced duplication

---

# Dynamic Configuration Pattern

Repeated configuration should use loops.

Example:

```hcl id="l9f4wy"
for_each
```

instead of manually duplicating resources.

Example:

```hcl id="j2p7qa"
for_each = var.node_groups
```

Benefits:

* Scalability
* Cleaner code

---

# Standard Resource Creation Pattern

Typical module workflow:

```text id="v7n8dc"
Variables
      │
      ▼

Locals
      │
      ▼

Resources
      │
      ▼

Outputs
```

---

Terraform Layout:

```text id="m4y2fr"
variables.tf

locals.tf

main.tf

outputs.tf
```

This should be the default pattern for all modules.

---

# Example EKS Pattern

```text id="u3k9ws"
Network Module
       │
       ▼

VPC

Subnets

       │
       ▼

EKS Module

       │
       ▼

Node Groups

       │
       ▼

Outputs
```

Consumers receive:

```text id="d5r8fn"
cluster_name

cluster_endpoint

cluster_arn
```

without needing access to internal resources.

---

# Example Monitoring Pattern

Monitoring stack:

```text id="e6m2vp"
Prometheus

Grafana

Loki
```

shared pattern:

```text id="r9w4kt"
project

environment

service

common_tags
```

All monitoring modules follow the same interface.

---

# Anti-Patterns

## Copy-Paste Infrastructure

```text id="n4x7yb"
❌ Duplicate resources
across modules
```

Problems:

* Inconsistent behavior
* Higher maintenance cost

---

## Hardcoded Values

```hcl id="a8k5rm"
instance_type = "t3.medium"
```

inside reusable modules.

Problem:

* Reduced flexibility

---

## Custom Naming Logic

```text id="j5v3qn"
❌ Different naming rules
per module
```

Problem:

* Operational confusion

---

## Resource Ownership Overlap

```text id="s8p6tw"
❌ Multiple modules
manage same resource
```

Problem:

* State conflicts

---

## Monolithic Infrastructure

```text id="c2m9fx"
❌ One giant module
for entire platform
```

Problem:

* Large blast radius
* Poor reusability

---

# Pattern Adoption Process

Before introducing a new Terraform pattern:

Review:

```text id="z7n4dk"
Existing Modules

Existing Patterns

Platform Standards
```

Questions:

```text id="h3r8vp"
Can an existing pattern solve this?

Can this become reusable?

Will this improve consistency?
```

Only introduce new patterns when a clear need exists.

---

# Future Evolution

As the platform grows, reusable patterns may expand to support:

* Multi-account deployments
* Multi-region infrastructure
* Platform self-service workflows
* Policy-as-Code
* Advanced governance controls

The goal is to maintain a small set of well-understood patterns that can be applied consistently across the platform.

---

# Related Documents

* Repository Layout
* Module Design
* Naming Conventions
* Variable Conventions
* Outputs
* Remote State
* Testing
