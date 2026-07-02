# Architecture

## Purpose

This document describes the internal architecture of the Deployment Capability, including its major components, interactions, boundaries, data flow, and integration points with the rest of the MLOps platform.

The Deployment Capability is responsible for transforming approved model artifacts into running production services while ensuring reliability, traceability, governance compliance, and rollback capability.

---

# Architectural Goals

The deployment architecture is designed to achieve:

```text
Reliable Deployments

Controlled Rollouts

Version Traceability

Fast Rollback

Infrastructure Consistency

Operational Visibility

Low Operational Complexity
```

---

# High-Level Architecture

```text
                   ┌─────────────────┐
                   │ Model Registry  │
                   └────────┬────────┘
                            │
                            ▼

                  ┌───────────────────┐
                  │ Deployment API    │
                  └────────┬──────────┘
                           │
                           ▼

                 ┌────────────────────┐
                 │ Deployment Engine  │
                 └────────┬───────────┘
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼

 Artifact Fetcher   State Manager   Governance Validator

        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                          ▼

                 ┌────────────────────┐
                 │ ECS Deployment     │
                 │ Controller         │
                 └────────┬───────────┘
                          │
                          ▼

                 ┌────────────────────┐
                 │ Running Service    │
                 └────────┬───────────┘
                          │
                          ▼

                 ┌────────────────────┐
                 │ Monitoring Stack   │
                 └────────────────────┘
```

---

# Architectural Position

The Deployment Capability sits between Model Registry and Production Services.

```text
Training
    │
    ▼

Experiment Tracking
    │
    ▼

Model Registry
    │
    ▼

Deployment
    │
    ▼

Production Services
    │
    ▼

Consumers
```

---

# Core Components

The capability is composed of several internal components.

---

# Deployment API

## Purpose

Acts as the entry point for deployment requests.

---

## Responsibilities

```text
Receive Deployment Requests

Validate Input

Create Deployment Jobs

Return Deployment Status
```

---

## Example Requests

```http
POST /deployments

POST /deployments/{id}/rollback

GET /deployments/{id}
```

---

## Ownership

The API does not perform deployment itself.

It delegates execution to the Deployment Engine.

---

# Deployment Engine

## Purpose

Core orchestration component.

---

## Responsibilities

```text
Coordinate Deployment Workflow

Manage Execution State

Trigger Deployment Steps

Handle Errors

Initiate Rollbacks
```

---

## Why It Exists

Separates business workflow logic from infrastructure execution.

---

## Example Workflow

```text
Validate
   │
   ▼

Fetch Artifacts
   │
   ▼

Deploy
   │
   ▼

Verify
   │
   ▼

Running
```

---

# Governance Validator

## Purpose

Enforces deployment policies.

---

## Responsibilities

Validate:

```text
Model Approval Status

Environment Rules

Deployment Permissions

Governance Policies
```

---

## Example

Allowed:

```text
Approved Model
```

Rejected:

```text
Draft Model

Archived Model
```

---

# Artifact Fetcher

## Purpose

Retrieve deployment artifacts.

---

## Sources

```text
MLflow Model Registry

S3 Artifact Storage
```

---

## Retrieved Assets

```text
Model Files

Container Images

Configuration Files

Inference Code

Metadata
```

---

## Goal

Guarantee immutable deployment inputs.

---

# State Manager

## Purpose

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
Traceability

Operational Visibility

Recovery Support
```

---

# ECS Deployment Controller

## Purpose

Deploy workloads into AWS ECS.

---

## Responsibilities

```text
Create ECS Task Definitions

Update ECS Services

Start Containers

Scale Tasks

Verify Health
```

---

## Startup V1 Deployment Target

```text
Amazon ECS
```

---

## Future Targets

```text
Amazon EKS

SageMaker Endpoints

Serverless Inference
```

---

# Health Verification Component

## Purpose

Validate successful deployment.

---

## Checks

```text
Container Startup

