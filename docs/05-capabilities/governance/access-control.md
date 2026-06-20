# Access Control

## Purpose

This document defines the access control strategy for the Governance Capability.

Access Control ensures that only authorized users, services, and systems can perform governance-related operations.

The Governance Capability controls highly sensitive actions such as:

```text id="ac01"
Model Approval

Policy Changes

Metadata Updates

Audit Access

Governance Administration
```

Without proper access controls, unauthorized users could approve models, alter governance records, or bypass platform controls.

---

# Why Access Control Exists

Not every user should have the same permissions.

For example:

```text id="ac02"
Data Scientist

↓

Train Model
```

does not automatically mean:

```text id="ac03"
Approve Production Deployment
```

Access Control enforces separation of responsibilities.

---

# Governance Objectives

The Access Control subsystem ensures:

```text id="ac04"
Least Privilege

Separation of Duties

Controlled Approvals

Secure Governance

Auditability
```

---

# Core Questions

For every governance action:

```text id="ac05"
Who Is Performing The Action?

Are They Authorized?

What Permissions Do They Have?

Should This Action Be Allowed?
```

---

# Position in Platform Architecture

Access Control sits in front of governance operations.

```text id="ac06"
User

  │

  ▼

Authentication

  │

  ▼

Access Control

  │

  ▼

Governance Service

  │

  ▼

Approval

Metadata

Audit

Policies
```

---

# Scope

The Governance Capability owns:

```text id="ac07"
Authorization

Role Definitions

Permission Validation

Governance Access Policies
```

---

# Governance Does Not Own

```text id="ac08"
Identity Provider

Authentication

User Accounts

SSO
```

These belong to the Security and Platform Foundation layers.

---

# Authentication vs Authorization

Authentication answers:

```text id="ac09"
Who Are You?
```

Authorization answers:

```text id="ac10"
What Can You Do?
```

---

# Example

Authentication:

```text id="ac11"
Rahul

Authenticated
```

Authorization:

```text id="ac12"
Can Approve Models?

YES
```

---

# Startup V1 Philosophy

Startup V1 follows:

```text id="ac13"
Simple

Role-Based

Auditable

Least Privilege
```

---

# Access Control Model

Startup V1 uses:

```text id="ac14"
RBAC

Role Based Access Control
```

---

# Why RBAC?

Because it is:

```text id="ac15"
Simple

Understandable

Easy To Operate
```

---

# Access Control Components

```text id="ac16"
Users

Roles

Permissions

Policies
```

---

# User

Represents:

```text id="ac17"
Human

Service Account
```

---

# Example

```text id="ac18"
ml-lead

platform-engineer

deployment-service
```

---

# Role

Defines a collection of permissions.

---

Example:

```text id="ac19"
Reviewer
```

may include:

```text id="ac20"
Approve Models

View Metadata

View Audit Records
```

---

# Permission

Represents a specific action.

---

Examples:

```text id="ac21"
approve_model

view_audit

update_metadata

view_lineage
```

---

# Policy

Defines access rules.

---

Example:

```text id="ac22"
Reviewer

↓

approve_model

↓

Allowed
```

---

# Startup V1 Roles

The platform defines several governance roles.

---

# Role 1

## Viewer

Purpose:

Read-only access.

---

Permissions:

```text id="ac23"
View Metadata

View Lineage

View Audit Records
```

---

Cannot:

```text id="ac24"
Approve Models

Modify Policies
```

---

# Role 2

## Data Scientist

Purpose:

Create and register models.

---

Permissions:

```text id="ac25"
Register Models

View Metadata

View Lineage
```

---

Cannot:

```text id="ac26"
Approve Models
```

---

# Role 3

## Reviewer

Purpose:

Governance review.

---

Permissions:

```text id="ac27"
Approve Models

Reject Models

View Audit Records

View Metadata
```

---

Cannot:

```text id="ac28"
Modify Governance Policies
```

---

# Role 4

## ML Lead

Purpose:

Senior governance ownership.

---

Permissions:

```text id="ac29"
Approve Models

Reject Models

Review Metadata

View Audit
```

---

# Role 5

## Platform Engineer

Purpose:

Operational governance support.

---

Permissions:

```text id="ac30"
View Metadata

View Audit

Manage Governance Services
```

---

Cannot:

```text id="ac31"
Approve Business Models
```

---

# Role 6

## Governance Administrator

Purpose:

Governance administration.

---

Permissions:

```text id="ac32"
Manage Policies

Manage Permissions

View Audit

Override Governance Controls
```

---

# Permission Catalog

Startup V1 permissions.

---

# Approval Permissions

```text id="ac33"
approve_model

reject_model

request_approval
```

---

# Metadata Permissions

```text id="ac34"
view_metadata

update_metadata
```

---

# Lineage Permissions

```text id="ac35"
view_lineage

manage_lineage
```

---

# Audit Permissions

```text id="ac36"
view_audit
```

---

# Governance Permissions

```text id="ac37"
manage_policies

manage_roles
```

---

# Example Role Mapping

| Role             | Approve | Metadata | Audit | Policies |
| ---------------- | ------- | -------- | ----- | -------- |
| Viewer           | ✗       | Read     | Read  | ✗        |
| Data Scientist   | ✗       | Read     | ✗     | ✗        |
| Reviewer         | ✓       | Read     | Read  | ✗        |
| ML Lead          | ✓       | Read     | Read  | ✗        |
| Governance Admin | ✓       | Full     | Full  | Full     |

---

