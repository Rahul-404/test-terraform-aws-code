# Release Strategy

## Purpose

This document defines how releases are planned, versioned, created, and promoted across the platform.

A release represents a **stable, versioned snapshot of changes** that can be deployed consistently across environments.

Releases apply to:

* Infrastructure (Terraform changes)
* Applications (containerized services)
* Machine Learning Models (registry versions)

---

# Objectives

The release strategy aims to provide:

* Predictable deployments
* Versioned system state
* Controlled change rollout
* Safe production updates
* Easy rollback capability
* Cross-system consistency

Releases act as the **coordination layer across all delivery domains**.

---

# What is a Release?

A release is a **versioned collection of validated changes**.

Examples:

```text id="m7r2p8"
Infrastructure Release v1.4.0

Application Release v2.1.3

ML Model Release v5.0.0
```

A release can include:

```text id="k4m8r3"
Terraform changes

Container images

Model versions

Configuration updates
```

---

# Release vs Deployment

| Concept    | Meaning                                      |
| ---------- | -------------------------------------------- |
| Release    | Versioned set of changes                     |
| Deployment | Execution of those changes in an environment |

Example:

```text id="v8m3r5"
Release v1.2.0
    │
    ▼

Deployed to dev → staging → prod
```

---

# Release Principles

## Versioned Artifacts

Every release must be immutable and versioned.

Examples:

```text id="p2m7r9"
Docker image tags

Terraform module versions

ML model versions
```

---

## Repeatability

A release should produce identical outcomes when deployed.

---

## Traceability

Each release should be traceable to:

```text id="n5r8m2"
Git commit

Author

Build pipeline

Approval history
```

---

## Controlled Promotion

Releases must move through environments in a controlled manner.

---

# Versioning Strategy

The platform uses semantic versioning:

```text id="w7m4p3"
MAJOR.MINOR.PATCH
```

Examples:

```text id="y4m8r1"
1.0.0 → Initial release
1.1.0 → New feature
1.1.1 → Bug fix
2.0.0 → Breaking change
```

---

# Release Types

## Infrastructure Release

Contains Terraform changes:

```text id="q8m3r4"
VPC updates

EKS upgrades

IAM changes
```

---

## Application Release

Contains service updates:

```text id="x2m7r8"
API changes

Frontend updates

Bug fixes
```

---

## ML Release

Contains model versions:

```text id="f4m8r2"
Model v12

Model improvements

Retrained models
```

---

# Release Lifecycle

```text id="k7r3m8"
Plan
  │
  ▼

Build
  │
  ▼

Validate
  │
  ▼

Tag
  │
  ▼

Promote
  │
  ▼

Deploy
  │
  ▼

Monitor
```

Each stage ensures release stability.

---

# Release Creation

A release is created when changes are ready for production use.

Triggers:

```text id="t5m8r1"
Merged Pull Request

CI Pipeline Success

Manual Approval

Model Validation Success
```

---

# Release Artifact Generation

Each release generates artifacts.

Examples:

```text id="p3m7r9"
Docker Images

Terraform Plans

ML Models

Configuration Packages
```

These artifacts are immutable.

---

# Release Tagging

Releases are tagged in Git.

Example:

```text id="r8m2p5"
v1.2.0
v2.0.0
```

Tags represent production-ready state.

---

# Environment Promotion Model

Releases move through environments.

```text id="u6m4r8"
Development
      │
      ▼

Staging
      │
      ▼

Production
```

Each environment validates release stability.

---

# Release Promotion Strategy

Promotion is controlled:

```text id="n4m9r2"
Build once
   │
   ▼

Promote across environments
```

Benefits:

* Consistency
* Reduced risk
* Faster rollback

---

# Release Approval Strategy

Production releases may require approval.

Flow:

```text id="a7m3r5"
Staging Validation
        │
        ▼

Approval Gate
        │
        ▼

Production Release
```

---

# Release Coordination Across Domains

A single platform release may include:

```text id="j8m2r4"
Infrastructure Changes

Application Updates

ML Model Updates
```

These must be coordinated for consistency.

---

# Release Dependency Management

Some components depend on others.

Example:

```text id="g4m7r8"
Network → EKS → Applications → Models
```

Release order must respect dependencies.

---

# Rollback-Friendly Releases

Each release must support rollback.

Example:

```text id="z5m2r7"
Release v2.0.0
     │
     ▼

Issue Detected
     │
     ▼

Rollback to v1.9.0
```

---

# Hotfix Releases

Critical fixes may bypass normal release cycles.

Characteristics:

```text id="k2m7p9"
Urgent

Minimal scope

Fast deployment
```

---

# Release Notes

Each release should include documentation:

```text id="r6m3p8"
What changed

Why it changed

Impact

Rollback instructions
```

---

# Release Automation

GitHub Actions handles release automation:

```text id="w4p7m2"
Code Merge
     │
     ▼

Build Pipeline
     │
     ▼

Create Release
     │
     ▼

Tag Version
     │
     ▼

Deploy
```

---

# Release Strategy Patterns

## Build Once, Deploy Many

```text id="n9r4m7"
Single artifact
     │
     ▼

Multiple environments
```

---

## Immutable Releases

```text id="p3m7n8"
No modification after creation
```

---

## Progressive Promotion

```text id="f6r2m9"
dev → staging → prod
```

---

# Observability for Releases

Track:

```text id="v7r3m8"
Release Frequency

Success Rate

Rollback Rate

Deployment Time
```

---

# Anti-Patterns

## Rebuilding Per Environment

```text id="k5m2r7"
❌ Different builds for dev/staging/prod
```

---

## Mutable Releases

```text id="n8r4m2"
❌ Changing released artifacts
```

---

## No Versioning

```text id="u4m7p9"
❌ Deploying "latest"
```

---

## Skipping Staging

```text id="f2m8r5"
❌ Direct prod release
```

---

## Untracked Changes

```text id="g7m3p8"
❌ No release notes
```

---

# Example Startup Release Flow

```text id="z3m8r4"
Feature Merge
      │
      ▼

CI Build
      │
      ▼

Create Release v1.3.0
      │
      ▼

Deploy to Dev
      │
      ▼

Validate
      │
      ▼

Promote to Staging
      │
      ▼

Promote to Prod
```

---

# Future Evolution

As the platform grows, release strategy may evolve to support:

* Canary releases
* Blue-green deployments
* Feature flags
* Automated version bumping
* Multi-service coordinated releases

The core principle remains:

```text id="n2m9r4"
A release is a
stable, versioned,
and deployable snapshot
of the system.
```

---

# Related Documents

* Deployment
* Rollback Strategy
* Infrastructure Delivery
* Application Delivery
* ML Delivery
* GitHub Actions

Together, these define how platform changes are safely grouped, versioned, and promoted across environments.
