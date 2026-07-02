# Terraform Module

## Purpose

This document defines the Terraform module responsible for provisioning infrastructure required by the Retraining Capability.

The module provides the infrastructure needed to:

* Schedule retraining jobs
* Trigger retraining workflows
* Store retraining state
* Emit events
* Support observability
* Enable future automation

The goal is to provision retraining infrastructure consistently across:

* Development
* Staging
* Production

environments.

---

# Infrastructure Philosophy

The Retraining Capability should remain:

```text
Simple

Event Driven

Low Cost

Highly Observable
```

Startup V1 avoids heavyweight orchestration systems and instead relies on managed AWS services.

---

# Terraform Module Scope

The module provisions infrastructure for:

```text
Scheduling

Event Routing

State Storage

Observability

Security Controls
```

---

# Out of Scope

The module does not provision:

```text
Training Infrastructure

Model Registry

Experiment Tracking

Deployment Infrastructure

Feature Store
```

Those belong to their respective capabilities.

---

# Infrastructure Architecture

```text
EventBridge Scheduler

         │

         ▼

EventBridge Bus

         │

         ▼

Retraining Service

         │

         ▼

DynamoDB

         │

         ▼

CloudWatch
```

---

# Module Structure

```text
terraform/

└── modules/

    └── retraining/

        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── iam.tf
        ├── eventbridge.tf
        ├── dynamodb.tf
        ├── cloudwatch.tf
        └── versions.tf
```

---

# Module Responsibilities

The Terraform module is responsible for provisioning:

| Component             | Purpose                |
| --------------------- | ---------------------- |
| EventBridge Scheduler | Scheduled retraining   |
| EventBridge Rules     | Event routing          |
| DynamoDB              | Workflow state storage |
| CloudWatch Logs       | Logging                |
| CloudWatch Metrics    | Monitoring             |
| IAM Roles             | Security               |
| Alarms                | Failure detection      |

---

# Resource Inventory

## EventBridge Scheduler

Purpose:

```text
Generate Scheduled Retraining Events
```

---

# Example

```text
Weekly Retraining

Sunday

02:00 UTC
```

---

# Terraform Resource

```hcl
resource "aws_scheduler_schedule" "weekly_retraining" {
}
```

---

# Startup V1 Usage

Used for:

```text
Daily Retraining

Weekly Retraining

Monthly Retraining
```

---

# EventBridge Event Bus

Purpose:

```text
Route Retraining Events
```

---

# Event Types

```text
RetrainingRequested

RetrainingStarted

RetrainingCompleted

RetrainingFailed
```

---

# Terraform Resource

```hcl
resource "aws_cloudwatch_event_bus" "retraining" {
}
```

---

# EventBridge Rules

Purpose:

```text
Filter And Route Events
```

---

# Example

```text
RetrainingCompleted

        │

        ▼

Notification Workflow
```

---

# Terraform Resource

```hcl
resource "aws_cloudwatch_event_rule" "retraining_events" {
}
```

---

# DynamoDB Table

Purpose:

Store retraining workflow state.

---

# Stored Information

```text
Execution Status

Trigger Type

Timestamps

Workflow Metadata
```

---

# Example Item

```json
{
  "retraining_id": "rt-001",
  "status": "running",
  "model_id": "stroke-predictor"
}
```

---

# Terraform Resource

```hcl
resource "aws_dynamodb_table" "retraining_state" {
}
```

---

# Table Design

## Partition Key

```text
retraining_id
```

---

## Example

```text
rt-001

rt-002

rt-003
```

---

# Optional GSI

Future support:

```text
model_id
```

for querying retraining history.

---

# CloudWatch Log Groups

Purpose:

Store retraining logs.

---

# Log Sources

```text
Retraining Service

Scheduler

Event Processing

Workflow Execution
```

---

# Terraform Resource

```hcl
resource "aws_cloudwatch_log_group" "retraining" {
}
```

---

# Log Retention

Startup V1:

```text
30 Days
```

---

# Production Recommendation

```text
90 Days
```

or longer depending on compliance requirements.

---

# CloudWatch Metrics

Purpose:

Provide operational visibility.

---

# Example Metrics

```text
Retraining Requests

Retraining Successes

Retraining Failures

Execution Duration
```

---

# Example Names

```text
retraining_requested_total

retraining_completed_total

retraining_failed_total

retraining_duration_seconds
```

---

# CloudWatch Alarms

Purpose:

Detect workflow failures.

---

# Alarm Examples

```text
Retraining Failure Rate

Missed Schedule

Execution Timeout

Event Processing Failure
```

---

# Terraform Resource

```hcl
resource "aws_cloudwatch_metric_alarm" "retraining_failures" {
}
```

---

# IAM Architecture

Principle:

```text
Least Privilege
```

---

# Required Roles

## Scheduler Role

Used by:

```text
EventBridge Scheduler
```

Permissions:

