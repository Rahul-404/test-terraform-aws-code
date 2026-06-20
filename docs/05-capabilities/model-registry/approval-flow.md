# Model Registry Approval Flow

## Purpose

This document defines how machine learning models move from training outputs to approved production candidates within the platform.

The approval process ensures:

* Model quality validation
* Deployment safety
* Governance compliance
* Auditability
* Controlled promotion of models

A model cannot be deployed unless it passes the approval process.

---

# Why Approval Exists

Training successfully does not guarantee deployment readiness.

A model may:

```text
Have Poor Performance

Contain Data Issues

Use Incorrect Features

Be Trained On Wrong Dataset

Violate Business Constraints

Fail Governance Checks
```

The approval workflow acts as a control gate between:

```text
Training
    │
    ▼

Model Registry
    │
    ▼

Deployment
```

---

# Approval Principles

## Principle 1

### Training Does Not Mean Production Ready

Training completion only creates a model version.

Example:

```text
Training Completed

↓
Version v17 Created

↓
Draft State
```

The model is not deployable yet.

---

## Principle 2

### Registry Controls Deployment Eligibility

Deployment systems cannot deploy arbitrary model versions.

They must request:

```text
Latest Approved Model
```

from the registry.

---

## Principle 3

### Approval Must Be Auditable

Every approval action must record:

```text
Approver

Timestamp

Model Version

Reason

Comments
```

---

## Principle 4

### Approval Is Separate From Registration

Registration:

```text
Training Run
    │
    ▼

Version Created
```

Approval:

```text
Version Created
    │
    ▼

Review Process
    │
    ▼

Approved
```

These are independent lifecycle events.

---

# Startup Approval Strategy

Startup V1 uses:

```text
Manual Approval

Single Approval Gate

ML Engineer Approval
```

Reason:

```text
Low Operational Complexity

Low Risk

Easy Governance

Minimal Infrastructure
```

---

# Model Lifecycle States

```text
Draft
 │
 ▼

Validated
 │
 ┌─────────────┐
 ▼             ▼

Approved    Rejected
   │
   ▼

Archived
```

---

# State Definitions

## Draft

Created immediately after registration.

Characteristics:

```text
Version Exists

Metadata Exists

Artifacts Exist

Not Deployable
```

---

## Validated

Automated checks completed.

Examples:

```text
Metric Validation

Artifact Validation

Lineage Validation

Metadata Validation
```

Still not deployable.

---

## Approved

Model passed review.

Characteristics:

```text
Deployable

Visible To Deployment System

Eligible For Production
```

---

## Rejected

Model failed validation or review.

Characteristics:

```text
Not Deployable

Retained For Audit

Retained For Comparison
```

---

## Archived

Historical version no longer actively used.

Characteristics:

```text
Not Deployable

Searchable

Auditable
```

---

# Approval Workflow

```text
Training Job
      │
      ▼

Register Model
      │
      ▼

Draft
      │
      ▼

Automated Validation
      │
      ▼

Validated
      │
      ▼

Human Review
      │
 ┌────┴────┐
 ▼         ▼

Approve   Reject
 │
 ▼

Approved
```

---

# Approval Inputs

Reviewers evaluate:

## Performance Metrics

Examples:

```text
Accuracy

Precision

Recall

F1 Score

ROC-AUC
```

---

## Training Metadata

Examples:

```text
Training Dataset

Feature Version

Training Duration

Hyperparameters
```

---

## Experiment Results

Examples:

```text
Best Run

Comparison With Previous Version

Performance Trend
```

---

## Lineage Information

Examples:

```text
Dataset Version

Feature Version

Experiment ID

Training Run ID
```

---

# Automated Validation Stage

Before human review, the platform performs automated checks.

---

## Artifact Validation

Verify:

```text
Artifact Exists

Artifact Accessible

Artifact Downloadable
```

---

## Metadata Validation

Verify:

```text
Experiment Exists

Run Exists

Version Metadata Complete
```

---

## Lineage Validation

Verify:

```text
Dataset Linked

Features Linked

Training Run Linked
```

---

## Metrics Validation

Verify:

```text
Required Metrics Present

Metric Values Valid

No Missing Values
```

---

# Approval Criteria

Example startup criteria:

---

## Accuracy Threshold

```text
Accuracy >= 90%
```

---

## Recall Threshold

```text
Recall >= 85%
```

---

## Feature Validation

```text
Approved Feature Set
```

