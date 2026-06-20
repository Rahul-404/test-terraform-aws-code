# Training Capability State Management

## Purpose

This document defines how the Training Capability manages execution state throughout the lifecycle of a training workload.

State management provides a consistent mechanism for tracking training progress, enforcing valid lifecycle transitions, supporting recovery operations, and exposing execution status to platform consumers.

The Training Capability is the authoritative owner of training execution state.

---

# Why State Management Exists

Training jobs are long-running asynchronous workloads.

Unlike synchronous API requests, training execution may:

* Run for several minutes or hours
* Fail unexpectedly
* Be retried
* Be cancelled
* Require recovery after platform interruptions

Without explicit state management:

* Job status becomes inconsistent
* Recovery becomes difficult
* Monitoring becomes unreliable
* Automation becomes error-prone

State management provides a single source of truth for execution lifecycle tracking.

---

# State Ownership

The Training Capability owns:

| State Category            | Ownership           |
| ------------------------- | ------------------- |
| Training Lifecycle State  | Training Capability |
| Execution Metadata        | Training Capability |
| Resource Allocation State | Training Capability |
| Failure State             | Training Capability |
| Cancellation State        | Training Capability |

The capability remains responsible for state until execution reaches a terminal state.

---

# State Model

Every training execution progresses through a defined lifecycle.

```text
SUBMITTED
    │
    ▼
VALIDATED
    │
    ▼
QUEUED
    │
    ▼
STARTING
    │
    ▼
INITIALIZING
    │
    ▼
RUNNING
    │
    ▼
ARTIFACTS_CREATED
    │
    ▼
ARTIFACTS_STORED
    │
    ▼
EXPERIMENT_RECORDED
    │
    ▼
PUBLISHED
    │
    ▼
COMPLETED
```

---

# State Definitions

## SUBMITTED

Training request has been received.

Characteristics:

* Request accepted
* Validation not yet started
* No resources allocated

---

## VALIDATED

Request validation completed successfully.

Characteristics:

* Configuration verified
* Dataset references verified
* Permissions verified

No compute resources allocated yet.

---

## QUEUED

Training execution waiting for resource allocation.

Characteristics:

* Request accepted
* Awaiting compute availability

---

## STARTING

Infrastructure resources are being provisioned.

Examples:

* Compute allocation
* Storage preparation
* Runtime initialization

---

## INITIALIZING

Training environment preparation phase.

Examples:

* Container startup
* Dataset retrieval
* Configuration loading
* Feature retrieval

---

## RUNNING

Training workload actively executing.

Examples:

* Data processing
* Model training
* Hyperparameter optimization
* Validation

This is typically the longest-running state.

---

## ARTIFACTS_CREATED

Training execution completed.

Artifacts generated locally.

Examples:

* Models
* Checkpoints
* Reports

Artifacts not yet published.

---

## ARTIFACTS_STORED

Artifacts successfully persisted.

Examples:

* S3 upload completed
* Artifact metadata recorded

---

## EXPERIMENT_RECORDED

Experiment Tracking Capability updated.

Examples:

* Metrics recorded
* Parameters stored
* Run metadata published

---

## PUBLISHED

Outputs distributed to downstream consumers.

Examples:

* Model Registry notified
* Monitoring notified
* Governance metadata published

---

## COMPLETED

Execution successfully finished.

Characteristics:

* Outputs available
* Resources released
* No further transitions allowed

Terminal state.

---

# Terminal States

Training executions may end in one of three terminal states.

```text
COMPLETED
FAILED
CANCELLED
```

Once a terminal state is reached:

* No further state transitions occur
* State becomes immutable
* Historical record retained

---

# Failure State

Training may fail at any intermediate stage.

```text
ANY ACTIVE STATE
        │
        ▼
FAILED
```

---

## Failure Metadata

Failures should capture:

| Field             | Description                  |
| ----------------- | ---------------------------- |
| Failure Code      | Standardized error code      |
| Failure Reason    | Human-readable explanation   |
| Failure Timestamp | Time of failure              |
| Failure Stage     | State where failure occurred |
| Logs Reference    | Debugging information        |

---

## Example

```json
{
  "state": "FAILED",
  "failure_code": "OUT_OF_MEMORY",
  "failure_reason": "Training container exceeded memory limit"
}
```

---

# Cancellation State

Authorized users may cancel active executions.

```text
RUNNING
    │
    ▼
CANCELLED
```

Cancellation may occur from:

* QUEUED
* STARTING
* INITIALIZING
* RUNNING

---

# Valid State Transitions

## Successful Flow

```text
SUBMITTED
→ VALIDATED
→ QUEUED
→ STARTING
→ INITIALIZING
→ RUNNING
→ ARTIFACTS_CREATED
→ ARTIFACTS_STORED
→ EXPERIMENT_RECORDED
→ PUBLISHED
→ COMPLETED
```

---

## Failure Flow

```text
ANY ACTIVE STATE
→ FAILED
```

---

## Cancellation Flow

```text
QUEUED
→ CANCELLED

STARTING
→ CANCELLED

INITIALIZING
→ CANCELLED

RUNNING
→ CANCELLED
```

---

# Invalid State Transitions

The following transitions are prohibited.

```text
COMPLETED → RUNNING
FAILED → RUNNING
CANCELLED → RUNNING
```

```text
SUBMITTED → RUNNING
```

```text
QUEUED → COMPLETED
```

State transitions must always follow the defined lifecycle.

---

# State Persistence

Training state must survive service restarts and infrastructure failures.

State persistence stores:

* Current status
* Execution metadata
* Failure metadata
* Resource references
* Artifact references

The persisted state acts as the authoritative source of truth.

---

# State Recovery

Recovery procedures depend on the current state.

| State        | Recovery Strategy          |
| ------------ | -------------------------- |
| SUBMITTED    | Resume validation          |
| VALIDATED    | Resume scheduling          |
| QUEUED       | Requeue execution          |
| STARTING     | Retry resource allocation  |
| INITIALIZING | Restart initialization     |
| RUNNING      | Mark failed or restart job |
| COMPLETED    | No recovery required       |

---

# State Consistency Principles

The Training Capability follows several consistency rules.

## Single Source of Truth

Only the Training Capability may update execution state.

---

## Monotonic Progression

State should move forward through the lifecycle.

Backward transitions are prohibited.

---

## Atomic State Changes

State transitions should either:

* Complete successfully
* Fail completely

Partial transitions are not allowed.

---

## Auditability

Every state transition should be recorded.

Examples:

* Previous state
* New state
* Timestamp
* Actor
* Correlation ID

---

# State Transition Events

Every state change generates an event.

Example:

```json
{
  "event_type": "TRAINING_STATE_CHANGED",
  "job_id": "train-12345",
  "previous_state": "RUNNING",
  "new_state": "ARTIFACTS_CREATED"
}
```

Consumers:

* Monitoring
* Governance
* Audit Systems

---

# Monitoring Requirements

The following metrics should be collected.

| Metric                   | Description           |
| ------------------------ | --------------------- |
| Jobs Submitted           | New requests          |
| Jobs Running             | Active executions     |
| Jobs Completed           | Successful executions |
| Jobs Failed              | Failed executions     |
| Jobs Cancelled           | Cancelled executions  |
| State Transition Latency | Time spent per state  |

These metrics help identify bottlenecks and operational issues.

---

# Summary

The Training Capability owns the complete lifecycle state of every training execution.

State management provides a reliable, auditable, and recoverable mechanism for tracking long-running machine learning workloads while ensuring consistent behavior across training, monitoring, governance, experiment tracking, and deployment workflows.
