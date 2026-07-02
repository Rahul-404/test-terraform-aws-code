# Outputs

## Purpose

This document defines the standards for designing, naming, exposing, and consuming Terraform outputs across the platform.

Outputs provide a controlled mechanism for exposing information from Terraform modules.

Outputs enable:

* Module composition
* Infrastructure integration
* Environment configuration
* Cross-state communication
* Operational visibility

Outputs should be treated as part of a module's public API.

---

# Design Principles

## Explicit Interfaces

Outputs define what information a module intentionally exposes.

Benefits:

* Clear module boundaries
* Reduced coupling
* Predictable behavior

---

## Least Exposure

Modules should expose only information that consumers require.

Avoid exposing internal implementation details.

Benefits:

* Improved maintainability
* Reduced dependency risk
* Better abstraction

---

## Stable Contracts

Outputs should remain stable over time.

Changing or removing outputs can break dependent modules and environments.

---

## Consumer Focused

Outputs should be designed based on consumer needs rather than implementation details.

Ask:

```text
What information does another module need?
```

rather than:

```text
What information can I expose?
```

---

# Role of Outputs

Terraform modules communicate through:

```text
Variables
    ▲
    │
    │
Outputs
```

Pattern:

```text
Module A
    │
    ▼

Output

    │
    ▼

Module B Variable
```

Example:

```text
Network Module
      │
      ▼

vpc_id

      │
      ▼

EKS Module
```

Outputs create explicit dependencies between modules.

---

# Standard Output Structure

Every output should contain:

* Name
* Description
* Value

Example:

```hcl
output "vpc_id" {

  description = "VPC identifier"

  value = aws_vpc.main.id
}
```

---

# Naming Conventions

Outputs must follow:

```text
snake_case
```

Examples:

```hcl
output "vpc_id" {}

output "cluster_endpoint" {}

output "private_subnet_ids" {}
```

---

Avoid:

```hcl
output "VpcId" {}

output "clusterEndpoint" {}

output "Output1" {}
```

Consistency improves usability.

---

# Description Requirements

All outputs should include descriptions.

Good Example:

```hcl
output "cluster_endpoint" {

  description = "Kubernetes API endpoint"

  value = aws_eks_cluster.main.endpoint
}
```

---

Poor Example:

```hcl
output "cluster_endpoint" {

  value = aws_eks_cluster.main.endpoint
}
```

Descriptions improve discoverability and documentation.

---

# Common Output Categories

Outputs generally fall into several categories.

---

## Resource Identifiers

Examples:

```hcl
output "vpc_id" {}

output "cluster_id" {}

output "bucket_id" {}
```

Used by downstream infrastructure.

---

## Resource Names

Examples:

```hcl
output "cluster_name" {}

output "bucket_name" {}
```

Useful for integrations and operational tooling.

---

## Endpoints

Examples:

```hcl
output "cluster_endpoint" {}

output "database_endpoint" {}

output "mlflow_endpoint" {}
```

Used by applications and services.

---

## ARNs

Examples:

```hcl
output "cluster_arn" {}

output "role_arn" {}

output "bucket_arn" {}
```

Used for IAM integration and cross-service permissions.

---

## Collections

Examples:

```hcl
output "private_subnet_ids" {}

output "security_group_ids" {}
```

Used by dependent modules.

---

# Good Outputs

Example EKS Module:

```hcl
output "cluster_name" {}

output "cluster_endpoint" {}

output "cluster_arn" {}

output "node_security_group_id" {}
```

These values are commonly required by consumers.

---

Example Network Module:

```hcl
output "vpc_id" {}

output "private_subnet_ids" {}

output "public_subnet_ids" {}
```

These outputs support downstream infrastructure deployment.

---

# Outputs and Module Composition

Modules should interact through outputs.

Example:

```text
Network Module
      │
      ▼

vpc_id
private_subnet_ids

      │
      ▼

EKS Module
```

Terraform Example:

