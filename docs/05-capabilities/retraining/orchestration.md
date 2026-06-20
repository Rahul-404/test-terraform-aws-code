# Orchestration

## Purpose

This document defines how the Retraining Capability orchestrates end-to-end retraining workflows across the MLOps platform.

Orchestration is responsible for coordinating multiple platform capabilities and ensuring retraining workflows execute reliably, consistently, and in the correct sequence.

The Retraining Capability does **not perform training itself**. Instead, it orchestrates interactions between:

* Monitoring
* Training
* Experiment Tracking
* Model Registry
* Governance
* Deployment

---

# Why Orchestration Exists

Retraining is not a single operation.

A complete retraining cycle involves:

```text
Trigger

↓

Training

↓

Experiment Tracking

↓

Model Registry

↓

Approval

↓

Deployment
```

Without orchestration:

* Workflows become fragmented
* Failures become difficult to manage
* Lineage becomes incomplete
* Governance becomes inconsistent

---

# Orchestration Goals

The orchestration layer must:

* Coordinate retraining workflows
* Track workflow progress
* Handle failures
* Maintain auditability
* Prevent duplicate execution
* Support retries
* Enable future automation

---

# Position Within Platform

```text
Monitoring

     │

     ▼

Retraining Capability

     │

     ▼

Training

     │

     ▼

Experiment Tracking

     │

     ▼

Model Registry

     │

     ▼

Approval

     │

     ▼

Deployment
```

Retraining acts as the workflow coordinator.

---

# Startup V1 Orchestration Philosophy

Startup V1 favors:

```text
Simple

Event-Driven

Observable

Auditable
```

Rather than building a complex workflow engine.

---

# Startup V1 Orchestration Stack

| Component          | Purpose                |
| ------------------ | ---------------------- |
| EventBridge        | Event routing          |
| Retraining Service | Workflow coordinator   |
| REST APIs          | Capability integration |
| CloudWatch         | Monitoring             |
| DynamoDB           | State tracking         |

---

# Orchestration Architecture

```text
Trigger Source

      │

      ▼

Retraining Service

      │

 ┌────┼────┐
 │    │    │

 ▼    ▼    ▼

Training
Tracking
Monitoring

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

# Core Orchestration Responsibilities

The orchestration layer owns:

```text
Workflow Coordination

State Tracking

Retry Management

Failure Handling

Progress Tracking

Audit Events
```

---

# Responsibilities Not Owned

The orchestration layer does not own:

```text
Training Logic

Experiment Storage

Model Storage

Deployment Logic

Infrastructure Provisioning
```

---

# Orchestration Lifecycle

Every retraining request follows:

```text
Requested

    ↓

Validated

    ↓

Orchestrated

    ↓

Training

    ↓

Registered

    ↓

Approved

    ↓

Deployed
```

---

# Workflow Initiation

Retraining begins when a trigger arrives.

Supported triggers:

```text
Manual

Schedule

Performance

Drift (Future)

Event-Based
```

---

# Example

```json
{
  "trigger_type": "scheduled",
  "model_id": "stroke-predictor"
}
```

---

# Validation Phase

Before orchestration starts:

```text
Trigger Received

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

Execution Allowed?
```

---

# Training Orchestration

After validation:

```text
Retraining Service

       │

       ▼

Training API

       │

       ▼

Training Job
```

---

# Example Request

```json
{
  "retraining_id": "rt-001",
  "model_id": "stroke-predictor",
  "dataset_version": "v5"
}
```

---

# Training Tracking

Once training begins:

```text
Training Started

       │

       ▼

Running

       │

       ▼

Completed
```

or

```text
Training Started

       │

       ▼

Failed
```

---

# State Tracking

Every workflow state is persisted.

---

# Startup V1 Storage

Recommended:

```text
DynamoDB
```

---

# Example State Model

```json
{
  "retraining_id": "rt-001",
  "status": "running",
  "started_at": "2026-06-19T02:00:00Z"
}
```

---

# Experiment Tracking Orchestration

When training succeeds:

```text
Training

    │

    ▼

MLflow Logging
```

---

# Recorded Artifacts

```text
Metrics

Parameters

Artifacts

Dataset Version
```

---

# Registry Orchestration

After experiment logging:

```text
Training Success

      │

      ▼

Register Model
```

---

# Example

```text
model: stroke-predictor

version: 2.1.0
```

---

# Approval Workflow Orchestration

Once registered:

```text
Registry

   │

   ▼

Approval Request

   │

   ▼

Pending Review
```

---

# Approval Outcomes

Possible outcomes:

```text
Approved

Rejected
```

---

# Approved Path

```text
Approved

    │

    ▼

Deployment Request
```

---

# Rejected Path

```text
Rejected

    │

    ▼

