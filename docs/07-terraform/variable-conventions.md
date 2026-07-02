# Variable Conventions

## Purpose

This document defines the standards for declaring, naming, validating, and managing Terraform variables across the platform.

Variables serve as the primary interface between:

* Terraform modules
* Environment configurations
* Infrastructure consumers

Consistent variable conventions improve:

* Readability
* Reusability
* Maintainability
* Module usability
* Deployment safety

All Terraform modules should follow the standards defined in this document.

---

# Design Principles

## Explicit Interfaces

Variables define the public API of a Terraform module.

Every variable should exist for a clear purpose.

Benefits:

* Predictable module behavior
* Easier onboarding
* Simpler maintenance

---

## Strong Typing

All variables must declare a type.

Benefits:

* Early validation
* Improved readability
* Reduced configuration errors

Required:

```hcl
variable "environment" {
  type = string
}
```

Avoid:

```hcl
variable "environment" {}
```

---

## Validation Over Assumptions

Variables should validate user input whenever possible.

Benefits:

* Faster feedback
* Safer deployments
* Improved reliability

---

## Minimal Surface Area

Expose only variables that consumers need.

Avoid exposing internal implementation details.

---

# Standard Variable Structure

Every variable should include:

* Name
* Description
* Type
* Validation (when appropriate)

Example:

```hcl
variable "environment" {
  description = "Deployment environment"

  type = string
}
```

---

# Naming Conventions

Variables should follow:

```text
snake_case
```

Examples:

```hcl
cluster_name

environment

instance_type

node_count
```

---

Avoid:

```hcl
ClusterName

instanceType

NodeCount
```

---

# Description Requirements

Every variable must include a meaningful description.

Good Example:

```hcl
variable "cluster_name" {
  description = "Name of the Kubernetes cluster"

  type = string
}
```

---

Poor Example:

```hcl
variable "cluster_name" {
  description = "Cluster"

  type = string
}
```

Descriptions should explain purpose rather than repeat the variable name.

---

# Type Requirements

All variables must explicitly define a type.

---

## String

Example:

```hcl
variable "environment" {
  type = string
}
```

Used for:

* Names
* Identifiers
* Regions
* Environments

---

## Number

Example:

```hcl
variable "node_count" {
  type = number
}
```

Used for:

* Replicas
* Scaling parameters
* Resource sizing

---

## Boolean

Example:

```hcl
variable "enable_monitoring" {
  type = bool
}
```

Used for:

* Feature toggles
* Optional resources

---

## List

Example:

```hcl
variable "private_subnet_ids" {
  type = list(string)
}
```

Used for:

* Subnets
* Availability zones
* Security groups

---

## Map

Example:

```hcl
variable "common_tags" {
  type = map(string)
}
```

Used for:

* Tags
* Labels
* Metadata

---

## Object

Example:

```hcl
variable "node_group" {
  type = object({
    instance_type = string
    min_size      = number
    max_size      = number
  })
}
```

Used for:

* Structured configuration
* Related settings

---

# Required Variables

Variables without defaults are considered required.

Example:

```hcl
variable "environment" {
  type = string
}
```

Consumers must provide a value.

---

# Optional Variables

Variables with defaults are considered optional.

Example:

```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

Consumers may override the value.

---

# Default Value Guidelines

Use defaults only when a safe and widely applicable value exists.

Good Example:

```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

---

Avoid:

```hcl
variable "environment" {
  default = "prod"
}
```

Environment selection should always be explicit.

---

# Sensitive Variables

Secrets must be marked as sensitive.

Example:

```hcl
variable "database_password" {
  type      = string
  sensitive = true
}
```

Benefits:

* Reduced exposure
* Safer logs
* Improved security

---

Examples of sensitive variables:

```text
database_password

api_key

access_token

secret_key
```

---

# Validation Rules

Variables should validate expected values.

---

## Environment Validation

Example:

```hcl
variable "environment" {

  type = string

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Invalid environment."
  }
}
```

---

## Instance Count Validation

Example:

```hcl
variable "node_count" {

  type = number

  validation {
    condition     = var.node_count > 0
    error_message = "Node count must be greater than zero."
  }
}
```

---

Validation should prevent invalid infrastructure configurations.

---

# Standard Platform Variables

Most modules should support a common set of variables.

---

## Project

```hcl
variable "project" {
  type = string
}
```

Example:

```text
mlops
```

---

## Environment

```hcl
variable "environment" {
  type = string
}
```

Examples:

```text
dev
staging
prod
```

---

## Service

```hcl
variable "service" {
  type = string
}
```

Examples:

```text
training
model-serving
monitoring
```

---

## Common Tags

```hcl
variable "common_tags" {
  type = map(string)
}
```

Used throughout the platform.

---

# Local Variable Usage

Variables should be transformed through locals when necessary.

Example:

```hcl
locals {

  cluster_name =
    "${var.project}-${var.environment}"
}
```

Benefits:

* Cleaner resource definitions
* Reduced duplication

---

# Environment Configuration

Environment-specific values belong in environment configuration layers.

Example:

```text
environments/
│
├── dev/
├── staging/
└── prod/
```

Modules should remain environment agnostic.

---

# Variable Organization

Variables should be grouped logically.

Example:

```text
Core Variables

Environment Variables

Networking Variables

Security Variables

Feature Flags
```

Large modules become easier to navigate.

---

# Variable Ordering

Recommended order:

```text
Description

Type

Default

Validation
```

Example:

```hcl
variable "environment" {

  description = "Deployment environment"

  type = string

  validation {
    ...
  }
}
```

Consistency improves readability.

---

# Anti-Patterns

## Missing Types

```hcl
variable "environment" {}
```

Problem:

* Weak validation
* Unclear interface

---

## Missing Descriptions

```hcl
variable "environment" {
  type = string
}
```

Problem:

* Poor usability
* Difficult onboarding

---

## Excessive Variables

```text
80+
variables
```

Problem:

* Indicates poor module design
* Difficult maintenance

---

## Hardcoded Secrets

```hcl
variable "database_password" {
  default = "admin123"
}
```

Problem:

* Security risk
* Poor secret management

---

## Environment Logic

```hcl
variable "is_prod" {}
```

used throughout module logic.

Problem:

* Reduced reusability
* Hidden complexity

---

# Example Module Interface

Example EKS module variables:

```hcl
project

environment

cluster_name

private_subnet_ids

node_count

instance_type

common_tags
```

The interface remains concise while exposing meaningful configuration.

---

# Future Evolution

As the platform grows, variable conventions may evolve to support:

* Complex object types
* Shared configuration schemas
* Platform self-service workflows
* Policy validation

The core principles of explicit typing, validation, simplicity, and consistency should remain unchanged.

---

# Related Documents

* Repository Layout
* Module Design
* Naming Conventions
* Outputs
* Remote State
* Reusable Patterns

Together, these documents define how Terraform modules expose configuration, communicate requirements, and maintain consistency across the platform lifecycle.
