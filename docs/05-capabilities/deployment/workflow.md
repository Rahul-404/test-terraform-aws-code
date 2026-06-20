# Workflow

## Purpose

This document describes the end-to-end workflow of the Deployment Capability, from receiving an approved model deployment request to operating a production prediction service.

The workflow ensures that deployments are:

* Repeatable
* Auditable
* Governed
* Observable
* Recoverable

---

# Workflow Goals

The deployment workflow is designed to:

```text
Deploy Approved Models Safely

Prevent Unauthorized Releases

Maintain Version Traceability

Enable Fast Rollback

Minimize Downtime

Integrate Monitoring Automatically
```

---

# High-Level Workflow

```text
Approved Model
       │
       ▼

Deployment Request
       │
       ▼

Validation
       │
       ▼

Artifact Retrieval
       │
       ▼

Deployment Execution
       │
       ▼

Health Verification
       │
       ▼

Production Service
       │
       ▼

Monitoring
```

---

# Workflow Actors

| Actor                 | Responsibility             |
| --------------------- | -------------------------- |
| Data Scientist        | Produces model             |
| Model Registry        | Stores approved models     |
| Deployment Capability | Executes deployment        |
| Governance Capability | Enforces approval policies |
| ECS Platform          | Runs containers            |
| Monitoring Capability | Collects metrics and logs  |
| Consumer Applications | Use prediction service     |

---

# Deployment Lifecycle

Every deployment follows a defined lifecycle.

```text
Requested
    │
    ▼

Validating
    │
    ▼

Deploying
    │
    ▼

Verifying
    │
    ▼

Running
```

---

## Failure Path

```text
Deploying
     │
     ▼

Failed
     │
     ▼

Rollback
     │
     ▼

Previous Stable Version
```

---

# Step 1: Model Approval

Deployment begins only after governance approval.

---

## Input

Example:

```text
Model: heart-stroke-prediction

Version: 12

Stage: Approved
```

---

## Source

```text
MLflow Model Registry
```

---

## Governance Rule

```text
Only Approved Models
Can Be Deployed
```

---

# Step 2: Deployment Request

A deployment request is submitted.

---

## Example

```http
POST /deployments
```

```json
{
  "model_name": "heart-stroke-prediction",
  "model_version": 12,
  "environment": "production"
}
```

---

## Result

Deployment record created.

Example:

```text
deployment-id: dep-123
status: Requested
```

---

# Step 3: Request Validation

The Deployment Engine validates the request.

---

## Validation Checks

### Model Exists

```text
heart-stroke-prediction:v12
```

must exist.

---

### Approval Status

```text
Approved
```

must be present.

---

### Artifacts Available

Required:

```text
Model Artifact

Container Image

Inference Code

Configuration
```

---

### Environment Valid

Example:

```text
staging

production
```

---

## Outcome

```text
Validation Passed
```

or

```text
Validation Failed
```

---

# Step 4: Artifact Retrieval

The Deployment Capability retrieves deployment assets.

---

## Sources

```text
MLflow Registry

Amazon S3
```

---

## Retrieved Assets

```text
Model Artifact

Docker Image

Inference Code

Deployment Metadata
```

---

## Goal

Guarantee immutable deployment inputs.

---

# Step 5: Deployment Preparation

Deployment configuration is assembled.

---

## Example

```yaml
environment: production

replicas: 2

cpu: 512

memory: 1024
```

---

## Activities

```text
Generate Deployment Plan

Create ECS Task Definition

Prepare Environment Variables

Configure Networking
```

---

# Step 6: Deployment Execution

Deployment Engine initiates deployment.

---

## Startup V1 Target

```text
Amazon ECS
```

---

## Workflow

```text
Create Task Definition
        │
        ▼

Update ECS Service
        │
        ▼

Launch Containers
```

---

## Deployment State

```text
Deploying
```

---

# Step 7: Container Startup

ECS launches the prediction service.

---

## Container Components

```text
FastAPI Application

Model Loader

Prediction Endpoint

Health Endpoint
```

---

## Example

```text
/api/v1/predict

/health
```

---

# Step 8: Health Verification

The platform verifies deployment health.

---

## Checks