Workflow Closed
```

---

# Deployment Orchestration

If approved:

```text
Deployment Capability

       │

       ▼

Deploy Model

       │

       ▼

Production
```

---

# End-to-End Flow

```text
Trigger

   │

   ▼

Validation

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

# Event-Driven Design

Startup V1 follows an event-driven architecture.

---

# Example Events

```text
RetrainingRequested

TrainingStarted

TrainingCompleted

TrainingFailed

ModelRegistered

ApprovalRequested

DeploymentStarted

DeploymentCompleted
```

---

# Event Flow

```text
Capability A

      │

      ▼

EventBridge

      │

      ▼

Capability B
```

---

# Benefits

* Loose coupling
* Easier scaling
* Better observability
* Independent evolution

---

# Retry Strategy

Failures may occur at any stage.

---

# Retryable Failures

Examples:

```text
Network Failure

API Timeout

Temporary Service Failure
```

---

# Strategy

```text
Retry 1

Retry 2

Retry 3

Fail
```

---

# Non-Retryable Failures

Examples:

```text
Invalid Model

Invalid Dataset

Approval Rejected
```

These fail immediately.

---

# Failure Recovery

## Training Failure

```text
Training Failed

      │

      ▼

Update State

      │

      ▼

Emit Alert
```

---

## Registry Failure

```text
Training Success

      │

      ▼

Registry Failure

      │

      ▼

Retry
```

---

## Deployment Failure

```text
Deployment Failed

      │

      ▼

Deployment Rollback
```

---

# Duplicate Execution Prevention

The orchestration layer prevents:

```text
Same Model

+

Same Trigger

+

Same Window
```

from creating multiple workflows.

---

# Example

```text
Model Running

      │

      ▼

New Trigger Arrives

      │

      ▼

Ignored
```

---

# Concurrency Control

Startup V1 policy:

```text
One Active Retraining

Per Model
```

---

# Example

Allowed:

```text
Model A

Model B
```

running simultaneously.

---

Not Allowed:

```text
Model A

Model A
```

running simultaneously.

---

# Audit Trail

Every orchestration action generates audit records.

---

# Examples

```text
Retraining Requested

Retraining Started

Training Completed

Approval Requested

Deployment Triggered
```

---

# Observability Requirements

The orchestration layer must expose:

## Metrics

```text
Active Workflows

Completed Workflows

Failed Workflows

Workflow Duration
```

---

## Logs

```text
State Changes

API Calls

Retries

Failures
```

---

## Events

```text
WorkflowStarted

WorkflowCompleted

WorkflowFailed
```

---

# Startup V1 Limitations

Startup V1 intentionally avoids:

```text
Apache Airflow

Temporal

Argo Workflows

Step Functions
```

Reason:

```text
Operational Simplicity

Lower Cost

Faster Development
```

---

# Growth V2 Evolution

Introduce:

```text
Workflow DAGs

Conditional Routing

Drift-Based Retraining

Advanced Retry Logic
```

---

# Enterprise V3 Evolution

Introduce:

```text
Temporal

Step Functions

Policy Engines

Autonomous Orchestration
```

---

# Orchestration Maturity Roadmap

| Capability           | Startup V1 | Growth V2 | Enterprise V3 |
| -------------------- | ---------- | --------- | ------------- |
| Event Driven         | ✓          | ✓         | ✓             |
| State Tracking       | ✓          | ✓         | ✓             |
| Retry Logic          | Basic      | Advanced  | Intelligent   |
| Workflow Engine      | ✗          | Partial   | Full          |
| Policy Routing       | ✗          | ✓         | ✓             |
| Autonomous Decisions | ✗          | ✗         | ✓             |

---

# Requirement → Owner → Verification

| Requirement                                         | Owner                     | Verification        |
| --------------------------------------------------- | ------------------------- | ------------------- |
| Retraining workflows must be orchestrated centrally | Retraining Capability     | Architecture review |
| Workflow state must be persisted                    | Retraining Capability     | State validation    |
| Training integration must be reliable               | Training Capability       | Integration testing |
| Registry integration must be successful             | Model Registry Capability | End-to-end testing  |
| Deployment requests must be coordinated             | Deployment Capability     | Workflow testing    |
| All workflow actions must be auditable              | Governance Capability     | Audit review        |

---

# Summary

The Orchestration layer is the control plane of the Retraining Capability. It coordinates retraining workflows across Monitoring, Training, Experiment Tracking, Registry, Governance, and Deployment while maintaining state, handling failures, enforcing policies, and preserving auditability. Startup V1 uses a lightweight event-driven orchestration model built on EventBridge and service APIs, while future platform versions evolve toward advanced workflow engines and autonomous retraining systems.