```hcl
module "network" {
  ...
}

module "eks" {

  vpc_id = module.network.vpc_id

  subnet_ids =
    module.network.private_subnet_ids
}
```

This creates a clear dependency chain.

---

# Cross-State Outputs

Outputs may be consumed across Terraform states.

Example:

```text
network state
      │
      ▼

vpc_id
      │
      ▼

compute state
```

Pattern:

```text
Terraform State
        │
        ▼

Outputs
        │
        ▼

Remote State Consumer
```

This supports the State Isolation strategy.

---

# Sensitive Outputs

Sensitive values should be explicitly marked.

Example:

```hcl
output "database_password" {

  value     = var.database_password

  sensitive = true
}
```

Benefits:

* Reduced exposure
* Safer CI/CD logs
* Improved security

---

# Sensitive Output Guidelines

Potential sensitive outputs:

```text
Passwords

API Keys

Tokens

Secrets

Private Credentials
```

---

Avoid exposing secrets whenever possible.

Preferred:

```text
Secrets Manager Reference
```

instead of:

```text
Actual Secret Value
```

---

# Output Organization

Outputs should be grouped logically.

Recommended order:

```text
Identifiers

Names

Endpoints

Security Resources

Collections
```

Example:

```hcl
cluster_id

cluster_name

cluster_endpoint

cluster_security_group_id

private_subnet_ids
```

Improves readability.

---

# What Should Not Be Exposed

Avoid exposing internal implementation details.

Poor Examples:

```hcl
output "internal_route_association_id"

output "temporary_resource_id"

output "generated_random_string"
```

unless required by consumers.

---

Good Rule:

```text
If no consumer needs it,
do not output it.
```

---

# Module API Mindset

Think of outputs as a module API.

Example:

```text
Module
   │
   ▼

Inputs

Resources

Outputs
```

Consumers should interact only through:

* Variables
* Outputs

Internal resources should remain hidden.

---

# Example Platform Outputs

## Network Module

```hcl
output "vpc_id"

output "private_subnet_ids"

output "public_subnet_ids"
```

---

## EKS Module

```hcl
output "cluster_name"

output "cluster_endpoint"

output "cluster_arn"
```

---

## ECR Module

```hcl
output "repository_name"

output "repository_url"
```

---

## PostgreSQL Module

```hcl
output "database_endpoint"

output "database_port"
```

---

## MLflow Module

```hcl
output "mlflow_url"
```

---

# Output Lifecycle

Output evolution should be managed carefully.

Safe Changes:

```text
Add new outputs
```

---

Risky Changes:

```text
Rename outputs

Remove outputs

Change output meaning
```

These changes may break consumers.

---

# Anti-Patterns

## Output Everything

```hcl
output "resource_1"
output "resource_2"
output "resource_3"
output "resource_4"
output "resource_5"
...
```

Problem:

* Poor abstraction
* Tight coupling

---

## Missing Descriptions

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

Problem:

* Poor documentation

---

## Exposing Secrets

```hcl
output "database_password"
```

Problem:

* Security risk
* Secret leakage

---

## Generic Names

```hcl
output "value"

output "result"

output "data"
```

Problem:

* Poor readability

---

## Internal Resource Leakage

```hcl
output "internal_random_suffix"
```

Problem:

* Creates unnecessary dependencies

---

# Example Output Flow

```text
Network Module
      │
      ▼

vpc_id
private_subnet_ids

      │
      ▼

EKS Module
      │
      ▼

cluster_name
cluster_endpoint

      │
      ▼

Application Modules
```

This creates clear, predictable infrastructure dependencies.

---

# Future Evolution

As the platform grows, outputs may support:

* Multi-account deployments
* Multi-region infrastructure
* Platform self-service workflows
* Service discovery integrations

The core principles of explicit contracts, least exposure, and stable interfaces should remain unchanged.

---

# Related Documents

* Repository Layout
* Module Design
* Naming Conventions
* Variable Conventions
* Remote State
* Reusable Patterns