# Authorization Workflow

Every governance request follows:

```text id="ac38"
Request

   │

   ▼

Identity

   │

   ▼

Role Lookup

   │

   ▼

Permission Check

   │

   ▼

Allow / Deny
```

---

# Example

```text id="ac39"
User

↓

Approve Model

↓

Reviewer Role

↓

Permission Exists

↓

Allowed
```

---

# Example Denial

```text id="ac40"
User

↓

Approve Model

↓

Viewer Role

↓

Permission Missing

↓

Denied
```

---

# Access Control Validation

Every request validates:

```text id="ac41"
Identity

Role

Permission
```

---

# Approval Protection

Only approved governance roles may approve models.

---

Allowed:

```text id="ac42"
Reviewer

ML Lead

Governance Admin
```

---

Denied:

```text id="ac43"
Viewer

Data Scientist
```

---

# Separation of Duties

Startup V1 recommends:

```text id="ac44"
Creator

≠

Approver
```

---

Example:

```text id="ac45"
Data Scientist

Creates Model

↓

Reviewer

Approves Model
```

---

# Why?

Prevents:

```text id="ac46"
Self Approval
```

---

# Service Accounts

Governance services use dedicated service accounts.

---

Examples:

```text id="ac47"
deployment-service

registry-service

governance-service
```

---

# Service Permissions

Example:

```text id="ac48"
deployment-service

↓

verify_approval_status
```

---

# Access Auditability

Every access decision is audited.

---

Captured:

```text id="ac49"
Who

What

When

Allowed?

Denied?
```

---

# Example Audit Event

```json id="ac50"
{
  "user": "reviewer-1",
  "action": "approve_model",
  "result": "allowed"
}
```

---

# Security Principles

Startup V1 enforces:

```text id="ac51"
Least Privilege

Role Separation

Explicit Permissions
```

---

# Least Privilege

Users receive only the permissions required.

---

Example:

```text id="ac52"
Viewer

↓

Cannot Approve
```

---

# Deny By Default

If no permission exists:

```text id="ac53"
DENY
```

---

# Reason

Safer than:

```text id="ac54"
ALLOW BY DEFAULT
```

---

# Storage

Startup V1 stores role mappings in:

```text id="ac55"
PostgreSQL
```

---

# Example Tables

```text id="ac56"
users

roles

permissions

role_permissions
```

---

# Example Role Record

```json id="ac57"
{
  "role": "reviewer"
}
```

---

# Example Permission Record

```json id="ac58"
{
  "permission": "approve_model"
}
```

---

# Governance Integration

Approval workflows consume authorization.

---

Flow:

```text id="ac59"
Approve Request

      │

      ▼

Permission Check

      │

      ▼

Approve / Deny
```

---

# Metadata Integration

Metadata updates require permissions.

---

Example:

```text id="ac60"
update_metadata

↓

Allowed?
```

---

# Audit Integration

Access decisions generate audit records.

---

Example:

```text id="ac61"
AccessDenied

AccessGranted
```

---

# Monitoring Metrics

Examples:

```text id="ac62"
access_granted_total

access_denied_total

permission_checks_total
```

---

# Dashboard Examples

```text id="ac63"
Top Active Users

Denied Requests

Approval Actions

Role Distribution
```

---

# Startup V1 Limitations

Not supported:

```text id="ac64"
Attribute-Based Access Control

Dynamic Policies

Risk-Based Access

Just-In-Time Access
```

---

# Growth V2 Evolution

Introduce:

```text id="ac65"
Approval Escalation Roles

Temporary Permissions

Policy Templates
```

---

# Scale V3 Evolution

Introduce:

```text id="ac66"
ABAC

Fine-Grained Authorization

Context-Aware Policies
```

---

# Enterprise V4 Evolution

Introduce:

```text id="ac67"
Risk-Aware Access

Compliance Policies

Dynamic Authorization
```

---

# Access Control Maturity Model

| Capability           | Startup V1 | Growth V2 | Scale V3 | Enterprise V4 |
| -------------------- | ---------- | --------- | -------- | ------------- |
| RBAC                 | ✓          | ✓         | ✓        | ✓             |
| Permission Auditing  | ✓          | ✓         | ✓        | ✓             |
| Separation of Duties | ✓          | ✓         | ✓        | ✓             |
| Temporary Access     | ✗          | ✓         | ✓        | ✓             |
| ABAC                 | ✗          | ✗         | ✓        | ✓             |
| Risk-Based Access    | ✗          | ✗         | ✗        | ✓             |

---

# Requirement → Owner → Verification

| Requirement                               | Owner                 | Verification          |
| ----------------------------------------- | --------------------- | --------------------- |
| Only authorized users may approve models  | Governance Capability | Authorization testing |
| Access decisions must be audited          | Governance Capability | Audit review          |
| Unauthorized requests must be denied      | Governance Capability | Security testing      |
| Governance roles must be enforced         | Governance Capability | Role validation       |
| Service accounts must use least privilege | Governance Capability | Security review       |
| Separation of duties must be maintained   | Governance Capability | Governance audit      |

---

# Summary

The Access Control subsystem protects governance operations through Role-Based Access Control (RBAC), explicit permissions, separation of duties, and least-privilege principles. Startup V1 focuses on secure authorization for approvals, metadata management, lineage access, audit visibility, and governance administration. Every access decision is auditable, permission-driven, and denied by default. As the platform evolves, access control expands toward attribute-based authorization, dynamic policies, and enterprise-grade risk-aware governance controls.
