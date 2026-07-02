# Adding New Module

## Purpose

This document defines the standard process for creating and integrating new Terraform modules into the platform.

The goal is to ensure that all modules:

* Follow platform standards
* Remain reusable
* Support multiple environments
* Integrate with existing infrastructure
* Are properly tested and documented

All new Terraform modules should follow this process.

---

# When to Create a New Module

A new module should be created when introducing a distinct infrastructure capability.

Examples:

```text id="g4n7xp"
EKS

MongoDB

PostgreSQL

Airflow

MLflow

Prometheus

Grafana

Loki
```

---

A module should represent a clear infrastructure domain.

Example:

```text id="m9r2vw"
network
```

Owns:

```text id="q6p8dy"
VPC

Subnets

Routing

NAT
```

---

Avoid creating modules for:

```text id="x5k1zn"
Single resources

Temporary infrastructure

Minor configuration changes
```

Unless there is a clear reuse requirement.

---

# Module Creation Workflow

Standard workflow:

```text id="w8m4pt"
Identify Requirement
          │
          ▼

Define Ownership
          │
          ▼

Create Module Structure
          │
          ▼

Define Variables
          │
          ▼

Implement Resources
          │
          ▼

Expose Outputs
          │
          ▼

Add Documentation
          │
          ▼

Test Module
          │
          ▼

Integrate Environment
```

---

# Step 1: Identify the Capability

Clearly define what the module owns.

Example:

```text id="u3f7nc"
postgres
```

Owns:

```text id="v9m2qx"
Database

Subnet Group

Parameter Group

Security Groups
```

---

Should not own:

```text id="r5p8dj"
VPC

EKS

Monitoring Stack
```

Ownership boundaries must be explicit.

---

# Step 2: Choose Module Category

Determine where the module belongs.

---

## Foundation Modules

Examples:

```text id="z2n4qw"
network

iam

security
```

---

## Platform Modules

Examples:

```text id="k8p1mr"
eks

ecr

s3

postgres
```

---

## Application Modules

Examples:

```text id="h7w5tb"
airflow

mlflow

prometheus

grafana
```

---

The category influences dependencies and deployment order.

---

# Step 3: Create Module Directory

Create a module directory under:

```text id="j4m7pv"
terraform/modules/
```

Example:

```text id="y6n2qc"
terraform/modules/postgres/
```

---

# Step 4: Create Standard Module Structure

Every module should contain:

```text id="a8p5kv"
postgres/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── versions.tf
└── README.md
```

---

Optional:

```text id="d9r3wt"
examples/
```

for demonstration configurations.

---

# Step 5: Define Module Inputs

Create module variables.

Follow Variable Conventions.

Example:

```hcl id="m7q4zn"
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "service" {
  type = string
}
```

---

Required platform variables:

```text id="p2n8cx"
project

environment

service

common_tags
```

These create a consistent module interface.

---

# Step 6: Define Local Values

Create reusable derived values.

Example:

```hcl id="w5m9pr"
locals {

  resource_name =
    "${var.project}-${var.environment}-${var.service}"
}
```

---

Use locals to:

* Generate names
* Merge tags
* Reduce duplication

---

# Step 7: Implement Resources

Add infrastructure resources.

Example:

```hcl id="f3k7nv"
aws_db_instance

aws_db_subnet_group

aws_security_group
```

---

Resources should follow:

* Naming conventions
* Tagging strategy
* Provider configuration standards

---

# Step 8: Apply Standard Tags

All resources should inherit common tags.

Example:

```hcl id="q7m4wx"
tags = local.common_tags
```

Pattern:

```text id="z5r8yn"
common_tags
       │
       ▼

resource_tags
       │
       ▼

resources
```

---

# Step 9: Define Outputs

Expose only necessary information.

Example:

```hcl id="s8n3pt"
output "database_endpoint"

output "database_port"

output "database_security_group_id"
```

---

Avoid exposing:

```text id="u2m9fc"
Temporary IDs

Internal metadata

Unused values
```

Outputs are part of the module API.

