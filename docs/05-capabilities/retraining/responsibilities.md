# Responsibilities

## Purpose

This document defines the responsibilities, ownership boundaries, and operational scope of the Retraining Capability.

The Retraining Capability serves as the orchestration layer that determines when models should be retrained and coordinates the retraining lifecycle across the MLOps platform.

It does **not perform model training itself**. Instead, it manages retraining decisions and execution workflows.

---

# Mission Statement

The Retraining Capability exists to:

> Ensure deployed models remain accurate, reliable, and business-aligned by continuously evaluating retraining conditions and coordinating model refresh workflows.

---

# Core Responsibilities

The capability is responsible for:

```text
Detect Need For Retraining

Evaluate Retraining Policies

Schedule Retraining Jobs

Orchestrate Training Requests

Track Retraining Executions

Manage Retraining Metadata

Coordinate Approval Workflows

Provide Retraining Visibility
```

---

# Responsibility Areas

The capability responsibilities are grouped into six domains.

| Domain                 | Responsibility                         |
| ---------------------- | -------------------------------------- |
| Trigger Management     | Determine when retraining should occur |
| Scheduling             | Execute recurring retraining jobs      |
| Orchestration          | Coordinate retraining workflows        |
| Metadata Management    | Track retraining history               |
| Governance Integration | Support approvals and audits           |
| Observability          | Expose metrics, logs, and events       |

---

# Responsibility 1: Trigger Evaluation

## Purpose

Determine whether a model should be retrained.

---

# Supported Trigger Types

The Retraining Capability evaluates:

```text
Scheduled Triggers

Performance Triggers

Drift Triggers

Manual Triggers

Business Event Triggers
```

---

# Example

```text
Current Accuracy = 81%

Required Accuracy = 85%

↓

Retraining Required
```

---

# Deliverables

The capability must:

* Evaluate trigger conditions
* Validate trigger configuration
* Prevent invalid triggers
* Record trigger decisions

---

# Not Responsible For

The capability does not:

* Calculate model metrics directly
* Detect drift directly

Those responsibilities belong to Monitoring.

---

# Responsibility 2: Retraining Scheduling

## Purpose

Manage recurring retraining execution.

---

# Examples

```text
Daily

Weekly

Monthly

Quarterly
```

---

# Startup V1 Strategy

Uses:

```text
Amazon EventBridge Scheduler
```

for recurring retraining jobs.

---

# Deliverables

The capability must:

* Create schedules
* Manage schedules
* Execute schedules
* Audit schedule execution

---

# Not Responsible For

The capability does not:

* Manage infrastructure scheduling systems
* Provision EventBridge

Those belong to Infrastructure.

---

# Responsibility 3: Retraining Orchestration

## Purpose

Coordinate retraining execution.

---

# Workflow

```text
Trigger Detected

      │

      ▼

Create Retraining Request

      │

      ▼

Invoke Training Capability

      │

      ▼

Track Execution

      │

      ▼

Process Results
```

---

# Deliverables

The capability must:

* Create training requests
* Track training lifecycle
* Process training results
* Handle failures

---

# Not Responsible For

The capability does not:

* Execute training code
* Provision compute
* Manage containers

Those belong to Training.

---

# Responsibility 4: Retraining Execution Tracking

## Purpose

Maintain retraining lifecycle state.

---

# Example States

```text
Pending

Running

Succeeded

Failed

Cancelled
```

---

# Deliverables

The capability must:

* Track execution status
* Record timestamps
* Store execution metadata
* Expose execution history

---

# Example Metadata

```json
{
  "retraining_id": "rt-001",
  "model_id": "stroke-predictor",
  "trigger": "weekly_schedule",
  "status": "completed"
}
```

---

# Responsibility 5: Metadata Management

## Purpose

Maintain retraining history and lineage.

---

# Stored Information

| Metadata        | Purpose                 |
| --------------- | ----------------------- |
| Retraining ID   | Execution tracking      |
| Trigger Type    | Why retraining occurred |
| Model ID        | Model association       |
| Dataset Version | Data lineage            |
| Training Job ID | Traceability            |
| Result Status   | Operational visibility  |

---

# Benefits

Metadata supports:

* Auditing
* Compliance
* Lineage
* Investigations

---

# Responsibility 6: Governance Integration

## Purpose

Ensure retraining activities remain controlled and auditable.

---

# Governance Activities

The capability must:

* Emit audit events
* Record trigger decisions
* Preserve retraining history
* Support model approval workflows

---

# Example

