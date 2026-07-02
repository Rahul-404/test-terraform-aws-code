# Naming Conventions

## Purpose

This document defines the naming conventions used throughout the Terraform codebase.

Consistent naming improves:

* Readability
* Maintainability
* Collaboration
* Code reviews
* Troubleshooting
* Automation

All Terraform code should follow the standards described in this document.

---

# Design Principles

## Consistency

Engineers should be able to predict names without reading implementation details.

Benefits:

* Faster onboarding
* Easier navigation
* Reduced cognitive load

---

## Readability

Names should clearly describe purpose and ownership.

Good naming reduces the need for comments.

---

## Predictability

Resources, modules, variables, and outputs should follow deterministic patterns.

Benefits:

* Easier maintenance
* Simpler automation
* Reduced ambiguity

---

## Simplicity

Prefer concise, descriptive names.

Avoid unnecessary abbreviations.

---

# General Rules

Use:

```text
lowercase
snake_case
```

Examples:

```text
vpc_id
cluster_name
private_subnet_ids
```

---

Avoid:

```text
camelCase
PascalCase
UPPER_CASE
```

Examples:

```text
❌ VpcId
❌ ClusterName
❌ PRIVATE_SUBNET_IDS
```

---

# Directory Naming

Directories should use:

```text
lowercase
hyphen-separated
```

Examples:

```text
network
model-serving
feature-store
monitoring
```

---

Repository Example:

```text
modules/
├── network/
├── eks/
├── model-serving/
├── monitoring/
```

---

# Module Naming

Module names should represent the infrastructure domain they manage.

Pattern:

```text
<domain>
```

Examples:

```hcl
module "network" {}

module "eks" {}

module "monitoring" {}

module "mlflow" {}
```

---

Avoid:

```hcl
module "prod_eks" {}

module "eks_cluster_for_platform" {}
```

Environment-specific naming should not exist inside reusable modules.

---

# Resource Naming

Terraform resource identifiers should describe purpose rather than resource type.

Pattern:

```hcl
resource "<provider_resource>" "<purpose>"
```

Example:

```hcl
resource "aws_s3_bucket" "artifact_store" {}
```

---

Good Examples

```hcl
resource "aws_s3_bucket" "artifact_store" {}

resource "aws_iam_role" "training_role" {}

resource "aws_security_group" "eks_nodes" {}
```

---

Poor Examples

```hcl
resource "aws_s3_bucket" "bucket1" {}

resource "aws_iam_role" "role" {}

resource "aws_security_group" "sg" {}
```

---

# Variable Naming

Variables should use:

```text
snake_case
```

Pattern:

```text
<resource>_<attribute>
```

Examples:

```hcl
variable "cluster_name" {}

variable "node_count" {}

variable "instance_type" {}

variable "environment" {}
```

---

Avoid:

```hcl
variable "ClusterName" {}

variable "count" {}

variable "var1" {}
```

---

# Boolean Variables

Boolean variables should clearly indicate true/false behavior.

Preferred prefixes:

```text
enable_
create_
use_
```

Examples:

```hcl
variable "enable_monitoring" {}

variable "create_nat_gateway" {}

variable "use_spot_instances" {}
```

---

Avoid:

```hcl
variable "monitoring" {}

variable "nat_gateway" {}
```

Boolean intent should be obvious.

---

# List Variables

List variables should use plural names.

Examples:

```hcl
variable "private_subnet_ids" {}

variable "availability_zones" {}

variable "security_group_ids" {}
```

---

Avoid:

```hcl
variable "subnet" {}

variable "az" {}
```

---

# Map Variables

Maps should describe the contained values.

Examples:

```hcl
variable "common_tags" {}

variable "node_labels" {}

variable "environment_variables" {}
```

---

# Local Values

Locals should use descriptive names.

Examples:

```hcl
locals {
  cluster_name = "${var.project}-${var.environment}"
}
```

---

Good Examples

```hcl
locals {
  common_tags = {}
}

locals {
  cluster_name = ""
}

locals {
  node_group_name = ""
}
```

---

Avoid:

```hcl
locals {
  temp = ""
}

locals {
  value = ""
}
```

---

# Output Naming

Outputs should describe the value being exposed.

Examples:

```hcl
output "vpc_id" {}

output "cluster_endpoint" {}

output "private_subnet_ids" {}
```

---

Avoid:

```hcl
output "result" {}

output "output1" {}

output "data" {}
```

---

# Data Source Naming

Data sources should describe the external resource being referenced.

Examples:

```hcl
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_eks_cluster" "platform" {}
```

---

Avoid:

```hcl
data "aws_region" "region" {}

data "aws_eks_cluster" "cluster" {}
```

Names should convey purpose.

---

# File Naming

Terraform files should follow standard conventions.

Required:

```text
main.tf
variables.tf
outputs.tf
locals.tf
versions.tf
providers.tf
```

---

Additional files should use:

```text
snake_case.tf
```

Examples:

```text
networking.tf
security_groups.tf
node_groups.tf
storage.tf
```

---

Avoid:

```text
Network.tf

MyResources.tf

temp.tf
```

---

# State Naming

State files should align with environment and infrastructure domain.

Pattern:

```text
<environment>-<domain>.tfstate
```

Examples:

```text
dev-network.tfstate

staging-monitoring.tfstate

prod-compute.tfstate
```

This aligns with the State Isolation strategy.

---

# Tag Variable Naming

Tag collections should follow a common pattern.

Example:

```hcl
variable "common_tags" {}
```

Local:

```hcl
locals {
  resource_tags = merge(
    var.common_tags,
    {
      Service = "training"
    }
  )
}
```

---

# Naming Examples

## EKS Module

```hcl
module "eks" {
  cluster_name = "mlops-prod"
}
```

Outputs:

```hcl
output "cluster_name" {}

output "cluster_endpoint" {}
```

---

## Network Module

```hcl
module "network" {
  environment = "prod"
}
```

Outputs:

```hcl
output "vpc_id" {}

output "private_subnet_ids" {}
```

---

# Anti-Patterns

## Generic Names

```hcl
resource "aws_s3_bucket" "bucket" {}

variable "name" {}

output "value" {}
```

Problem:

* Poor readability
* Difficult troubleshooting

---

## Inconsistent Naming

```hcl
cluster_name

VpcId

privateSubnetIds
```

Problem:

* Inconsistent codebase
* Harder maintenance

---

## Excessive Abbreviations

```hcl
vpc_sg_ng_cfg
```

Problem:

* Difficult to understand
* Poor onboarding experience

---

## Environment-Specific Module Names

```hcl
module "prod_eks" {}

module "dev_vpc" {}
```

Problem:

* Reduced reusability
* Increased duplication

---

# Example Naming Hierarchy

```text
modules/
│
├── network/
│
├── eks/
│
├── ecr/
│
├── mlflow/
│
└── monitoring/
```

Inside a module:

```text
main.tf
variables.tf
outputs.tf
locals.tf
versions.tf
```

Resources:

```hcl
aws_s3_bucket.artifact_store

aws_iam_role.training_role

aws_security_group.eks_nodes
```

Variables:

```hcl
cluster_name

instance_type

private_subnet_ids
```

Outputs:

```hcl
vpc_id

cluster_endpoint

node_group_arn
```

This structure creates a predictable and maintainable Terraform codebase.

---

# Related Documents

* Repository Layout
* Module Design
* Variable Conventions
* Outputs
* Remote State
* Reusable Patterns

Together, these documents define how Terraform code is structured, named, reviewed, and maintained throughout the platform lifecycle.
