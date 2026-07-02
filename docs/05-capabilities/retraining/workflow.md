# Workflow

## Purpose

This document describes the end-to-end workflow of the Retraining Capability.

The workflow defines how a model moves from:

```text
Retraining Trigger

        ↓

Training Request

        ↓

Model Training

        ↓

Validation

        ↓

Registry

        ↓

Approval

        ↓

Deployment
```

The Retraining Capability acts as the orchestration layer connecting Monitoring, Training, Registry, Governance, and Deployment.

---

# High-Level Workflow

```text
Monitoring / Schedule / User

            │

            ▼

    Retraining Trigger

            │

            ▼

   Trigger Evaluation

            │

            ▼

    Policy Validation

            │

            ▼

   Retraining Request

            │

            ▼

   Training Capability

            │

            ▼

 Experiment Tracking

            │

            ▼

    Model Registry

            │

            ▼

    Approval Flow

            │

            ▼

      Deployment
```

---

# Workflow Objectives

The workflow must:

* Support automated retraining
* Support manual retraining
* Maintain lineage
* Ensure auditability
* Prevent duplicate execution
* Enable governance controls
* Support future automation

---

# Startup V1 Workflow

Startup V1 follows a controlled retraining process.

```text
Trigger

  ↓

Training

  ↓

Registry

  ↓

Approval

  ↓

Deployment
```

Human approval remains mandatory before deployment.

---

# Workflow States

Each retraining execution moves through a defined lifecycle.

```text
Requested

    ↓

Validated

    ↓

Queued

    ↓

Running

    ↓

Completed

    ↓

Registered

    ↓

Approved

    ↓

Deployed
```

---

# Failure States

Possible failure paths:

```text
Failed

Cancelled

Rejected

Expired
```

---

# Workflow 1: Scheduled Retraining

## Scenario

A model is configured for weekly retraining.

---

# Step 1

EventBridge schedule executes.

Example:

```text
Every Sunday

02:00 UTC
```

---

# Step 2

Retraining service receives trigger.

```json
{
  "trigger_type": "scheduled",
  "model_id": "stroke-predictor"
}
```

---

# Step 3

Trigger validation occurs.

Checks:

* Model exists
* Schedule active
* Cooldown satisfied
* No active retraining

---

# Step 4

Retraining request created.

```text
Status = Requested
```

---

# Step 5

Training request submitted.

```text
Retraining Service

        ↓

Training Capability
```

---

# Step 6

Training job executes.

Outputs:

```text
Model

Metrics

Artifacts
```

---

# Step 7

Experiment recorded.

Stored in:

```text
MLflow
```

---

# Step 8

Model registered.

Stored in:

```text
Model Registry
```

---

# Step 9

Approval workflow initiated.

```text
Pending Approval
```

---

# Step 10

Model approved.

```text
Approved
```

---

# Step 11

Deployment request created.

```text
Deployment Capability
```

---

# Step 12

Deployment completed.

Workflow ends.

---

# Scheduled Retraining Flow

```text
Scheduler

   │

   ▼

Retraining Service

   │

   ▼

Training

   │

   ▼

Experiment Tracking

   │

   ▼

Registry

   │

   ▼

Approval

   │

   ▼

Deployment
```

---

# Workflow 2: Performance-Based Retraining

## Scenario

Monitoring detects performance degradation.

---

# Step 1

Monitoring evaluates metrics.

Example:

```text
F1 Score = 0.72

Required = 0.80
```

---

# Step 2

Alert generated.

```text
Performance Threshold Breached
```

---

# Step 3

Retraining trigger emitted.

```json
{
  "trigger_type": "performance",
  "metric": "f1_score",
  "value": 0.72
}
```

---

# Step 4

Retraining service validates trigger.

Checks:

* Trigger enabled
* Cooldown satisfied
* No active execution

---

# Step 5

Training workflow starts.

Remaining steps match scheduled retraining workflow.

---

# Performance Workflow

```text
Monitoring

     │

     ▼

Performance Trigger

     │

     ▼

Retraining Service

     │

     ▼

Training Workflow
```

---

# Workflow 3: Manual Retraining

## Scenario

A Data Scientist manually initiates retraining.

---

# Step 1

User submits request.

Example:

```http
POST /retraining/start
```

---

# Step 2

Authorization verified.

Checks:

```text
Role

Permissions

Model Access
```

---

# Step 3

Retraining request created.

---

# Step 4

Training workflow begins.

---

# Manual Workflow

```text
Data Scientist

      │

      ▼

Retraining API

      │

      ▼

Retraining Service

      │

      ▼

Training Workflow
```

---

# Workflow 4: Dataset Arrival Trigger

## Scenario

New training dataset becomes available.

---

# Step 1

Dataset uploaded.

```text
S3 Dataset Bucket
```

---

# Step 2

Upload event generated.

