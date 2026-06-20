# Rollback

## Purpose

This document defines the rollback strategy used by the Deployment Capability.

Rollback is the mechanism that restores a previously stable model deployment when a newly deployed version causes failures, instability, or unacceptable business impact.

The objective is to minimize downtime and quickly restore production service availability.

---

# Goals

The rollback process is designed to:

```text
Restore Service Quickly

Minimize Production Impact

Reduce Mean Time To Recovery (MTTR)

Maintain Auditability

Preserve Deployment Traceability
```

---

# Why Rollback Exists

Even after:

```text
Training

Validation

Testing

Staging Verification

Approval
```

production failures can still occur.

Examples:

```text
Unexpected Data Patterns

Model Loading Errors

Infrastructure Issues

Configuration Mistakes

Performance Regression
```

Rollback provides a controlled recovery mechanism.

---

# Rollback Philosophy

Startup V1 prioritizes:

```text
Simple

Predictable

Reliable
```

over:

```text
Complex Automated Recovery
```

Therefore the rollback strategy is intentionally straightforward.

---

# Rollback Strategy

Startup V1 uses:

```text
Previous Stable Version Rollback
```

---

# Basic Workflow

```text
Model v11 Running
       │
       ▼

Deploy v12
       │
       ▼

Failure Detected
       │
       ▼

Rollback
       │
       ▼

Restore v11
```

---

# Definition of Stable Version

A stable version is:

```text
Previously Deployed

Successfully Verified

Operationally Healthy

Approved For Production
```

Example:

| Version | Status    |
| ------- | --------- |
| v10     | Archived  |
| v11     | Stable    |
| v12     | Failed    |
| v13     | Candidate |

Rollback target:

```text
v11
```

---

# Rollback Triggers

Rollback can be initiated automatically or manually.

---

# Automatic Rollback Triggers

The Deployment Capability may trigger rollback when:

```text
Deployment Verification Fails

Container Startup Fails

Health Check Failure

Service Unreachable
```

---

## Example

```text
Deploy v12
      │
      ▼

Health Check Failed
      │
      ▼

Automatic Rollback
```

---

# Manual Rollback Triggers

Operations teams may initiate rollback when:

```text
Business KPIs Degrade

Prediction Quality Drops

Unexpected Model Behavior

Customer Impact Detected
```

---

## Example

```text
Prediction Accuracy Drops
```

Operations team executes:

```http
POST /deployments/dep-123/rollback
```

---

# Rollback Workflow

```text
Failure Detection
        │
        ▼

Identify Stable Version
        │
        ▼

Create Rollback Plan
        │
        ▼

Redeploy Stable Version
        │
        ▼

Verify Health
        │
        ▼

Restore Traffic
```

---

# Rollback Lifecycle

```text
Running
    │
    ▼

Failure Detected
    │
    ▼

RollingBack
    │
    ▼

Verifying
    │
    ▼

RolledBack
```

---

# Rollback State Model

| State               | Description               |
| ------------------- | ------------------------- |
| rollback_requested  | Rollback initiated        |
| rollback_validating | Rollback validation       |
| rolling_back        | Stable version redeployed |
| rollback_verifying  | Health verification       |
| rolled_back         | Recovery completed        |
| rollback_failed     | Rollback unsuccessful     |

---

# Rollback Validation

Before rollback begins the platform validates:

---

## Stable Version Exists

Example:

```text
v11 Available
```

Required:

```text
YES
```

---

## Artifacts Available

Required:

```text
Model Artifact

Container Image

Metadata
```

---

## Registry Record Exists

Required:

```text
MLflow Version Record
```

---

## Environment Exists

Example:

```text
production
```

must still be available.

---

# Rollback Execution

Rollback follows the same deployment process used for normal releases.

---

## Step 1

Retrieve stable version metadata.

Example:

```text
heart-stroke-prediction:v11
```

---

## Step 2

Retrieve artifacts.

```text
MLflow

S3

Container Registry
```

---

## Step 3

Generate deployment configuration.

---

## Step 4

Update ECS service.

---

## Step 5

Launch stable deployment.

---

## Step 6

Verify health.

---

# ECS Rollback Example

Current:

```text
ECS Service
      │
      ▼

Version 12
```

Rollback:

