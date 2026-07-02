# Training Capability API Contract

## Purpose

This document defines the external interfaces exposed by the Training Capability.

The API Contract establishes how platform consumers interact with the capability and how training workloads are initiated, monitored, controlled, and queried.

This document defines logical contracts rather than implementation-specific REST endpoints.

---

# Consumers

The Training Capability may be consumed by:

| Consumer                | Purpose                       |
| ----------------------- | ----------------------------- |
| Data Scientists         | Manual training execution     |
| ML Engineers            | Production training pipelines |
| Retraining Capability   | Scheduled retraining          |
| Deployment Capability   | Model validation workflows    |
| Platform Administrators | Operational management        |
| CI/CD Pipelines         | Automated training execution  |

---

# Capability Commands

The Training Capability exposes the following commands.

| Command             | Purpose                      |
| ------------------- | ---------------------------- |
| Create Training Job | Submit new training workload |
| Get Training Job    | Retrieve execution details   |
| List Training Jobs  | Retrieve execution history   |
| Cancel Training Job | Stop execution               |
| Retry Training Job  | Re-execute failed job        |
| Get Training Logs   | Retrieve execution logs      |
| Get Training Status | Query execution state        |

---

# Create Training Job

## Description

Creates a new training execution.

---

## Request

```json
{
  "project_id": "heart-stroke-prediction",
  "experiment_name": "xgboost-v2",
  "dataset_version": "v1.2.0",
  "feature_set_version": "v1",
  "container_image": "training-image:v5",
  "hyperparameters": {
    "max_depth": 8,
    "learning_rate": 0.01
  },
  "requested_by": "data-scientist"
}
```

---

## Response

```json
{
  "job_id": "train-12345",
  "status": "SUBMITTED",
  "created_at": "2026-01-15T10:00:00Z"
}
```

---

# Get Training Job

## Description

Returns detailed information about a training execution.

---

## Request

```http
GET /training/jobs/{job_id}
```

---

## Response

```json
{
  "job_id": "train-12345",
  "status": "RUNNING",
  "project_id": "heart-stroke-prediction",
  "submitted_at": "2026-01-15T10:00:00Z",
  "started_at": "2026-01-15T10:02:00Z"
}
```

---

# List Training Jobs

## Description

Returns training execution history.

---

## Request

```http
GET /training/jobs
```

---

## Optional Filters

```json
{
  "project_id": "heart-stroke-prediction",
  "status": "FAILED",
  "created_after": "2026-01-01"
}
```

---

## Response

```json
{
  "jobs": [
    {
      "job_id": "train-12345",
      "status": "COMPLETED"
    }
  ]
}
```

---

# Cancel Training Job

## Description

Stops an active training execution.

---

## Request

```http
POST /training/jobs/{job_id}/cancel
```

---

## Response

```json
{
  "job_id": "train-12345",
  "status": "CANCELLED"
}
```

---

# Retry Training Job

## Description

Creates a new execution using a previous job configuration.

---

## Request

```http
POST /training/jobs/{job_id}/retry
```

---

## Response

```json
{
  "new_job_id": "train-67890",
  "status": "SUBMITTED"
}
```

---

# Get Training Logs

## Description

Retrieves execution logs.

---

## Request

```http
GET /training/jobs/{job_id}/logs
```

---

## Response

```json
{
  "log_location": "artifact-storage/path"
}
```

---

# Get Training Status

## Description

Returns current execution state.

---

## Request

```http
GET /training/jobs/{job_id}/status
```

---

## Response

```json
{
  "job_id": "train-12345",
  "status": "RUNNING"
}
```

---

# Training State Contract

Training jobs transition through the following lifecycle.

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
COMPLETED
```

Terminal states:

```text
COMPLETED
FAILED
CANCELLED
```

No state may transition directly from COMPLETED to RUNNING.

---

# Training Job Resource Model

Every training job contains the following metadata.

| Field               | Description             |
| ------------------- | ----------------------- |
| job_id              | Unique identifier       |
| project_id          | Project name            |
| experiment_name     | Experiment identifier   |
| dataset_version     | Dataset reference       |
| feature_set_version | Feature reference       |
| container_image     | Training image          |
| status              | Current lifecycle state |
| metrics             | Evaluation metrics      |
| artifact_uri        | Model artifact location |
| submitted_by        | Request owner           |
| created_at          | Submission timestamp    |
| completed_at        | Completion timestamp    |

---

# Events Produced

The Training Capability publishes events consumed by downstream capabilities.

---

## Training Started

```json
{
  "event_type": "TRAINING_STARTED",
  "job_id": "train-12345"
}
```

Consumers:

* Monitoring
* Governance

---

## Training Completed

```json
{
  "event_type": "TRAINING_COMPLETED",
  "job_id": "train-12345",
  "artifact_uri": "s3://..."
}
```

Consumers:

* Model Registry
* Experiment Tracking
* Monitoring

---

## Training Failed

```json
{
  "event_type": "TRAINING_FAILED",
  "job_id": "train-12345",
  "reason": "OutOfMemory"
}
```

Consumers:

* Monitoring
* Governance
* Retraining

---

# Events Consumed

The Training Capability consumes events from other platform capabilities.

---

## Retraining Requested

```json
{
  "event_type": "RETRAINING_REQUESTED",
  "project_id": "heart-stroke-prediction"
}
```

Source:

* Retraining Capability

---

## Scheduled Training Trigger

```json
{
  "event_type": "SCHEDULED_TRAINING"
}
```

Source:

* EventBridge Scheduler

---

# Error Contract

All failures return a standardized response.

```json
{
  "error_code": "DATASET_NOT_FOUND",
  "message": "Specified dataset version does not exist",
  "request_id": "req-12345"
}
```

---

# Standard Error Codes

| Error Code              | Description                |
| ----------------------- | -------------------------- |
| INVALID_REQUEST         | Invalid payload            |
| UNAUTHORIZED            | Missing permission         |
| DATASET_NOT_FOUND       | Dataset unavailable        |
| FEATURE_SET_NOT_FOUND   | Missing feature definition |
| IMAGE_NOT_FOUND         | Training image unavailable |
| RESOURCE_LIMIT_EXCEEDED | Capacity exceeded          |
| TRAINING_FAILED         | Training execution failed  |
| INTERNAL_ERROR          | Unexpected failure         |

---

# SLA Expectations

| Operation           | Target       |
| ------------------- | ------------ |
| Create Training Job | < 5 seconds  |
| Status Retrieval    | < 1 second   |
| Job Cancellation    | < 30 seconds |
| Event Publication   | < 10 seconds |

---

# Summary

The Training Capability API Contract defines how platform users and downstream capabilities interact with training workloads.

The contract includes command interfaces, resource models, state transitions, event contracts, and error handling standards to ensure consistent integration across the platform while maintaining loose coupling between capabilities.
