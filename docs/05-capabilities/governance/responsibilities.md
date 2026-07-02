# Responsibilities

## Purpose

This document defines the responsibilities owned by the Governance Capability and clearly establishes its boundaries within the MLOps platform.

Governance is responsible for ensuring that models are:

* Controlled
* Traceable
* Auditable
* Approved
* Compliant with organizational policies

This document answers:

```text
What does Governance own?

What does Governance not own?

How does Governance interact with other capabilities?
```

---

# Governance Mission

The Governance Capability exists to provide:

```text
Accountability

Transparency

Control

Risk Management

Compliance
```

for the entire ML lifecycle.

---

# Core Responsibility Areas

The Governance Capability owns six major domains:

```text
Model Approval

Lineage Management

Metadata Management

Audit Management

Access Control

Policy Enforcement
```

---

# Responsibility 1

## Model Approval Management

Governance owns the approval process required before models may enter production.

---

# Why It Exists

Without approval:

```text
Training

↓

Deployment
```

can occur without review.

This introduces risk.

---

# Governance Responsibilities

```text
Approval Requests

Approval Reviews

Approval Decisions

Approval Records

Approval History
```

---

# Example Workflow

```text
Model Registered

      │

      ▼

Approval Requested

      │

      ▼

Approved

      │

      ▼

Deployment Allowed
```

---

# Governance Owns

```text
Approval Status

Reviewer Assignment

Approval Metadata

Decision History
```

---

# Governance Does Not Own

```text
Deployment Execution
```

Deployment remains the responsibility of the Deployment Capability.

---

# Responsibility 2

## Model Lineage Management

Governance owns end-to-end model lineage.

---

# Purpose

Enable traceability.

---

# Questions Answered

```text
Which Dataset?

Which Experiment?

Which Features?

Which Code?

Which Model Version?
```

---

# Governance Owns

```text
Lineage Records

Lineage Relationships

Lineage Queries

Lineage Validation
```

---

# Example

```text
Dataset v5

↓

Feature Set v3

↓

Experiment 102

↓

Model v2.1.0

↓

Deployment
```

---

# Governance Does Not Own

```text
Dataset Storage

Feature Storage

Artifact Storage
```

Those belong to Data Platform, Feature Store, and Model Registry.

---

# Responsibility 3

## Metadata Management

Governance owns metadata required for operational and compliance purposes.

---

# Purpose

Maintain model context.

---

# Governance Owns

```text
Ownership Metadata

Business Metadata

Approval Metadata

Lifecycle Metadata

Risk Metadata
```

---

# Example

```json
{
  "model_id": "stroke-predictor",
  "owner": "ml-team",
  "risk_level": "medium",
  "status": "approved"
}
```

---

# Metadata Categories

## Operational Metadata

Examples:

```text
Model Name

Version

Status
```

---

## Business Metadata

Examples:

```text
Business Unit

Use Case

Stakeholder
```

---

## Governance Metadata

Examples:

```text
Approval Status

Reviewer

Approval Date
```

---

# Governance Does Not Own

```text
Training Metrics

Training Parameters

Artifacts
```

These belong to Experiment Tracking.

---

# Responsibility 4

## Audit Management

Governance owns auditability across the ML lifecycle.

---

# Purpose

Track all important actions.

---

# Governance Owns

```text
Audit Events

Audit Storage

Audit Queries

Audit Retention
```

---

# Questions Answered

```text
Who Did It?

What Changed?

When Did It Change?

Why Did It Change?
```

---

# Example Audit Event

```json
{
  "event": "model_approved",
  "user": "reviewer-1",
  "timestamp": "2026-06-19T10:00:00Z"
}
```

---

# Governance Does Not Own

```text
Application Logs

Infrastructure Logs

Container Logs
```

These belong to Monitoring.

---

# Responsibility 5

## Access Control Governance

Governance controls access to governance-related actions.

---

# Purpose

Ensure only authorized users may perform sensitive operations.

---

# Governance Owns

```text
Approval Permissions

Audit Access

Policy Access

Metadata Modification Rights
```

---

# Example

Allowed:

```text
Reviewer

↓

Approve Model
```

---

Not Allowed:

```text
Intern

↓

Approve Production Model
```

---

# Governance Does Not Own

```text
IAM Infrastructure

Identity Provider
```

These belong to Platform Foundation and Security layers.

---

# Responsibility 6

## Policy Enforcement

Governance enforces organizational rules.

---

# Purpose

Prevent unsafe deployments.

---

# Examples

```text
Approval Required

Lineage Required

Owner Required

Metadata Required
```

---

# Example Policy

```text
Model Must Have

↓

Owner

↓

Lineage

↓

Approval

↓

Deploy
```

---

# Governance Owns

