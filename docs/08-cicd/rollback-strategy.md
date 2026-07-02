# Rollback Strategy

## Purpose

This document defines how the platform handles rollback across infrastructure, applications, and machine learning systems.

Rollback is the controlled process of reverting a system to a previously known stable state after a failed deployment or degradation.

The goal is to minimize:

* Downtime
* Data loss
* User impact
* Recovery time

---

# Objectives

The rollback strategy aims to provide:

* Fast recovery from failures
* Safe reversal of changes
* Minimal service disruption
* Predictable recovery steps
* Version-based restoration
* Automated rollback paths where possible

Rollback is a **first-class capability**, not an afterthought.

---

# Scope of Rollback

Rollback applies to all platform domains:

```text id="m7r2p8"
Infrastructure

Applications

Machine Learning Models
```

Each domain has different rollback mechanics but follows the same principles.

---

# Rollback Principles

## 1. Version-Based Recovery

Rollback always returns to a known version.

Examples:

```text id="k4m8r3"
Terraform state version

Container image tag

ML model version
```

---

## 2. Immutability

Only immutable artifacts can be rolled back.

```text id="v8m3r5"
✔ v1.2.0 image
✔ model v5
✔ terraform state version

❌ “latest”
```

---

## 3. Fast Recovery

Rollback should be faster than fixing forward.

---

## 4. Safe Reversal

Rollback must not introduce additional instability.

---

## 5. Observability First

Rollback decisions must be based on:

```text id="p2m7r9"
Metrics

Logs

Alerts

Health signals
```

---

# Rollback Triggers

Rollback can be triggered by:

```text id="n5r8m2"
Deployment failure

Health check failure

Increased error rate

Latency spike

Manual intervention

Monitoring alerts
```

---

# Rollback Strategy Overview

All systems follow a general pattern:

```text id="w7m4p3"
Detect Issue
     │
     ▼

Identify Last Stable Version
     │
     ▼

Revert Deployment
     │
     ▼

Validate System Health
     │
     ▼

Restore Service
```

---

# Infrastructure Rollback

Infrastructure rollback is handled using Terraform state and versioned configurations.

---

## Approach

```text id="y4m8r1"
Terraform Apply Failure
        │
        ▼

Revert Git Commit
        │
        ▼

Re-run Terraform Plan
        │
        ▼

Apply Previous State
```

---

## State-Based Recovery

Terraform state is the source of truth.

Rollback options:

```text id="q8m3r4"
Revert code version

Restore previous state snapshot

Re-apply last known good plan
```

---

## Safety Considerations

* Avoid manual state edits
* Avoid partial applies
* Always validate plan before apply

---

# Application Rollback

Application rollback is performed at the Kubernetes and image level.

---

## Approach

```text id="x2m7r8"
New Deployment Fails
        │
        ▼

Switch to Previous Image Tag
        │
        ▼

Re-deploy Service
```

---

## Kubernetes Rollback

Kubernetes supports native rollback:

```text id="f4m8r2"
kubectl rollout undo deployment <service>
```

or via GitOps revision rollback.

---

## Image-Based Rollback

Preferred approach:

```text id="k7r3m8"
service:v2.0.0 → service:v1.9.0
```

---

## Key Requirement

All images must be:

* Versioned
* Immutable
* Stored in registry

---

# ML Model Rollback

ML rollback involves reverting to a previous model version.

---

## Approach

```text id="t5m8r1"
Model v5 deployed
       │
       ▼

Issue Detected
       │
       ▼

Switch to Model v4
```

---

## Model Registry Rollback

Using MLflow or similar registry:

```text id="p3m7r9"
Production → Staging → Archived
```

Rollback is simply a state transition.

---

## Safe Deployment Requirement

Only validated models should be eligible for rollback target.

---

# Automated Rollback

Some failures trigger automatic rollback.

Examples:

```text id="r8m2p5"
Health check failure

Crash loop detection

High error rate threshold breach
```

---

## Automation Flow

```text id="u6m4r8"
Deploy New Version
       │
       ▼

Monitor Metrics
       │
       ▼

Threshold Breach?
       │
      Yes
       ▼

Automatic Rollback
```

---

# Manual Rollback

Manual rollback is triggered when:

* Monitoring is inconclusive
* Partial failure occurs
* Business approval is required

---

## Flow

```text id="n4m9r2"
Incident Detected
       │
       ▼

Engineer Decision
       │
       ▼

Rollback Execution
```

---

# Rollback Time Objectives

The platform defines recovery targets:

```text id="a7m3r5"
Infrastructure: < 10–15 min

Application: < 5 min

ML Model: < 2–5 min
```

These are startup-grade targets optimized for fast recovery.

---

# Rollback Safety Mechanisms

## 1. Blue-Green Deployments (Optional)

```text id="j8m2r4"
Blue = Current
Green = New

Switch traffic on failure
```

---

## 2. Canary Rollback

```text id="g4m7r8"
Deploy to small % users
Rollback if metrics degrade
```

---

## 3. Feature Flags

```text id="z5m2r7"
Disable feature without rollback
```

---

# Observability for Rollback

Rollback decisions depend on monitoring:

```text id="k2m7p9"
Error Rate

Latency

Throughput

System Health

Model Drift
```

---

# Rollback Decision Matrix

| Condition              | Action                               |
| ---------------------- | ------------------------------------ |
| Deployment failure     | Immediate rollback                   |
| High error rate        | Automated rollback                   |
| Latency spike          | Investigate + rollback if persistent |
| Model drift            | Model rollback                       |
| Infrastructure failure | Terraform rollback                   |

---

# Anti-Patterns

## No Rollback Plan

```text id="r6m3p8"
❌ “We will fix forward”
```

Problem:

* Extended downtime

---

## Mutable Deployments

```text id="w4p7m2"
❌ Overwriting “latest”
```

Problem:

* Cannot recover reliably

---

## Partial Rollback

```text id="n9r4m7"
❌ Only some components rolled back
```

Problem:

* System inconsistency

---

## Manual Production Fixes

```text id="p3m7n8"
❌ SSH hotfixes
```

Problem:

* No audit trail

---

## Missing Observability

```text id="f6r2m9"
❌ Blind rollback decisions
```

Problem:

* Incorrect recovery actions

---

# Rollback Strategy Patterns

## Revert to Last Known Good State

Primary strategy:

```text id="v7r3m8"
Always fallback to stable version
```

---

## Immutable Rollback Targets

Only versioned artifacts can be restored.

---

## Fast Path Recovery

Rollback should be faster than debugging.

---

## Consistent State Restoration

All components must match the same release version.

---

# Example Startup Rollback Flow

```text id="k5m2r7"
Deploy v2.0.0
      │
      ▼

Metrics Degrade
      │
      ▼

Alert Triggered
      │
      ▼

Rollback to v1.9.0
      │
      ▼

System Stable
```

---

# Future Evolution

As the platform evolves, rollback may include:

* Automated canary rollback systems
* AI-driven anomaly detection rollback
* Multi-region rollback orchestration
* Progressive delivery integration
* Self-healing infrastructure

---

# Core Principle

```text id="n2m9r4"
Every deployment must be
reversible,
fast to recover,
and safe to undo.
```

---

# Related Documents

* Deployment
* Release Strategy
* Infrastructure Delivery
* Application Delivery
* ML Delivery
* GitHub Actions

Together, these define how the platform safely recovers from failures across all systems.
