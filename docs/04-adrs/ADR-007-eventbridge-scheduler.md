# ADR-007: Amazon EventBridge Scheduler for Platform Automation

**Status:** Accepted

**Date:** 2026-06-14

**Decision Makers:** Platform Engineering Team

---

# Context

The Startup Data & AI Platform requires automated execution of recurring and event-driven workflows throughout the machine learning lifecycle.

Examples include:

* Scheduled model retraining
* Batch inference
* Data quality checks
* Drift detection
* Health monitoring
* Cleanup jobs
* Governance tasks
* Periodic reporting

The platform requires a scheduling mechanism that is reliable, scalable, managed, and tightly integrated with AWS services while avoiding operational overhead.

---

# Problem Statement

How should scheduled and time-based workflows be triggered so that they are:

* Reliable
* Highly available
* Easy to configure
* Infrastructure independent
* Scalable
* Observable
* Cost-effective

while minimizing maintenance effort?

---

# Decision

The platform adopts **Amazon EventBridge Scheduler** as the standard scheduling mechanism for recurring platform workflows.

All scheduled automation will be initiated through EventBridge rather than custom cron services or continuously running scheduler processes.

EventBridge becomes the central orchestration trigger for time-based platform operations.

---

# Why EventBridge Scheduler Was Chosen

## Fully Managed Service

AWS manages scheduling infrastructure.

The platform does not maintain:

* Cron servers
* Scheduler containers
* Dedicated EC2 instances
* Background worker processes

Operational overhead remains minimal.

---

## Native AWS Integration

EventBridge integrates directly with:

* SageMaker
* Lambda
* ECS
* Step Functions
* SNS
* SQS
* CloudWatch
* IAM

No additional orchestration layer is required.

---

## High Reliability

Scheduling operates independently of application availability.

Even if application services restart or scale down, scheduled events continue to execute.

---

## Flexible Scheduling

Supports:

* Cron expressions
* Fixed intervals
* One-time executions
* Time zone awareness
* Retry behavior

The platform can support multiple automation patterns.

---

## Decoupled Architecture

Scheduling triggers workflows without embedding scheduling logic inside business applications.

Applications remain stateless and focused on domain logic.

---

# Alternatives Considered

## Option 1: Linux Cron Jobs

Run cron directly on EC2 instances.

### Advantages

* Familiar
* Simple

### Disadvantages

* Single point of failure
* Infrastructure dependency
* Manual management
* Poor scalability

Rejected.

---

## Option 2: Kubernetes CronJobs

Use Kubernetes scheduling primitives.

### Advantages

* Container native

### Disadvantages

* Requires Kubernetes cluster
* Additional operational complexity
* Unnecessary for startup workloads

Rejected.

---

## Option 3: Application-Level Scheduling

Embed scheduling inside backend services.

### Advantages

* Easy initial implementation

### Disadvantages

* Tight coupling
* Duplicate schedulers
* Failure during application downtime
* Difficult horizontal scaling

Rejected.

---

## Option 4: EventBridge Scheduler (Selected)

Managed scheduling service integrated with AWS.

### Advantages

* Serverless
* Reliable
* Scalable
* Centralized
* Low operational burden

Chosen for the platform.

---

# Scheduling Architecture

Platform automation follows a standardized flow.

```text
Time Schedule
      │
      ▼
EventBridge Scheduler
      │
      ▼
Target Service
      │
      ▼
Platform Workflow
```

The scheduler triggers workflows but does not execute business logic itself.

---

# Typical Scheduled Workflows

Examples include:

## Model Retraining

Execute training pipelines on predefined schedules.

---

## Batch Inference

Generate predictions for large datasets.

---

## Drift Detection

Run statistical comparisons against production data.

---

## Data Quality Validation

Validate newly ingested datasets.

---

## Cleanup Operations

Archive or delete temporary resources.

---

## Governance Audits

Generate compliance reports and metadata checks.

---

## Monitoring Jobs

Perform health verification and synthetic testing.

---

# Relationship with SageMaker

EventBridge may initiate production training.

```text
Schedule
     │
     ▼
EventBridge
     │
     ▼
SageMaker Training Job
```

Training infrastructure remains independent of scheduling.

---

# Relationship with ML Services

ML Services expose workflows.

