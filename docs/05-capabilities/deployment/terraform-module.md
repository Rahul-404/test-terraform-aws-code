# Terraform Module

## Purpose

This document defines the Terraform implementation for the Deployment Capability.

The Deployment Terraform module provisions and manages all infrastructure required for model serving and deployment operations.

The module provides:

* Model serving infrastructure
* Deployment execution components
* Networking configuration
* Security controls
* Monitoring integration
* Rollback support

The goal is to make deployment infrastructure repeatable, version-controlled, and environment-independent.

---

# Module Objectives

The Deployment Terraform module should:

```text
Provision Deployment Infrastructure

Support Multiple Environments

Enable Safe Model Rollouts

Enable Rollbacks

Integrate Monitoring

Enforce Security Controls
```

---

# Design Principles

The module follows the platform Terraform standards.

---

## Reusable

The same module must support:

```text
Development

Staging

Production
```

---

## Environment Agnostic

Environment-specific values are provided through variables.

---

## Idempotent

Multiple executions should produce the same infrastructure state.

---

## Least Privilege

Only required permissions are granted.

---

## Observable

All deployment resources emit metrics and logs.

---

# Module Placement

Repository structure:

```text
terraform/

└── modules/
    └── deployment/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── iam.tf
        ├── ecs.tf
        ├── alb.tf
        ├── security.tf
        ├── monitoring.tf
        └── versions.tf
```

---

# Capability Ownership

The module provisions infrastructure for:

```text
Deployment Service

Model Serving

Traffic Routing

Health Checks

Rollback Infrastructure
```

---

# Infrastructure Scope

---

## Included

```text
ECS Cluster Integration

ECS Services

Task Definitions

Load Balancer Integration

Target Groups

Security Groups

CloudWatch Logs

CloudWatch Alarms

IAM Roles
```

---

## Excluded

```text
MLflow

Training Infrastructure

Feature Store

Experiment Tracking

Networking Foundation

VPC Creation
```

These are managed by separate modules.

---

# High-Level Infrastructure

```text
Deployment Module
        │
        ▼

ECS Service
        │
        ▼

Task Definition
        │
        ▼

Inference Container
        │
        ▼

Application Load Balancer
```

---

# Core Resources

## ECS Service

Purpose:

```text
Runs Model Serving Containers
```

Terraform:

```hcl
resource "aws_ecs_service" "deployment" {
}
```

---

## ECS Task Definition

Purpose:

```text
Defines Runtime Configuration
```

Terraform:

```hcl
resource "aws_ecs_task_definition" "deployment" {
}
```

---

## Application Load Balancer Integration

Purpose:

```text
Expose Prediction Endpoint
```

Terraform:

```hcl
resource "aws_lb_target_group" "deployment" {
}
```

---

## Security Group

Purpose:

```text
Restrict Network Access
```

Terraform:

```hcl
resource "aws_security_group" "deployment" {
}
```

---

## CloudWatch Log Group

Purpose:

```text
Centralized Logging
```

Terraform:

```hcl
resource "aws_cloudwatch_log_group" "deployment" {
}
```

---

## Monitoring Alarms

Purpose:

```text
Operational Monitoring
```

Terraform:

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
}
```

---

# Module Inputs

---

## Environment

```hcl
variable "environment" {
  type = string
}
```

Example:

```text
dev

staging

prod
```

---

## Service Name

```hcl
variable "service_name" {
  type = string
}
```

Example:

```text
heart-stroke-prediction
```

---

## Container Image

```hcl
variable "container_image" {
  type = string
}
```

Example:

```text
123456.dkr.ecr.amazonaws.com/stroke-model:v12
```

---

## Desired Count

```hcl
variable "desired_count" {
  type = number
}
```

Example:

```text
2
```

---

## CPU

```hcl
variable "cpu" {
  type = number
}
```

Example:

```text
512
```

---

## Memory

```hcl
variable "memory" {
  type = number
}
```

Example:

```text
1024
```

---

## VPC ID

```hcl
variable "vpc_id" {
  type = string
}
```

---

## Subnet IDs

```hcl
variable "subnet_ids" {
  type = list(string)
}
```

---

# Module Outputs

---

## ECS Service ARN

```hcl
output "service_arn" {
}
```

---

## ECS Cluster ARN

```hcl
output "cluster_arn" {
}
```

---

## Target Group ARN

```hcl
output "target_group_arn" {
}
```

---

## Service URL

```hcl
output "service_url" {
}
```

Example:

```text
https://api.company.com/stroke-model
```

---

# ECS Configuration

Deployment service configuration:

```text
Launch Type:
Fargate

