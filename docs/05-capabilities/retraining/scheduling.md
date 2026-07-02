# Scheduling

## Purpose

This document defines how retraining jobs are scheduled within the MLOps platform.

Scheduling enables models to be retrained automatically at predefined intervals without requiring manual intervention.

The Scheduling subsystem ensures:

* Models are refreshed regularly
* Retraining occurs predictably
* Compute resources are utilized efficiently
* Operational overhead remains low
* Business SLAs are maintained

---

# Why Scheduling Exists

Not all retraining should depend on performance degradation.

Many model types benefit from periodic retraining.

Examples:

| Model Type             | Reason                      |
| ---------------------- | --------------------------- |
| Forecasting            | Data changes daily          |
| Recommendation Systems | User behavior evolves       |
| Demand Prediction      | Seasonal variation          |
| Risk Models            | Business conditions change  |
| Classification Models  | New training data available |

Without scheduling:

```text
Model Trained

      ↓

Never Updated

      ↓

Model Becomes Stale
```

---

# Scheduling Objectives

The scheduling system must:

* Support recurring retraining
* Support multiple schedules
* Prevent duplicate execution
* Handle missed schedules
* Support future scaling
* Integrate with governance controls

---

# Scheduling Architecture

```text
EventBridge Scheduler

          │

          ▼

Retraining Service

          │

          ▼

Trigger Validation

          │

          ▼

Training Request

          │

          ▼

Training Capability
```

---

# Startup V1 Scheduling Philosophy

Startup V1 prioritizes simplicity.

Scheduling is implemented using:

```text
Amazon EventBridge Scheduler
```

Reasons:

* Fully managed
* No infrastructure maintenance
* Native AWS integration
* Low operational cost
* High reliability

---

# Scheduling Components

## Scheduler

Responsible for:

* Trigger generation
* Cron execution
* Time-based orchestration

---

## Retraining Service

Responsible for:

* Schedule validation
* Trigger evaluation
* Request generation

---

## Training Capability

Responsible for:

* Training execution

---

# Scheduling Lifecycle

```text
Schedule Created

       │

       ▼

Trigger Fired

       │

       ▼

Validation

       │

       ▼

Training Request

       │

       ▼

Execution

       │

       ▼

Completion
```

---

# Schedule Types

The platform supports multiple schedule types.

---

# Type 1: Daily Schedule

## Example

```text
Every Day

02:00 UTC
```

---

## Suitable For

* Real-time forecasting
* Rapidly changing datasets
* Dynamic user behavior models

---

# Example

```cron
0 2 * * *
```

---

# Type 2: Weekly Schedule

## Example

```text
Every Sunday

02:00 UTC
```

---

## Suitable For

* Most startup ML models
* Recommendation systems
* Classification models

---

# Example

```cron
0 2 * * 0
```

---

# Type 3: Monthly Schedule

## Example

```text
1st Day Of Month

03:00 UTC
```

---

## Suitable For

* Stable business processes
* Financial forecasting
* Long-term prediction models

---

# Example

```cron
0 3 1 * *
```

---

# Type 4: Custom Schedule

## Example

```text
Every 14 Days

Every Quarter

Business Specific Schedule
```

---

# Example

```cron
0 1 */14 * *
```

---

# Schedule Configuration Model

Each model defines its own schedule.

Example:

```yaml
model_id: stroke-predictor

schedule:

  enabled: true

  type: weekly

  cron: "0 2 * * 0"

  timezone: UTC
```

---

# Startup V1 Schedule Recommendations

| Model Type      | Recommended Frequency |
| --------------- | --------------------- |
| Forecasting     | Daily                 |
| Recommendation  | Weekly                |
| Classification  | Weekly                |
| NLP Models      | Monthly               |
| Computer Vision | Monthly               |
| Risk Models     | Weekly                |

---

# Timezone Strategy

All schedules are stored using:

```text
UTC
```

---

# Why UTC?

Benefits:

* No daylight savings issues
* Consistent execution
* Easier debugging
* Multi-region compatibility

---

# Execution Windows

Retraining should occur during low-traffic periods.

Recommended window:

```text
01:00 - 05:00 UTC
```

---

# Benefits

* Reduced infrastructure contention
* Lower operational risk
* Better resource utilization

---

# Missed Schedule Handling

A schedule may be missed due to:

```text
Service Outage

AWS Outage

Configuration Error

Deployment Failure
```

---

# Startup V1 Policy

Missed schedules are not replayed automatically.

Instead:

```text
Missed Schedule

      ↓

Alert Generated

      ↓

Manual Review
```

---

# Growth V2 Policy

Introduce:

```text
Automatic Replay

Backfill Execution

Recovery Scheduling
```

