# Module Design

## Purpose

This document defines the module design principles used throughout the Terraform codebase.

Terraform modules are the primary mechanism for creating reusable, maintainable, and scalable infrastructure.

The goals of module design are:

* Promote reuse
* Reduce duplication
* Improve maintainability
* Enable environment consistency
* Support platform growth
* Reduce operational risk

All infrastructure resources should be deployed through reusable modules whenever practical.

---

# Design Principles

## Single Responsibility

Each module should own a single infrastructure domain.

Examples:

```text
VPC Module
EKS Module
S3 Module
ECR Module
RDS Module
```

Benefits:

* Easier maintenance
* Clear ownership
* Reduced complexity

---

### Good Example

```text
network/
```

Responsible for:

```text
VPC
Subnets
Route Tables
NAT Gateways
```

---

### Bad Example

```text
platform/
```

Responsible for:

```text
VPC
EKS
IAM
S3
RDS
Monitoring
```

Problems:

* Large blast radius
* Difficult testing
* Poor reusability

---

## Reusability

Modules should be reusable across:

* Development
* Staging
* Production

Avoid embedding environment-specific behavior.

Preferred:

```text
cluster_name
instance_type
node_count
```

Provided as inputs.

Avoid:

```text
if environment == "prod"
```

inside modules whenever possible.

---

## Environment Agnostic

Modules should not know where they are deployed.

The environment layer is responsible for configuration.

Example:

```text
modules/
   └── eks/
```

Should work in:

```text
dev
staging
prod
```

without modification.

---

## Explicit Interfaces

Modules communicate through:

* Variables
* Outputs

Benefits:

* Predictable behavior
* Easier testing
* Reduced coupling

---

# Module Structure

Standard module layout:

```text
module-name/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── locals.tf
├── README.md
└── examples/
```

---

## main.tf

Contains primary infrastructure resources.

Example:

```text
aws_vpc
aws_subnet
aws_route_table
```

Purpose:

* Resource definitions
* Internal relationships

---

## variables.tf

Defines module inputs.

Example:

```hcl
variable "environment" {
  type = string
}
```

Responsibilities:

* Input validation
* Interface definition
* Documentation

---

## outputs.tf

Defines module outputs.

Example:

```hcl
output "vpc_id"
```

Used by downstream modules.

---

## versions.tf

Defines provider and Terraform requirements.

Example:

```hcl
terraform {
  required_version = ">= 1.8"
}
```

Benefits:

* Consistent execution
* Predictable behavior

---

## locals.tf

Contains derived values.

Example:

```hcl
locals {
  cluster_name = "${var.project}-${var.environment}"
}
```

Benefits:

* Reduced duplication
* Improved readability

---

## README.md

Documents:

* Module purpose
* Inputs
* Outputs
* Examples
* Usage guidance

Documentation should be updated with every module change.

---

# Module Categories

The platform uses several module categories.

---

## Foundation Modules

Provide core infrastructure.

Examples:

```text
network
iam
security
```

Typically deployed first.

---

## Platform Modules

Provide shared platform capabilities.

Examples:

```text
eks
ecr
rds
s3
```

Depend on foundation modules.

---

## Application Modules

Deploy platform applications.

Examples:

```text
mlflow
airflow
prometheus
grafana
loki
```

Depend on platform modules.

---

# Dependency Strategy

Dependencies should remain minimal.

Preferred:

```text
network
   │
   ▼

eks
   │
   ▼

applications
```

Avoid:

```text
module A
   │
   ▼

module B
   │
   ▼

module C
   │
   ▼

module D
```

Long dependency chains increase complexity.

---

# Module Communication

Modules communicate through outputs.

Example:

```text
network
   │
   ▼

vpc_id
   │
   ▼

eks
```

---

Example:

```hcl
module "network" {
  ...
}

module "eks" {
  vpc_id = module.network.vpc_id
}
```

Benefits:

* Clear dependencies
* Explicit contracts

---

# Module Inputs

Modules should expose only required inputs.

Good:

```hcl
cluster_name
node_count
instance_type
```

Avoid:

```hcl
50+ variables
```

Excessive variables often indicate poor module boundaries.

---

# Module Outputs

Outputs should expose useful information.

Examples:

```hcl
vpc_id
private_subnet_ids
cluster_endpoint
cluster_name
```

Avoid exposing internal implementation details.

---

### Good Output

```hcl
output "vpc_id"
```

---

### Poor Output

```hcl
output "internal_route_table_association_id"
```

unless required by consumers.

---

# Resource Ownership

Each resource should belong to exactly one module.

Example:

```text
network module
      │
      ▼

owns VPC
owns subnets
owns routing
```

Avoid shared ownership.

---

# Tagging Integration

Modules should inherit common tags.

Pattern:

```text
global_tags
      │
      ▼

module_tags
      │
      ▼

resources
```

Benefits:

* Consistency
* Reduced duplication

---

# Naming Integration

Modules should generate names from standardized inputs.

Example:

```text
project
environment
service
```

Generates:

```text
mlops-prod-training-eks
```

This aligns with the Naming Strategy document.

---

# Testing Considerations

Modules should support testing independently.

Validation includes:

```text
terraform fmt
terraform validate
terraform plan
```

Modules should be deployable in isolation whenever possible.

---

# Versioning Strategy

Modules should be versioned when shared across environments.

Example:

```text
v1.0.0
v1.1.0
v2.0.0
```

Benefits:

* Controlled upgrades
* Reduced deployment risk

---

# Anti-Patterns

## Monolithic Modules

```text
❌ One module managing entire platform
```

Problems:

* Large blast radius
* Difficult maintenance

---

## Environment Logic Inside Modules

```text
❌ if environment == "prod"
```

Problems:

* Reduced reusability
* Increased complexity

---

## Excessive Variables

```text
❌ 80+ input variables
```

Often indicates poor abstraction.

---

## Hidden Dependencies

```text
❌ Assumes resources exist
without explicit inputs
```

Problems:

* Fragile deployments
* Difficult troubleshooting

---

## Resource Duplication

```text
❌ Multiple modules manage
the same resource
```

Problems:

* State conflicts
* Operational risk

---

# Example Platform Modules

The MLOps platform may include modules such as:

```text
modules/
│
├── network/
├── iam/
├── eks/
├── ecr/
├── s3/
├── postgres/
├── mongodb/
├── mlflow/
├── airflow/
├── prometheus/
├── grafana/
└── loki/
```

Each module owns a clearly defined infrastructure domain.

---

# Future Evolution

As the platform grows, module design may evolve to support:

* Multi-account deployments
* Multi-region infrastructure
* Shared services
* Advanced networking
* Platform self-service capabilities

The core principles of single responsibility, reusability, and explicit interfaces should remain unchanged.

---

# Related Documents

* Repository Layout
* Naming Conventions
* Variable Conventions
* Outputs
* Remote State
* Reusable Patterns
* Adding New Module

Together, these documents define how Terraform modules are designed, maintained, tested, and evolved throughout the platform lifecycle.