Task Count:
Configurable

Health Checks:
Enabled

Rolling Updates:
Enabled
```

---

# Health Check Configuration

Health checks validate deployment success.

Example:

```http
GET /health
```

Expected:

```json
{
  "status": "healthy"
}
```

Terraform:

```hcl
health_check {
  path = "/health"
}
```

---

# Logging Configuration

Each deployment service sends logs to CloudWatch.

Example:

```text
/stroke-model/prod
```

Benefits:

```text
Centralized Logs

Troubleshooting

Audit Support
```

---

# Monitoring Resources

The module provisions alarms for:

---

## CPU Usage

Example:

```text
CPU > 80%
```

---

## Memory Usage

Example:

```text
Memory > 85%
```

---

## Service Availability

Example:

```text
Target Health < 100%
```

---

## Error Rate

Example:

```text
5XX Errors Detected
```

---

# IAM Resources

The deployment service receives an execution role.

Purpose:

```text
Pull ECR Images

Read Secrets

Write Logs
```

Terraform:

```hcl
resource "aws_iam_role" "deployment_execution" {
}
```

---

# Secrets Integration

The module supports secrets injection from:

```text
AWS Secrets Manager
```

Examples:

```text
Database Credentials

API Keys

Model Configuration
```

---

# Network Integration

The module consumes:

```text
VPC

Private Subnets

Security Groups
```

provided by the networking layer.

The deployment module never creates networking foundations.

---

# Security Controls

---

## Private Compute

Containers run inside private subnets.

---

## IAM Least Privilege

Only required permissions are granted.

---

## Encryption

Data uses:

```text
TLS In Transit

AWS Managed Encryption At Rest
```

---

## Secret Isolation

Secrets are never stored in Terraform state.

---

# Deployment Workflow Integration

The module is consumed by:

```text
GitHub Actions

Deployment Service

Infrastructure Pipeline
```

Workflow:

```text
Model Approved
       │
       ▼

Terraform Apply
       │
       ▼

ECS Service Updated
       │
       ▼

New Version Running
```

---

# Rollback Support

Rollback uses the same module.

Only deployment inputs change.

Example:

Before:

```text
stroke-model:v12
```

Rollback:

```text
stroke-model:v11
```

Terraform updates:

```text
Task Definition

Container Image
```

---

# State Management

Terraform state tracks:

```text
ECS Services

Task Definitions

Load Balancer Resources

IAM Resources

Monitoring Resources
```

State backend:

```text
S3 Backend

DynamoDB Locking
```

---

# Environment Strategy

Example:

```text
environments/

├── dev
├── staging
└── prod
```

All environments reuse the same deployment module.

---

# Failure Scenarios

---

## Terraform Apply Failure

Cause:

```text
AWS API Error
```

Mitigation:

```text
Retry

Review State
```

---

## ECS Provisioning Failure

Cause:

```text
Resource Limits
```

Mitigation:

```text
Adjust Capacity
```

---

## Invalid Image

Cause:

```text
Container Missing
```

Mitigation:

```text
Redeploy Valid Version
```

---

## IAM Failure

Cause:

```text
Missing Permissions
```

Mitigation:

```text
Policy Validation
```

---

# Startup V1 Limitations

The module intentionally excludes:

```text
Canary Deployment

Blue-Green Deployment

Traffic Splitting

Service Mesh

Multi-Region Deployment
```

to maintain operational simplicity.

---

# Future Enhancements

Growth-stage platform versions may introduce:

```text
Blue-Green Infrastructure

Canary Support

Progressive Delivery

Auto Scaling Policies

Multi-Region Serving
```

---

# Trade-Off Analysis

| Decision                  | Benefit                | Limitation                  |
| ------------------------- | ---------------------- | --------------------------- |
| ECS Fargate               | Simple Operations      | Higher Cost At Scale        |
| Single Service Deployment | Easy Management        | Limited Release Flexibility |
| Shared Module             | Reusable               | Less Specialized            |
| CloudWatch Monitoring     | Native AWS Integration | Fewer Advanced Features     |

---

# Summary

The Deployment Terraform module provisions and manages all infrastructure required for model serving and deployment. It creates ECS services, task definitions, load balancer integrations, IAM roles, logging resources, and monitoring components. The module is reusable across environments, integrates with GitHub Actions deployment pipelines, supports rollback workflows, and follows the startup-first philosophy of operational simplicity and reliability.