---

## Dataset Validation

```text
Latest Production Dataset
```

---

## Lineage Completeness

```text
100% Traceable
```

---

# Human Review Stage

Reviewer examines:

```text
Metrics

Experiment Results

Previous Versions

Lineage

Risk Assessment
```

---

## Example Review

```text
Version: v17

Accuracy: 94%

Recall: 90%

Dataset: dataset-v5

Feature Version: feature-v3

Decision: Approved
```

---

# Approval Metadata

Every approval action stores metadata.

Example:

```json
{
  "model_name": "heart-stroke-predictor",
  "version": 17,
  "approved_by": "ml-engineer",
  "approved_at": "2026-05-10T10:00:00Z",
  "comments": "Metrics exceed production threshold"
}
```

---

# Rejection Flow

A reviewer may reject a version.

Example:

```text
Version v18

Accuracy Below Threshold

Rejected
```

---

## Rejection Metadata

```json
{
  "version": 18,
  "status": "rejected",
  "reason": "Recall below minimum threshold"
}
```

---

# Deployment Integration

Deployment never selects models directly.

Instead:

```text
Deployment Service
         │
         ▼

Model Registry
         │
         ▼

Latest Approved Version
```

---

## Example

Registry:

```text
v15 Approved

v16 Rejected

v17 Approved

v18 Draft
```

Deployment receives:

```text
v17
```

---

# Approval Ownership

## Startup V1

Single reviewer model.

```text
ML Engineer
```

Responsibilities:

```text
Review Metrics

Review Metadata

Approve Models

Reject Models
```

---

# Audit Requirements

The platform must answer:

```text
Who Approved The Model?

When Was It Approved?

Why Was It Approved?

Which Version Was Approved?

What Dataset Produced It?
```

---

# Approval History

Example:

```text
Heart Stroke Predictor

v15 Approved

v16 Rejected

v17 Approved

v18 Draft
```

This history must remain permanently accessible.

---

# Rollback Integration

Approved historical versions remain deployable.

Example:

```text
Current Production = v17

Issue Found

Rollback → v15
```

No retraining required.

---

# Failure Scenarios

## Missing Artifact

```text
Artifact Not Found
```

Action:

```text
Validation Failed

Cannot Approve
```

---

## Missing Lineage

```text
No Dataset Link
```

Action:

```text
Reject Approval
```

---

## Missing Metrics

```text
Accuracy Missing
```

Action:

```text
Validation Failure
```

---

## Unauthorized Approval

```text
User Without Permission
```

Action:

```text
Access Denied
```

---

# Startup V1 Implementation

Approval workflow is implemented using:

| Component             | Purpose             |
| --------------------- | ------------------- |
| MLflow Model Registry | Version lifecycle   |
| MLflow Stages         | State transitions   |
| IAM                   | Access control      |
| S3                    | Artifact validation |
| Metadata Store        | Approval history    |

---

# Future Evolution

As the platform grows, approval workflows may evolve into:

```text
Multi-Level Approval

Risk-Based Approval

Automated Approval

Policy Engines

Compliance Reviews

Champion-Challenger Promotion
```

Example:

```text
Validation
     │
     ▼

ML Engineer
     │
     ▼

Platform Lead
     │
     ▼

Production Approval
```

Startup V1 intentionally avoids this complexity.

---

# Approval Anti-Patterns

The platform explicitly prohibits:

---

## Direct Deployment

```text
Training
   │
   ▼

Deployment
```

❌ Not Allowed

---

## Approval Without Lineage

```text
No Dataset Information
```

❌ Not Allowed

---

## Artifact Replacement After Approval

```text
Replace Approved Artifact
```

❌ Not Allowed

---

## Approving Draft Versions Without Validation

```text
Draft → Approved
```

❌ Not Allowed

Must pass validation first.

---

# Success Criteria

The approval process is successful when:

```text
Every Deployable Model Is Approved

Approval Decisions Are Auditable

Rejected Models Are Preserved

Deployment Uses Approved Versions Only

Lineage Is Complete

Rollback Is Supported
```

---

# Summary

The Model Registry Approval Flow governs how model versions move from training outputs to production-ready assets. Models progress through Draft, Validation, Approval, and Archival stages, with automated checks and human review ensuring quality, traceability, and governance compliance. Only approved versions are exposed to deployment systems, making the registry the authoritative control point for production model promotion in the Startup V1 platform.