---

# Schedule Validation

Before execution:

```text
Schedule Trigger

       │

       ▼

Schedule Enabled?

       │

       ▼

Model Active?

       │

       ▼

Cooldown Satisfied?

       │

       ▼

Active Run Exists?

       │

       ▼

Proceed
```

---

# Cooldown Strategy

## Purpose

Prevent excessive retraining.

---

# Example

Without cooldown:

```text
Schedule

↓

Retrain

↓

Manual Trigger

↓

Retrain Again
```

---

# With Cooldown

```text
Schedule Trigger

↓

Cooldown Active

↓

Execution Skipped
```

---

# Recommended Cooldowns

| Schedule Frequency | Cooldown |
| ------------------ | -------- |
| Daily              | 24 Hours |
| Weekly             | 7 Days   |
| Monthly            | 30 Days  |

---

# Concurrent Execution Prevention

The platform prevents:

```text
Model A

Running

+

Model A

Triggered Again
```

---

# Policy

Only one active retraining execution per model.

---

# Example

```text
Model = stroke-predictor

Status = Running

New Trigger Arrives

↓

Ignored
```

---

# Schedule Priority

Scheduling has the lowest trigger priority.

Priority order:

| Priority | Trigger Type |
| -------- | ------------ |
| 1        | Manual       |
| 2        | Performance  |
| 3        | Drift        |
| 4        | Event        |
| 5        | Schedule     |

---

# Schedule Metadata

Each execution records:

```json
{
  "schedule_id": "sched-001",
  "model_id": "stroke-predictor",
  "trigger_type": "scheduled",
  "scheduled_at": "...",
  "executed_at": "..."
}
```

---

# Monitoring Scheduled Executions

The Monitoring Capability tracks:

```text
Schedules Triggered

Schedules Missed

Schedules Completed

Schedules Failed
```

---

# Scheduling Metrics

Examples:

| Metric                               | Description               |
| ------------------------------------ | ------------------------- |
| retraining_schedule_triggered_total  | Total schedule executions |
| retraining_schedule_failed_total     | Failed schedules          |
| retraining_schedule_missed_total     | Missed schedules          |
| retraining_schedule_duration_seconds | Execution latency         |

---

# Scheduling Events

Examples:

```text
ScheduleCreated

ScheduleTriggered

ScheduleSkipped

ScheduleCompleted

ScheduleFailed
```

---

# Security Controls

Only authorized users may:

```text
Create Schedule

Modify Schedule

Disable Schedule

Delete Schedule
```

---

# Required Roles

| Role              | Access          |
| ----------------- | --------------- |
| Data Scientist    | View            |
| ML Engineer       | Create / Update |
| Platform Engineer | Full Access     |
| Admin             | Full Access     |

---

# Startup V1 Limitations

Startup V1 intentionally excludes:

```text
Adaptive Scheduling

Dynamic Frequency Selection

Business-Aware Scheduling

Cost-Aware Scheduling
```

---

# Growth V2 Evolution

Additional capabilities:

```text
Automatic Replay

Schedule Optimization

Adaptive Frequency

Business Event Integration
```

---

# Enterprise V3 Evolution

Advanced scheduling:

```text
Continuous Training

Policy-Based Scheduling

Risk-Aware Scheduling

Cost-Aware Scheduling

Autonomous Scheduling
```

---

# Anti-Patterns

## Retraining Too Frequently

Avoid:

```text
Every Hour

For Stable Models
```

---

## Ignoring Cooldowns

Avoid:

```text
Schedule

↓

Manual Trigger

↓

Performance Trigger

↓

Three Trainings
```

---

## Local Time Storage

Avoid:

```text
Timezone Specific Scheduling
```

Always use UTC.

---

# Requirement → Owner → Verification

| Requirement                            | Owner                 | Verification         |
| -------------------------------------- | --------------------- | -------------------- |
| Scheduled retraining must be supported | Retraining Capability | Scheduler testing    |
| Schedules must use UTC                 | Retraining Capability | Configuration review |
| Duplicate executions must be prevented | Retraining Capability | Integration testing  |
| Cooldowns must be enforced             | Retraining Capability | Workflow validation  |
| Schedule events must be observable     | Monitoring Capability | Dashboard validation |
| Schedule changes must be audited       | Governance Capability | Audit review         |

---

# Summary

The Scheduling subsystem provides predictable and automated retraining execution for deployed models. Startup V1 uses Amazon EventBridge Scheduler to support daily, weekly, monthly, and custom retraining schedules while enforcing cooldowns, validation checks, and concurrency controls. As the platform matures, scheduling evolves toward adaptive, policy-driven, and autonomous retraining strategies that optimize both model quality and infrastructure cost.