Health Endpoint

CPU Utilization

Memory Utilization

Application Reachability
```

---

## Outcome

```text
Healthy → Running

Unhealthy → Rollback
```

---

# Rollback Controller

## Purpose

Restore previous stable deployments.

---

## Example

Current:

```text
v12
```

Rollback To:

```text
v11
```

---

## Responsibilities

```text
Identify Previous Version

Redeploy Stable Version

Verify Service Recovery
```

---

# Deployment Metadata Store

## Purpose

Maintain deployment history.

---

## Stored Data

```yaml
deployment_id: dep-001

model_name: fraud-model

model_version: 12

environment: production

status: running

timestamp: 2026-06-01
```

---

## Usage

Supports:

```text
Auditing

Governance

Debugging

Rollback
```

---

# Monitoring Integration

## Purpose

Connect deployed services to platform observability.

---

## Metrics

```text
Request Count

Latency

Error Rate

Availability

Resource Utilization
```

---

## Outputs

```text
Prometheus

Grafana

CloudWatch Logs
```

---

# Internal Data Flow

## Deployment Request

```text
Deployment API
       │
       ▼

Deployment Engine
       │
       ▼

Governance Validation
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

Running Service
```

---

# Failure Flow

```text
Deploy
   │
   ▼

Health Check Failure
   │
   ▼

Rollback Controller
   │
   ▼

Previous Stable Version
```

---

# Integration Points

---

## Model Registry

Provides:

```text
Approved Model Versions

Model Metadata

Artifact References
```

Deployment consumes registry outputs.

---

## Artifact Storage

Provides:

```text
Model Files

Containers

Configuration Assets
```

Deployment never builds artifacts.

---

## Governance Capability

Provides:

```text
Approval State

Policy Rules

Deployment Permissions
```

Deployment enforces these rules.

---

## Monitoring Capability

Provides:

```text
Metrics Collection

Alerting

Dashboards

Log Aggregation
```

Deployment automatically integrates with monitoring.

---

## Retraining Capability

Provides:

```text
New Model Versions
```

Deployment consumes approved outputs from retraining workflows.

---

# Deployment Architecture Principles

## Immutable Artifacts

Once approved:

```text
Model Version

Container Image

Configuration
```

must never change.

---

## Separation Of Concerns

Training owns:

```text
Model Creation
```

Deployment owns:

```text
Model Delivery
```

---

## Idempotent Operations

Repeated deployment requests should produce the same result.

---

## Explicit Versioning

Deployment always references:

```text
Model Name

Model Version
```

Never:

```text
latest
```

for production deployments.

---

## Failure Isolation

Deployment failures must not impact:

```text
Training

Experiment Tracking

Feature Store

Model Registry
```

---

# Startup V1 Architecture Constraints

To keep complexity manageable, Startup V1 uses:

```text
Single AWS Account

Single AWS Region

ECS-Based Deployments

Single Deployment Strategy

Manual Production Approval

Simple Rollback
```

---

# Future Architectural Evolution

Future platform versions may introduce:

```text
Blue-Green Deployment

Canary Deployment

Traffic Splitting

Multi-Region Deployment

Multi-Cloud Deployment

Automated Promotion

Policy-Based Deployment
```

without changing the overall architectural boundaries.

---

# Architecture Success Criteria

The architecture is successful when:

```text
Deployments Are Reliable

Rollbacks Are Fast

Version Tracking Is Accurate

Monitoring Is Automatic

Governance Is Enforced

Operational Complexity Remains Low
```

---

# Summary

The Deployment Capability architecture consists of a Deployment API, Deployment Engine, Governance Validator, Artifact Fetcher, State Manager, ECS Deployment Controller, Rollback Controller, and Monitoring Integration layer. Together, these components provide a controlled, auditable, and reliable path for promoting approved models into production while maintaining traceability, governance compliance, and operational safety.