EventBridge triggers them according to configured schedules.

The scheduling mechanism remains reusable across projects.

---

# Relationship with Applications

Applications should never contain internal cron logic.

Instead:

```text
EventBridge
      │
      ▼
Application API
      │
      ▼
Business Workflow
```

Scheduling is externalized from application code.

---

# Trigger Types

The platform supports:

## Time-Based

* Daily
* Weekly
* Monthly
* Hourly

---

## Fixed Interval

* Every 15 minutes
* Every hour
* Every six hours

---

## One-Time

* Delayed execution
* Future scheduling
* Temporary automation

---

## Hybrid

Time-based scheduling combined with downstream conditional logic.

---

# Security Considerations

EventBridge executes using dedicated IAM roles.

Permissions are scoped only to required targets.

Unauthorized workflow execution is prevented through least-privilege policies.

---

# Observability

Scheduled executions generate:

* Invocation logs
* Failure metrics
* Success metrics
* Retry information
* CloudWatch events

Operational visibility remains centralized.

---

# Failure Handling

Failed schedules may:

* Retry automatically
* Generate alerts
* Publish notifications
* Record execution failures

Missed executions become observable rather than silent.

---

# Cost Considerations

EventBridge is serverless.

Costs scale primarily with:

* Number of schedules
* Number of invocations

No always-running scheduler infrastructure is required.

---

# Consequences

## Positive Consequences

* No scheduler servers
* Centralized automation
* Easy configuration
* Native AWS integration
* Low maintenance
* High reliability
* Decoupled workflows

---

## Negative Consequences

* AWS dependency
* EventBridge quotas
* Limited custom scheduling logic compared to dedicated workflow engines

These trade-offs align with startup priorities.

---

# Rules Enforced

## Rule 1

Recurring workflows use EventBridge.

---

## Rule 2

Applications must not contain embedded cron jobs.

---

## Rule 3

Scheduling and execution remain separate responsibilities.

---

## Rule 4

Scheduled workflows execute through standardized platform interfaces.

---

## Rule 5

Every scheduled execution is observable.

---

## Rule 6

Retries and failures are centrally managed.

---

## Rule 7

Schedules are managed through Infrastructure as Code.

---

## Rule 8

Manual execution remains possible alongside scheduled automation.

---

# Impact on Platform Architecture

## Platform Foundation Layer

Provides scheduling capability.

---

## ML Services Layer

Consumes scheduled triggers for retraining and monitoring.

---

## Data Platform Layer

Uses scheduled validation and ingestion workflows.

---

## Application Layer

Receives external triggers without embedding scheduling logic.

---

# Scalability Implications

As the platform grows:

* Hundreds of schedules can coexist.
* New projects reuse the same scheduling mechanism.
* Automation scales independently of applications.
* Workflow complexity remains isolated from business services.

---

# When This Decision Should Be Revisited

Alternative orchestration systems may become appropriate if:

* Complex multi-step workflows dominate
* Human approval stages become extensive
* Cross-cloud scheduling is required
* Enterprise orchestration standards change

In such cases, workflow engines such as Step Functions or Apache Airflow may complement or replace portions of the scheduling strategy.

---

# Trade-off Summary

| Aspect                 | EventBridge Scheduler |
| ---------------------- | --------------------- |
| Operational Complexity | Low                   |
| Reliability            | High                  |
| Scalability            | High                  |
| AWS Integration        | Excellent             |
| Cost Efficiency        | Excellent             |
| Flexibility            | High                  |
| Startup Suitability    | Excellent             |

---

# Decision Outcome

The Startup Data & AI Platform standardizes Amazon EventBridge Scheduler as the mechanism for initiating recurring and time-based workflows.

By externalizing scheduling from application code and integrating directly with reusable platform capabilities, the architecture achieves reliable automation, reduced operational overhead, and a consistent execution model across machine learning, data engineering, governance, and monitoring workflows.

---

# References

* ADR-003: SageMaker Training
* ADR-006: Amazon S3 Artifact Storage
* ML Services Layer
* Platform Foundation Layer
* Training Flow
* Monitoring Flow

This ADR establishes EventBridge Scheduler as the standard trigger mechanism for automated platform operations and reinforces the platform's event-driven architecture.