```text
Policy Definitions

Policy Validation

Policy Enforcement

Policy Exceptions
```

---

# Governance Does Not Own

```text
Model Quality Evaluation
```

This belongs to Training and Monitoring.

---

# Responsibility 7

## Production Readiness Validation

Governance validates that models meet minimum deployment requirements.

---

# Validation Examples

```text
Metadata Complete

Approval Complete

Lineage Present

Ownership Assigned
```

---

# Outcome

```text
Ready For Deployment

or

Blocked
```

---

# Responsibility 8

## Compliance Readiness

Startup V1 focuses on governance fundamentals.

However Governance prepares for future compliance requirements.

---

# Examples

```text
SOC2

ISO 27001

Internal Governance Standards
```

---

# Startup V1 Scope

Store sufficient information to support audits.

---

# Responsibility 9

## Governance Reporting

Governance provides operational visibility.

---

# Reports

Examples:

```text
Pending Approvals

Approved Models

Rejected Models

Governance Violations
```

---

# Governance Metrics

Examples:

```text
approval_pending_total

approval_approved_total

approval_rejected_total
```

---

# Responsibility 10

## Lifecycle Governance

Governance tracks model lifecycle progression.

---

# States

```text
Draft

Registered

Pending Approval

Approved

Rejected

Deployed

Archived
```

---

# Governance Owns

```text
Lifecycle Status

State Transitions

State History
```

---

# Capability Boundaries

## Governance vs Training

Training owns:

```text
Model Training

Metrics

Parameters

Artifacts
```

Governance owns:

```text
Approval

Audit

Lineage

Policies
```

---

## Governance vs Experiment Tracking

Experiment Tracking owns:

```text
Runs

Metrics

Parameters
```

Governance owns:

```text
Approval Metadata

Ownership

Audit Records
```

---

## Governance vs Model Registry

Registry owns:

```text
Model Storage

Versioning
```

Governance owns:

```text
Approval State

Governance Metadata
```

---

## Governance vs Deployment

Deployment owns:

```text
Traffic Routing

Rollouts

Rollback
```

Governance owns:

```text
Deployment Permission

Deployment Approval
```

---

# Governance Service Boundaries

The Governance Capability exposes:

```text
Approval APIs

Audit APIs

Metadata APIs

Policy APIs

Lineage APIs
```

---

# Governance Service Does Not Expose

```text
Training APIs

Deployment APIs

Inference APIs
```

---

# Startup V1 Responsibility Summary

| Responsibility       | Owned |
| -------------------- | ----- |
| Model Approval       | ✓     |
| Lineage Tracking     | ✓     |
| Metadata Management  | ✓     |
| Audit Logging        | ✓     |
| Access Control       | ✓     |
| Policy Enforcement   | ✓     |
| Lifecycle Tracking   | ✓     |
| Compliance Readiness | ✓     |
| Training Execution   | ✗     |
| Deployment Execution | ✗     |
| Artifact Storage     | ✗     |

---

# Ownership Matrix

| Capability          | Governance Responsibility      |
| ------------------- | ------------------------------ |
| Training            | Consume metadata               |
| Experiment Tracking | Consume lineage information    |
| Model Registry      | Validate registration metadata |
| Deployment          | Authorize deployment           |
| Monitoring          | Consume governance metrics     |
| Retraining          | Validate approval policies     |

---

# Startup V1 Non-Goals

Governance intentionally avoids:

```text
Automated Risk Scoring

AI Governance Engines

Regulatory Automation

Autonomous Approvals
```

These become relevant later.

---

# Growth V2 Responsibilities

Additional ownership:

```text
Risk Classification

Approval Escalations

Governance Reporting

Policy Templates
```

---

# Enterprise V3 Responsibilities

Additional ownership:

```text
Compliance Frameworks

Risk Engines

Automated Controls

Policy Automation
```

---

# Requirement → Owner → Verification

| Requirement                               | Owner                 | Verification        |
| ----------------------------------------- | --------------------- | ------------------- |
| Every production model must be approved   | Governance Capability | Approval testing    |
| Every model must have lineage             | Governance Capability | Lineage validation  |
| Every governance action must be auditable | Governance Capability | Audit review        |
| Governance metadata must be maintained    | Governance Capability | Metadata validation |
| Governance policies must be enforced      | Governance Capability | Policy testing      |
| Governance permissions must be controlled | Governance Capability | Security review     |

---

# Summary

The Governance Capability owns the accountability layer of the MLOps platform. It is responsible for model approvals, lineage management, metadata management, audit logging, access control, policy enforcement, lifecycle governance, and compliance readiness. Governance does not train models, deploy models, or store artifacts. Instead, it ensures that every model entering production is properly reviewed, traceable, auditable, and aligned with organizational policies.