```text
EventBridge Event
```

---

# Step 3

Policy evaluation occurs.

Example:

```text
Auto Retrain = Enabled
```

---

# Step 4

Retraining request generated.

---

# Step 5

Training workflow starts.

---

# Dataset Workflow

```text
Dataset Upload

      │

      ▼

EventBridge

      │

      ▼

Retraining Service

      │

      ▼

Training Workflow
```

---

# Trigger Validation Workflow

Before training begins every trigger must pass validation.

---

# Validation Pipeline

```text
Trigger

   │

   ▼

Model Exists?

   │

   ▼

Trigger Enabled?

   │

   ▼

Cooldown Passed?

   │

   ▼

Active Run Exists?

   │

   ▼

Approved To Execute?
```

---

# Cooldown Validation

Purpose:

Prevent excessive retraining.

---

# Example

Without cooldown:

```text
Metric Drop

     ↓

Retrain

     ↓

Metric Drop

     ↓

Retrain Again
```

---

# With Cooldown

```text
Retrain

     ↓

Wait 7 Days

     ↓

Allow Next Retraining
```

---

# Duplicate Request Prevention

The workflow prevents:

```text
Same Model

+

Same Trigger

+

Same Time Window
```

from creating multiple executions.

---

# Training Execution Workflow

After validation:

```text
Retraining Request

       │

       ▼

Training Request

       │

       ▼

Compute Allocation

       │

       ▼

Training Execution

       │

       ▼

Results Produced
```

---

# Successful Completion Workflow

```text
Training Success

       │

       ▼

Experiment Logged

       │

       ▼

Model Registered

       │

       ▼

Approval Requested

       │

       ▼

Deployment Candidate
```

---

# Failure Workflow

## Training Failure

```text
Training Request

       │

       ▼

Training Failure

       │

       ▼

Status = Failed

       │

       ▼

Alert Generated
```

---

# Registry Failure

```text
Training Success

       │

       ▼

Registry Failure

       │

       ▼

Status = Failed
```

---

# Approval Rejection

```text
Model Registered

       │

       ▼

Approval Review

       │

       ▼

Rejected
```

No deployment occurs.

---

# Cancellation Workflow

Authorized users may cancel execution.

```text
Running

    │

    ▼

Cancel Request

    │

    ▼

Cancelled
```

---

# Workflow State Diagram

```text
Requested

    │

    ▼

Validated

    │

    ▼

Queued

    │

    ▼

Running

 ┌──┼───┐
 │  │   │
 ▼  ▼   ▼

Success
Fail
Cancel

 │
 ▼

Registered

 │
 ▼

Approved

 │
 ▼

Deployed
```

---

# Metadata Generated

Each workflow produces metadata.

---

# Example

```json
{
  "retraining_id": "rt-001",
  "model_id": "stroke-predictor",
  "trigger_type": "performance",
  "status": "completed",
  "started_at": "...",
  "completed_at": "..."
}
```

---

# Audit Events Generated

Examples:

```text
RetrainingRequested

RetrainingStarted

RetrainingCompleted

RetrainingFailed

ApprovalRequested

ApprovalRejected
```

---

# Startup V1 Workflow Characteristics

| Characteristic | Approach                         |
| -------------- | -------------------------------- |
| Triggering     | Manual + Scheduled + Performance |
| Validation     | Required                         |
| Approval       | Manual                           |
| Deployment     | Controlled                       |
| Rollback       | Deployment Capability            |
| Auditing       | Mandatory                        |

---

# Growth V2 Workflow Evolution

Additional workflow steps:

```text
Drift Detection

Adaptive Scheduling

Policy Evaluation

Automatic Trigger Selection
```

---

# Enterprise V3 Workflow Evolution

Additional workflow capabilities:

```text
Continuous Training

Automatic Promotion

Risk-Based Validation

Autonomous Retraining
```

---

# Requirement → Owner → Verification

| Requirement                                      | Owner                     | Verification        |
| ------------------------------------------------ | ------------------------- | ------------------- |
| Retraining workflows must be auditable           | Governance Capability     | Audit review        |
| Validation must occur before training            | Retraining Capability     | Integration testing |
| Duplicate executions must be prevented           | Retraining Capability     | Workflow testing    |
| Training must be invoked through API contracts   | Training Capability       | Contract testing    |
| Registry integration must be successful          | Model Registry Capability | End-to-end testing  |
| Approval workflow must execute before deployment | Governance Capability     | Approval testing    |

---

# Summary

The Retraining Workflow defines the complete lifecycle of model retraining from trigger generation to deployment. The Retraining Capability evaluates triggers, validates policies, orchestrates training, records metadata, coordinates approval workflows, and ensures only validated models reach production. Startup V1 prioritizes controlled and auditable retraining with manual approvals, while future platform versions evolve toward drift-aware, adaptive, and eventually autonomous retraining systems.