### Container Running

```text
Container Status = Running
```

---

### Health Endpoint

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

### Resource Checks

```text
CPU Usage

Memory Usage

Startup Time
```

---

### Network Reachability

Verify:

```text
Load Balancer

Target Group

Service Endpoint
```

---

## Result

```text
Healthy
```

or

```text
Unhealthy
```

---

# Step 9: Deployment Success

Successful deployments become active.

---

## State Transition

```text
Verifying
      │
      ▼

Running
```

---

## Metadata Updated

Example:

```yaml
deployment_id: dep-123

status: running

model_version: 12

environment: production
```

---

# Step 10: Monitoring Registration

The deployment is automatically connected to monitoring.

---

## Metrics Collected

```text
Request Count

Latency

Error Rate

Availability

CPU Usage

Memory Usage
```

---

## Logging

Application logs are forwarded to:

```text
CloudWatch

Loki
```

---

## Dashboards

Displayed in:

```text
Grafana
```

---

# Step 11: Production Serving

Consumers begin sending requests.

---

## Example Flow

```text
Client
   │
   ▼

Load Balancer
   │
   ▼

Prediction Service
   │
   ▼

Model
   │
   ▼

Prediction
```

---

## Example Request

```http
POST /predict
```

---

## Example Response

```json
{
  "risk_score": 0.87
}
```

---

# Rollback Workflow

Rollback occurs when deployment verification fails or production incidents occur.

---

# Trigger

Examples:

```text
Health Check Failure

High Error Rate

Container Crash

Performance Regression
```

---

# Rollback Process

```text
Current Version
      │
      ▼

Version 12
      │
      ▼

Rollback
      │
      ▼

Version 11
```

---

# Rollback Steps

```text
Identify Stable Version

Redeploy Stable Version

Verify Health

Update Metadata
```

---

# Rollback Result

```text
Status: RolledBack
```

---

# Failure Workflow

When deployment fails:

```text
Deploying
      │
      ▼

Failed
      │
      ▼

Rollback
      │
      ▼

Previous Stable Version
```

---

## Failure Examples

```text
Artifact Missing

Container Crash

Configuration Error

Network Failure

Health Check Failure
```

---

# Deployment State Transitions

```text
Requested
     │
     ▼

Validating
     │
     ▼

Deploying
     │
     ▼

Verifying
     │
     ▼

Running
```

---

## Failure Path

```text
Validating
      │
      ▼

Failed
```

or

```text
Deploying
      │
      ▼

Failed
```

or

```text
Verifying
      │
      ▼

Failed
```

---

## Rollback Path

```text
Failed
     │
     ▼

RollingBack
     │
     ▼

RolledBack
```

---

# Environment Promotion Workflow

Models may move through multiple environments.

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

## Benefits

```text
Reduced Deployment Risk

Environment Validation

Controlled Releases
```

---

# Audit Workflow

Every deployment generates audit records.

---

## Captured Metadata

```text
Deployment ID

Model Version

Environment

Timestamp

Initiator

Outcome
```

---

## Example

```yaml
deployment_id: dep-123

model_version: 12

environment: production

status: running

deployed_by: github-actions
```

---

# Startup V1 Workflow Characteristics

Startup-focused design choices:

```text
Single AWS Region

ECS Deployments

Manual Approval

Single Active Model Version

Basic Rollback

Monitoring Integration
```

---

# Future Workflow Enhancements

Future platform versions may add:

```text
Canary Deployment

Blue-Green Deployment

Traffic Splitting

Automated Promotion

Multi-Region Rollout

Policy-Based Releases
```

---

# Success Criteria

The workflow is successful when:

```text
Approved Models Deploy Successfully

Deployments Are Traceable

Rollbacks Are Reliable

Monitoring Is Automatic

Downtime Is Minimal

Governance Rules Are Enforced
```

---

# Summary

The Deployment workflow begins with an approved model in the Model Registry and progresses through validation, artifact retrieval, deployment execution, health verification, monitoring integration, and production serving. Every deployment is tracked through explicit lifecycle states and can be safely rolled back if issues occur. This workflow provides a reliable and auditable mechanism for delivering machine learning models into production environments.