```text
Invoke Retraining API
```

---

## Retraining Service Role

Permissions:

```text
Read DynamoDB

Write DynamoDB

Publish Events

Write Logs
```

---

## Monitoring Role

Permissions:

```text
Read Metrics

Read Logs
```

---

# Terraform Resources

```hcl
resource "aws_iam_role" "scheduler" {}

resource "aws_iam_role" "retraining_service" {}
```

---

# Security Controls

The module enforces:

```text
IAM Least Privilege

Encryption At Rest

Encryption In Transit

Audit Logging
```

---

# DynamoDB Encryption

Enabled by default.

```text
AWS Managed KMS
```

Startup V1.

---

# Enterprise Recommendation

```text
Customer Managed KMS Keys
```

---

# Tagging Strategy

Every resource must include:

```hcl
tags = {
  Project     = "ml-platform"
  Capability  = "retraining"
  Environment = "prod"
}
```

---

# Environment Support

The module supports:

```text
Development

Staging

Production
```

---

# Example

```hcl
module "retraining" {

  environment = "staging"

}
```

---

# Inputs

## Required Inputs

| Variable                | Description        |
| ----------------------- | ------------------ |
| environment             | Environment name   |
| project_name            | Project identifier |
| retraining_service_name | Service identifier |

---

# Optional Inputs

| Variable           | Description           |
| ------------------ | --------------------- |
| log_retention_days | Log retention         |
| alarm_enabled      | Enable alarms         |
| kms_key_arn        | Custom encryption key |
| schedule_enabled   | Enable schedules      |

---

# Outputs

## Infrastructure Outputs

| Output              | Description   |
| ------------------- | ------------- |
| scheduler_arn       | Scheduler ARN |
| event_bus_arn       | Event Bus ARN |
| dynamodb_table_name | State table   |
| log_group_name      | Log group     |
| iam_role_arn        | Service role  |

---

# Deployment Example

```hcl
module "retraining" {

  source = "./modules/retraining"

  project_name = "ml-platform"

  environment = "prod"

}
```

---

# High Availability

Startup V1 relies on:

```text
Managed AWS Services
```

which provide:

```text
Multi-AZ Availability

Automatic Recovery

Managed Scaling
```

---

# Backup Strategy

## DynamoDB

Enabled:

```text
Point-In-Time Recovery
```

---

# Benefits

Supports:

```text
State Recovery

Audit Investigations

Disaster Recovery
```

---

# Monitoring Integration

Resources integrate with:

```text
CloudWatch

Prometheus (Future)

Grafana (Future)
```

---

# Cost Optimization

Startup V1 uses:

```text
EventBridge

DynamoDB On-Demand

CloudWatch
```

because they require:

```text
No Servers

Minimal Operations

Pay-As-You-Go Pricing
```

---

# Startup V1 Provisioned Resources

| Resource              | Included |
| --------------------- | -------- |
| EventBridge Scheduler | ✓        |
| EventBridge Rules     | ✓        |
| DynamoDB              | ✓        |
| CloudWatch Logs       | ✓        |
| CloudWatch Metrics    | ✓        |
| IAM Roles             | ✓        |
| Alarms                | ✓        |
| Step Functions        | ✗        |
| Airflow               | ✗        |
| Temporal              | ✗        |

---

# Growth V2 Evolution

Additional infrastructure:

```text
Step Functions

Advanced Event Routing

Drift Detection Services

Workflow Recovery
```

---

# Enterprise V3 Evolution

Additional infrastructure:

```text
Temporal

Multi-Region Retraining

Policy Engines

Autonomous Scheduling
```

---

# Infrastructure Dependencies

| Dependency  | Purpose    |
| ----------- | ---------- |
| EventBridge | Scheduling |
| DynamoDB    | State      |
| CloudWatch  | Monitoring |
| IAM         | Security   |
| KMS         | Encryption |

---

# Requirement → Owner → Verification

| Requirement                              | Owner              | Verification     |
| ---------------------------------------- | ------------------ | ---------------- |
| Scheduled retraining must be provisioned | Terraform Module   | Terraform apply  |
| Workflow state must be persisted         | DynamoDB           | State validation |
| Events must be routable                  | EventBridge        | Event testing    |
| Logs must be retained                    | CloudWatch         | Log review       |
| Alarms must detect failures              | CloudWatch         | Alarm testing    |
| Resources must be encrypted              | AWS Infrastructure | Security review  |

---

# Summary

The Retraining Terraform Module provisions the infrastructure required to operate retraining workflows reliably and securely. Startup V1 uses EventBridge Scheduler, EventBridge Events, DynamoDB, IAM, and CloudWatch to provide a lightweight, event-driven retraining platform with minimal operational overhead. Future platform versions evolve toward advanced workflow engines, policy-based orchestration, and autonomous retraining infrastructure while preserving infrastructure-as-code principles and operational consistency.