```text
Update ECS Task Definition
      │
      ▼

Version 11
```

Result:

```text
Version 11 Running
```

---

# Health Verification

Rollback is not complete until verification succeeds.

---

## Container Health

Verify:

```text
Container Running
```

---

## Application Health

Verify:

```http
GET /health
```

Expected:

```json
{
  "status": "healthy"
}
```

---

## Infrastructure Health

Verify:

```text
Target Group

Load Balancer

Service Endpoint
```

---

## Monitoring Health

Verify:

```text
Metrics Available

Logs Available

Alerts Operational
```

---

# Rollback Success Criteria

Rollback succeeds when:

```text
Stable Version Running

Health Checks Pass

Traffic Restored

Monitoring Operational
```

---

# Rollback Failure Scenarios

Rollback itself may fail.

---

## Artifact Missing

Example:

```text
Version 11 Artifact Deleted
```

Result:

```text
Rollback Failed
```

---

## Registry Corruption

Example:

```text
Version Metadata Missing
```

Result:

```text
Rollback Blocked
```

---

## Infrastructure Failure

Example:

```text
ECS Service Update Failure
```

Result:

```text
Rollback Delayed
```

---

## Network Failure

Example:

```text
Registry Unreachable
```

Result:

```text
Rollback Cannot Proceed
```

---

# Rollback Failure Workflow

```text
Rollback Requested
         │
         ▼

Rollback Failed
         │
         ▼

Alert Operations Team
         │
         ▼

Manual Recovery
```

---

# Rollback Metadata

Every rollback generates metadata.

---

## Captured Fields

```text
Rollback ID

Deployment ID

Model Version

Target Version

Timestamp

Outcome

Initiator
```

---

## Example

```yaml
rollback_id: rb-001

deployment_id: dep-123

failed_version: 12

restored_version: 11

status: success
```

---

# Audit Requirements

Every rollback operation must be auditable.

---

## Required Audit Data

```text
Who Initiated Rollback

When Rollback Occurred

Failed Version

Restored Version

Environment

Outcome
```

---

## Example Audit Record

```json
{
  "action": "rollback",
  "deployment_id": "dep-123",
  "from_version": 12,
  "to_version": 11,
  "status": "success"
}
```

---

# Monitoring Rollbacks

Rollback events are monitored.

---

## Metrics

```text
Rollback Count

Rollback Success Rate

Rollback Duration

Recovery Time
```

---

## Alerts

Generated when:

```text
Rollback Failed

Rollback Duration Too Long

Repeated Rollbacks
```

---

# Recovery Objectives

Startup V1 targets:

| Metric                  | Target      |
| ----------------------- | ----------- |
| Rollback Success Rate   | >95%        |
| Mean Recovery Time      | <15 Minutes |
| Service Availability    | >99%        |
| Rollback Detection Time | <5 Minutes  |

---

# Operational Guidelines

Recommended practices:

```text
Never Deploy Using Latest Tag

Keep Previous Stable Version

Retain Artifacts

Retain Registry Metadata

Test Rollback Procedures
```

---

# Startup V1 Limitations

The platform intentionally excludes:

```text
Automated Canary Recovery

Multi-Version Traffic Routing

Cross-Region Rollback

Progressive Rollback Policies
```

to reduce complexity.

---

# Future Enhancements

Growth-stage platform versions may introduce:

```text
Blue-Green Rollback

Canary Rollback

Traffic Weight Recovery

Automatic Policy-Based Rollback

Multi-Region Recovery
```

---

# Trade-Off Analysis

| Decision                         | Benefit                | Limitation              |
| -------------------------------- | ---------------------- | ----------------------- |
| Previous Stable Version Rollback | Simple                 | Limited flexibility     |
| Single Active Deployment         | Easy recovery          | No traffic splitting    |
| ECS-Based Recovery               | Low operational burden | Platform-specific       |
| Manual Approval                  | Safer releases         | Slower deployment cycle |

---

# Summary

The Deployment Capability uses a Previous Stable Version Rollback strategy. When a deployment fails or production issues are detected, the platform identifies the last known healthy model version, redeploys it, verifies system health, and restores service. Every rollback is tracked, audited, monitored, and verified before completion. This approach provides a reliable recovery mechanism while maintaining the simplicity required for a startup-scale MLOps platform.
