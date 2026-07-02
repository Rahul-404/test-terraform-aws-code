# Startup v1

## Purpose

This document describes the initial version of the MLOps platform.

Startup v1 represents the minimum architecture required to:

* Build ML products
* Deploy models reliably
* Operate services in production
* Support a small engineering team
* Establish platform standards

The goal is to maximize simplicity while maintaining production readiness.

---

# Vision

Startup v1 is designed for:

```text id="m7r2p8"
Small Team

Limited Budget

Few ML Projects

Fast Iteration

Low Operational Complexity
```

Typical organization:

```text id="k4m8r3"
2-10 Engineers

1-5 ML Projects

Single Cloud Provider
```

---

# Design Philosophy

The platform prioritizes:

```text id="v8m3r5"
Simplicity

Automation

Reusability

Low Cost
```

before advanced enterprise features.

---

# Core Goals

Startup v1 must provide:

| Capability             | Required |
| ---------------------- | -------- |
| Infrastructure as Code | Yes      |
| CI/CD                  | Yes      |
| Model Registry         | Yes      |
| Monitoring             | Yes      |
| Deployment Automation  | Yes      |
| Multi-Cloud            | No       |
| Feature Store          | No       |
| Service Mesh           | No       |

The platform should remain intentionally small.

---

# Platform Scope

Startup v1 supports:

```text id="p2m7r9"
Classification Models

Regression Models

Forecasting Models

NLP Models

Recommendation Systems
```

---

# High-Level Architecture

```text id="n5r8m2"
GitHub
   │
   ▼

GitHub Actions
   │
   ▼

Terraform
   │
   ▼

AWS Infrastructure
   │
   ▼

ML Platform Services
```

---

# Infrastructure Stack

## Cloud Provider

```text id="w7m4p3"
AWS
```

Single cloud only.

Reason:

* Simpler operations
* Lower complexity
* Faster delivery

---

## Infrastructure as Code

```text id="y4m8r1"
Terraform
```

Used for:

* Networking
* Kubernetes
* Storage
* Monitoring

---

# Compute Platform

Startup v1 uses:

```text id="q8m3r4"
Amazon EKS
```

for application and model serving workloads.

Benefits:

* Standardized deployment
* Easy scaling
* Cloud portability later

---

# Container Registry

```text id="x2m7r8"
Amazon ECR
```

Stores:

* API images
* Training images
* Batch processing images

---

# Storage Layer

## Object Storage

```text id="f4m8r2"
Amazon S3
```

Stores:

* Datasets
* Models
* Artifacts
* Reports

---

## Relational Storage

```text id="k7r3m8"
Amazon RDS
```

Used where relational persistence is required.

---

# ML Platform Stack

Startup v1 includes:

```text id="t5m8r1"
MLflow

Model Registry

Experiment Tracking
```

This forms the foundation of the ML lifecycle.

---

# CI/CD Stack

Primary tooling:

```text id="p3m7r9"
GitHub Actions
```

Used for:

* Build
* Test
* Package
* Deploy

---

# Deployment Architecture

```text id="r8m2p5"
Developer
      │
      ▼

GitHub
      │
      ▼

GitHub Actions
      │
      ▼

Docker Build
      │
      ▼

ECR
      │
      ▼

EKS
```

---

# Observability Stack

Startup v1 includes:

```text id="u6m4r8"
Prometheus

Grafana

Loki

Promtail
```

Capabilities:

* Metrics
* Logs
* Dashboards
* Alerts

---

# Security Model

Core security controls:

```text id="n4m9r2"
IAM Roles

OIDC Authentication

Secrets Manager

Encrypted Storage
```

---

# Environment Strategy

Three environments:

```text id="a7m3r5"
dev

staging

prod
```

Purpose:

* Development
* Validation
* Production deployment

---

# Supported Workloads

The platform supports:

## Real-Time Inference

Examples:

```text id="j8m2r4"
Fraud Detection

Heart Stroke Prediction
```

---

## Batch Processing

Examples:

```text id="g4m7r8"
Forecasting

Recommendation Generation
```

---

## Scheduled Training

Examples:

```text id="z5m2r7"
Daily Retraining

Weekly Retraining
```

---

# Governance Scope

Startup v1 includes:

```text id="k2m7p9"
Tagging Standards

Naming Standards

Terraform Standards

CI/CD Standards
```

Lightweight governance only.

---

# Team Model

The platform assumes:

```text id="r6m3p8"
Small Platform Team
```

Example:

| Role              | Count |
| ----------------- | ----- |
| ML Engineer       | 2     |
| Data Scientist    | 2     |
| Platform Engineer | 1     |
| DevOps Engineer   | 1     |

---

# Startup v1 Capabilities

```text id="w4p7m2"
✔ Infrastructure Automation

✔ Containerized Deployment

✔ Model Registry

✔ Experiment Tracking

✔ Monitoring

✔ Logging

✔ Rollback

✔ CI/CD
```

---

# Startup v1 Exclusions

The following are intentionally excluded:

## Multi-Cloud

```text id="n9r4m7"
❌ Not required
```

---

## Service Mesh

```text id="p3m7n8"
❌ Not required
```

---

## Feature Store

```text id="f6r2m9"
❌ Not required
```

---

## Advanced Governance

```text id="v7r3m8"
❌ Not required
```

---

## Multi-Region Deployment

```text id="k5m2r7"
❌ Not required
```

---

# Why These Exclusions Exist

Startup teams should optimize for:

```text id="n2m9r4"
Speed

Focus

Cost Efficiency
```

not maximum architectural sophistication.

---

# Success Criteria

Startup v1 is successful if it can:

```text id="m3r8p5"
Deploy Models Reliably

Recover From Failures

Support Multiple Projects

Enable Fast Iteration
```

without creating excessive operational burden.

---

# Typical Project Lifecycle

```text id="q4m7r2"
Build
  │
  ▼

Train
  │
  ▼

Evaluate
  │
  ▼

Register
  │
  ▼

Deploy
  │
  ▼

Monitor
```

All projects follow this workflow.

---

# Expected Lifetime

Startup v1 typically supports:

```text id="w8m3r6"
1-20 ML Projects

Up To ~20 Engineers

Single Business Unit
```

before significant scaling requirements emerge.

---

# Transition Trigger to Growth v2

The organization should consider Growth v2 when:

```text id="p7m2r8"
Multiple Teams

Platform Ownership Separation

Increasing Infrastructure Costs

Scaling Challenges

Growing Governance Requirements
```

become common.

---

# Architecture Evolution Path

```text id="t4m8r3"
Startup v1
      │
      ▼

Growth v2
      │
      ▼

Enterprise v3
```

Each stage builds upon the previous one rather than replacing it.

---

# Core Principle

```text id="x9m2r5"
Build only what is needed today,
while leaving room
for tomorrow's growth.
```

---

# Related Documents

* Growth v2
* Enterprise v3
* Migration Strategy
* Known Limitations

Together, these documents define how the platform evolves from a startup-scale MLOps system into a larger organizational platform.