---

# Step 10: Add Documentation

Create or update README.

Document:

* Purpose
* Inputs
* Outputs
* Dependencies
* Example usage

---

Example:

```text id="b4r7kn"
Purpose

Inputs

Outputs

Example
```

Documentation should evolve with the module.

---

# Step 11: Add Example Usage

Provide a working example.

Example:

```hcl id="k6m2qx"
module "postgres" {

  project     = "mlops"
  environment = "dev"
  service     = "metadata"

  ...
}
```

Benefits:

* Easier onboarding
* Faster adoption

---

# Step 12: Validate Module

Run:

```text id="n3p7vw"
terraform fmt

terraform validate
```

---

Verify:

* Formatting
* Syntax
* Resource references

---

# Step 13: Lint Module

Run:

```text id="f9r5md"
tflint
```

Verify:

* Terraform best practices
* Provider-specific issues

---

# Step 14: Security Validation

Run security scanning.

Examples:

```text id="t4n8pk"
Checkov

tfsec
```

Review:

* IAM permissions
* Encryption
* Public exposure
* Security groups

---

# Step 15: Generate Plan

Create a Terraform plan.

Example:

```text id="r2w6mx"
terraform plan
```

Verify:

* Expected resources
* Correct configuration
* No unintended changes

---

# Step 16: Environment Integration

Add module to the appropriate environment.

Example:

```text id="e8q5nv"
environments/
│
├── dev/
├── staging/
└── prod/
```

---

Example:

```hcl id="y3m7qp"
module "postgres" {
  ...
}
```

Environment values should be supplied here rather than inside the module.

---

# Step 17: Remote State Integration

If the module depends on existing infrastructure:

Example:

```text id="m5k9rd"
postgres
        │
        ▼

network outputs
```

Use:

```hcl id="j8r2qw"
terraform_remote_state
```

to consume required outputs.

---

Avoid unnecessary dependencies.

---

# Step 18: Pull Request Review

Infrastructure changes should undergo review.

Reviewers should verify:

```text id="c7m4nt"
Module Design

Variables

Outputs

Security

Naming

Tagging

Testing
```

---

# Module Acceptance Checklist

A module is considered ready when:

```text id="u9r2kx"
✓ Ownership defined

✓ Standard structure exists

✓ Variables documented

✓ Outputs documented

✓ Naming conventions followed

✓ Tags applied

✓ Validation successful

✓ Linting successful

✓ Security review completed

✓ Plan reviewed

✓ README updated
```

---

# Example: Adding MongoDB Module

Workflow:

```text id="p6w8mx"
Create mongodb module
         │
         ▼

Add variables
         │
         ▼

Create resources
         │
         ▼

Expose outputs
         │
         ▼

Apply tags
         │
         ▼

Validate
         │
         ▼

Plan
         │
         ▼

Deploy to dev
```

---

# Common Mistakes

## Hardcoded Environment Logic

```hcl id="n2q7vz"
if environment == "prod"
```

Problem:

* Reduced reusability

---

## Missing Outputs

Problem:

```text id="d5p8kr"
Consumers cannot use module
```

---

## Missing Tags

Problem:

```text id="r3m9qt"
Governance inconsistency
```

---

## Missing Validation

Problem:

```text id="x8n4pv"
Configuration errors reach deployment
```

---

## Excessive Variables

Problem:

```text id="f2m6rw"
Complex module interface
```

Often indicates poor module boundaries.

---

## Duplicate Functionality

Problem:

```text id="w7p3mx"
Existing module already solves issue
```

Always check reusable patterns first.

---

# Future Evolution

As the platform grows, module creation may incorporate:

* Module registries
* Automated scaffolding
* Policy-as-Code validation
* Platform self-service provisioning
* Automated documentation generation

The core process remains unchanged:

```text id="g4n8wy"
Design

Build

Validate

Document

Deploy
```

---

# Related Documents

* Repository Layout
* Module Design
* Naming Conventions
* Variable Conventions
* Outputs
* Remote State
* Testing
* Reusable Patterns
