# Responsibilities

## Purpose

This document defines the responsibilities owned by the Deployment Capability and the responsibilities intentionally delegated to other platform capabilities.

Clearly defined ownership boundaries prevent architectural coupling, operational confusion, and overlapping responsibilities across the platform.

---

# Capability Mission

The Deployment Capability exists to:

```text
Safely Promote Approved Models

Deploy Models To Production

Manage Deployment Lifecycles

Enable Rollback

Maintain Deployment Metadata

Provide Operational Visibility
```

The capability transforms approved model artifacts into running prediction services.

---

# Primary Responsibilities

The Deployment Capability owns the complete lifecycle of model deployment after model approval.

---

# 1. Deployment Request Processing

## Responsibility

Receive and process deployment requests.

---

## Examples

```text
Deploy Model Version 12

Deploy To Staging

Promote To Production
```

---

## Activities

```text
Validate Request

Verify Model Availability

Verify Environment

Create Deployment Record
```

---

## Output

```text
Deployment Job Created
```

---

# 2. Deployment Validation

## Responsibility

Validate deployment eligibility before execution.

---

## Validation Checks

### Model Exists

```text
heart-stroke-model:v12
```

must exist in the registry.

---

### Model Approved

```text
Stage = Approved
```

must be satisfied.

---

### Artifacts Available

Required artifacts:

```text
Model File

Inference Code

Dependencies

Metadata
```

must be accessible.

---

### Target Environment Exists

Example:

```text
staging

production
```

---

## Output

```text
Deployment Approved

or

Deployment Rejected
```

---

# 3. Model Artifact Retrieval

## Responsibility

Retrieve deployment artifacts from platform storage.

---

## Sources

```text
MLflow Registry

S3 Artifact Store
```

---

## Retrieved Assets

```text
Model Artifacts

Inference Container

Configuration

Environment Variables
```

---

## Goal

Ensure deployment uses immutable approved artifacts.

---

# 4. Deployment Orchestration

## Responsibility

Execute deployment workflows.

---

## Activities

```text
Provision Resources

Deploy Container

Configure Networking

Attach Monitoring

Verify Startup
```

---

## Startup V1 Target

```text
Amazon ECS
```

---

## Future Targets

```text
SageMaker Endpoints

EKS

Serverless Inference
```

---

# 5. Environment Promotion

## Responsibility

Promote deployments through environments.

---

## Example Flow

```text
Development
      │
      ▼

Staging
      │
      ▼

Production
```

---

## Goal

Reduce deployment risk before production release.

---

# 6. Deployment State Management

## Responsibility

Track deployment lifecycle state.

---

## States

```text
Requested

Validating

Deploying

Verifying

Running

Failed

RollingBack

RolledBack
```

---

## Benefits

```text
Operational Visibility

Traceability

Recovery Support
```

---

# 7. Version Management

## Responsibility

Track which model version is deployed.

---

## Example

```text
Service

heart-stroke-api

Current Version

v12
```

---

## Goal

Enable reproducibility and rollback.

---

# 8. Deployment Metadata Management

## Responsibility

Maintain deployment records.

---

## Example Metadata

```yaml
deployment_id: dep-123

model_name: heart-stroke-model

model_version: 12

environment: production

deployed_by: github-actions

timestamp: 2026-06-01T10:00:00Z
```

---

## Purpose

Support:

```text
Auditing

Governance

Rollback

Incident Investigation
```

---

# 9. Health Verification

## Responsibility

Verify deployment health before marking deployment successful.

---

## Validation Checks

```text
Container Started

Health Endpoint Responding

Resources Healthy

Application Reachable
```

---

## Result

```text
Running

or

Failed
```

---

# 10. Monitoring Integration

## Responsibility

Connect deployed services to monitoring systems.

---

## Metrics

```text
Request Count

Latency

Error Rate

CPU Usage

Memory Usage
```

---

## Outputs

```text
Prometheus Metrics

Grafana Dashboards

CloudWatch Logs
```

---

# 11. Rollback Execution

## Responsibility

Restore previous stable deployments when issues occur.

---

## Example

Current Deployment:

```text
v12
```

Previous Stable Version:

```text
v11
```

Rollback:

```text
v12 → v11
```

---

## Goal

Minimize production downtime.

---

# 12. Audit Support

## Responsibility

Maintain deployment history.

---

## Example Questions

Deployment should answer:

```text
Who Deployed?

When Deployed?

What Version Was Deployed?

What Environment Was Targeted?

Was Rollback Executed?
```

---

# 13. Governance Enforcement

## Responsibility

Prevent unauthorized deployments.

---

## Examples

Deployment must reject:

```text
Draft Models

Archived Models

Unapproved Models
```

---

## Governance Rule

```text
Only Approved Models
May Enter Production
```

---

# 14. Deployment Observability

## Responsibility

Expose deployment operational status.

---

## Examples

```text
Deployment Success Rate

Deployment Duration

Failure Rate

Rollback Rate
```

---

## Goal

Measure deployment reliability.

---

# Responsibilities Explicitly Not Owned

The Deployment Capability intentionally does not own several concerns.

---

# Model Training

Owned By:

```text
Training Capability
```

Deployment never trains models.

---

# Experiment Tracking

Owned By:

```text
Experiment Tracking Capability
```

Deployment consumes approved models only.

---

# Model Registration

Owned By:

```text
Model Registry Capability
```

Deployment does not create model versions.

---

# Feature Engineering

Owned By:

```text
Feature Store Capability
```

Deployment does not generate features.

---

# Data Processing

Owned By:

```text
Data Platform
```

Deployment only serves predictions.

---

# Business Application Logic

Owned By:

```text
Consumer Applications
```

Examples:

```text
Fraud System

Recommendation Engine

Healthcare Portal
```

Deployment provides prediction services only.

---

# Responsibility Matrix

| Responsibility              | Deployment Owns |
| --------------------------- | --------------- |
| Process Deployment Requests | Yes             |
| Validate Deployments        | Yes             |
| Retrieve Artifacts          | Yes             |
| Deploy Services             | Yes             |
| Manage Versions             | Yes             |
| Track State                 | Yes             |
| Rollback Deployments        | Yes             |
| Monitor Deployments         | Yes             |
| Training Models             | No              |
| Track Experiments           | No              |
| Register Models             | No              |
| Generate Features           | No              |
| Manage Business Logic       | No              |

---

# Startup V1 Scope

Startup V1 focuses on:

```text
Single AWS Region

ECS Deployments

Manual Production Approval

Simple Promotion Flow

Basic Rollback

Monitoring Integration
```

---

# Future Responsibilities

As the platform evolves, Deployment may additionally own:

```text
Canary Releases

Blue-Green Deployments

Traffic Splitting

Automated Promotions

Multi-Region Releases

Policy-Based Deployments
```

These capabilities are intentionally deferred until scale requires them.

---

# Success Criteria

The Deployment Capability successfully fulfills its responsibilities when:

```text
Approved Models Are Deployable

Deployments Are Reproducible

Deployment State Is Traceable

Rollbacks Are Reliable

Production Stability Is Preserved

Governance Rules Are Enforced

Operational Visibility Exists
```

---

# Summary

The Deployment Capability owns the end-to-end process of transforming approved model artifacts into production services. It is responsible for deployment orchestration, validation, version management, state tracking, monitoring integration, governance enforcement, and rollback execution. It deliberately excludes concerns related to training, experimentation, feature engineering, and business application logic, ensuring clear separation of responsibilities across the platform.