```text
Retraining Triggered

      │

      ▼

New Model Produced

      │

      ▼

Approval Required

      │

      ▼

Registry Workflow
```

---

# Not Responsible For

The capability does not:

* Approve models
* Reject models
* Manage compliance policies

Those belong to Governance and Registry.

---

# Responsibility 7: Approval Workflow Coordination

## Purpose

Support post-training promotion decisions.

---

# Workflow

```text
Retraining Completed

       │

       ▼

Model Registered

       │

       ▼

Approval Flow

       │

       ▼

Deployment
```

---

# Deliverables

The capability must:

* Submit approval requests
* Track approval status
* Maintain promotion history

---

# Responsibility 8: Failure Handling

## Purpose

Handle retraining failures safely.

---

# Failure Examples

```text
Training Failure

Data Missing

Invalid Trigger

Approval Rejected

Infrastructure Failure
```

---

# Deliverables

The capability must:

* Detect failures
* Record failures
* Emit alerts
* Support retries

---

# Responsibility 9: Observability

## Purpose

Provide visibility into retraining operations.

---

# Metrics

Examples:

```text
Retraining Requests

Retraining Success Rate

Retraining Failures

Average Duration
```

---

# Logs

Examples:

```text
Trigger Evaluated

Retraining Started

Retraining Failed

Approval Requested
```

---

# Events

Examples:

```text
RetrainingTriggered

RetrainingCompleted

RetrainingFailed
```

---

# Responsibility 10: Cost Control

## Purpose

Prevent excessive retraining activity.

---

# Risks

Without controls:

```text
Too Many Training Jobs

Compute Waste

Budget Overruns
```

---

# Controls

The capability should:

* Rate limit triggers
* Deduplicate requests
* Enforce cooldown periods
* Track retraining frequency

---

# Responsibility 11: Platform Integration

## Purpose

Coordinate with other platform capabilities.

---

# Integration Matrix

| Capability          | Interaction                 |
| ------------------- | --------------------------- |
| Monitoring          | Receives retraining signals |
| Training            | Starts training jobs        |
| Experiment Tracking | Stores execution metadata   |
| Model Registry      | Registers resulting models  |
| Deployment          | Promotes approved models    |
| Governance          | Emits audit records         |

---

# Capability Ownership

## Owned By Retraining

The capability owns:

```text
Trigger Evaluation

Scheduling

Workflow Coordination

Execution Tracking

Metadata

Observability
```

---

## Not Owned By Retraining

The capability does not own:

```text
Model Training

Experiment Storage

Model Registration

Deployment

Infrastructure Provisioning

Monitoring Metrics Collection
```

---

# Responsibility Boundaries

## What Retraining Owns

```text
When to Retrain

Why to Retrain

How to Coordinate Retraining
```

---

## What Retraining Does Not Own

```text
How Models Train

How Models Deploy

How Metrics Are Generated
```

---

# Startup V1 Responsibilities

Startup V1 intentionally limits scope.

Supported:

```text
Manual Triggers

Scheduled Retraining

Basic Performance Triggers

Execution Tracking

Approval Coordination
```

---

Deferred:

```text
Advanced Drift Detection

Continuous Training

Online Learning

Self-Healing Retraining
```

---

# Future Responsibilities

## Growth V2

Additional responsibilities:

```text
Drift-Based Retraining

Adaptive Scheduling

Automated Trigger Evaluation

Policy-Based Retraining
```

---

## Enterprise V3

Additional responsibilities:

```text
Continuous Training

Self-Optimizing Pipelines

Intelligent Trigger Selection

Automated Promotion Policies
```

---

# Responsibility → Owner → Verification

| Responsibility                | Owner                     | Verification        |
| ----------------------------- | ------------------------- | ------------------- |
| Evaluate retraining triggers  | Retraining Capability     | Trigger testing     |
| Manage retraining schedules   | Retraining Capability     | Schedule validation |
| Coordinate training workflows | Retraining Capability     | Integration testing |
| Track retraining executions   | Retraining Capability     | Metadata review     |
| Emit audit records            | Governance Capability     | Audit validation    |
| Expose retraining metrics     | Monitoring Capability     | Dashboard review    |
| Submit approval requests      | Model Registry Capability | Workflow testing    |

---

# Summary

The Retraining Capability is responsible for deciding when retraining should occur and coordinating the end-to-end retraining lifecycle. It evaluates triggers, manages schedules, orchestrates training workflows, tracks execution state, integrates with governance processes, and provides operational visibility. The capability deliberately avoids owning model training, deployment, or infrastructure concerns, ensuring clear separation of responsibilities across the MLOps platform.
