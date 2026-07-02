# Lineage

## Purpose

This document defines the lineage management strategy within the Governance Capability.

Lineage provides complete traceability across the machine learning lifecycle by recording how a model was produced, what inputs were used, and how it ultimately reached production.

The purpose of lineage is to answer:

```text id="l01"
Where Did This Model Come From?

Which Dataset Created It?

Which Features Were Used?

Which Experiment Produced It?

Which Deployment Is Running It?
```

Without lineage, production models become difficult to trust, debug, reproduce, or audit.

---

# Why Lineage Exists

A production model is the result of many interconnected artifacts.

```text id="l02"
Raw Data

↓

Processed Data

↓

Features

↓

Training Run

↓

Experiment

↓

Model

↓

Deployment
```

Lineage connects these artifacts together.

---

# Governance Objective

The Governance Capability ensures:

```text id="l03"
Every Model Is Traceable

Every Deployment Is Explainable

Every Artifact Is Linked

Every Decision Is Auditable
```

---

# Core Questions Lineage Answers

For every production model:

```text id="l04"
Which Dataset Was Used?

Which Features Were Used?

Which Code Produced It?

Which Training Run Created It?

Which Experiment Validated It?

Which Deployment Is Running It?
```

---

# Business Value

Lineage enables:

```text id="l05"
Root Cause Analysis

Reproducibility

Audits

Compliance

Rollback Decisions

Impact Analysis
```

---

# Position in Platform Architecture

Lineage spans multiple capabilities.

```text id="l06"
Data Platform

      │

      ▼

Feature Store

      │

      ▼

Training

      │

      ▼

Experiment Tracking

      │

      ▼

Model Registry

      │

      ▼

Governance Lineage

      │

      ▼

Deployment
```

---

# Lineage Scope

The Governance Capability owns:

```text id="l07"
Lineage Relationships

Lineage Queries

Lineage Validation

Lineage Metadata

Lineage Auditability
```

---

# Governance Does Not Own

```text id="l08"
Dataset Storage

Feature Storage

Artifact Storage

Experiment Storage
```

Those remain owned by their respective capabilities.

---

# Lineage Model

Startup V1 uses artifact lineage.

Every artifact becomes a node.

Relationships become edges.

---

# Example

```text id="l09"
Dataset v5

↓

Feature Set v3

↓

Experiment 102

↓

Model v2.1.0

↓

Deployment prod-01
```

---

# Lineage Graph

Conceptually:

```text id="l10"
Dataset

  │

  ▼

Features

  │

  ▼

Experiment

  │

  ▼

Model

  │

  ▼

Deployment
```

---

# Lineage Levels

Startup V1 tracks five levels.

---

# Level 1

## Dataset Lineage

Tracks:

```text id="l11"
Dataset ID

Dataset Version

Dataset Owner

Dataset Timestamp
```

---

# Example

```json id="l12"
{
  "dataset_id": "stroke-dataset",
  "version": "v5"
}
```

---

# Level 2

## Feature Lineage

Tracks:

```text id="l13"
Feature Set

Feature Version

Feature Source
```

---

# Example

```json id="l14"
{
  "feature_set": "stroke-features",
  "version": "v3"
}
```

---

# Level 3

## Experiment Lineage

Tracks:

```text id="l15"
Experiment ID

Run ID

Parameters

Metrics
```

---

# Example

```json id="l16"
{
  "experiment_id": "exp-102",
  "run_id": "run-567"
}
```

---

# Level 4

## Model Lineage

Tracks:

```text id="l17"
Model ID

Version

Registry Entry
```

---

# Example

```json id="l18"
{
  "model_id": "stroke-predictor",
  "version": "2.1.0"
}
```

---

# Level 5

## Deployment Lineage

Tracks:

```text id="l19"
Deployment ID

Environment

Release Version
```

---

# Example

```json id="l20"
{
  "deployment_id": "prod-01",
  "environment": "production"
}
```

---

# Lineage Relationships

Startup V1 tracks relationships between entities.

---

# Dataset → Feature

```text id="l21"
Dataset v5

↓

Feature Set v3
```

---

# Feature → Experiment

```text id="l22"
Feature Set v3

↓

Experiment 102
```

---

# Experiment → Model

```text id="l23"
Experiment 102

↓

Model v2.1.0
```

---

# Model → Deployment

```text id="l24"
Model v2.1.0

↓

Production Deployment
```

---

# Full Example

```text id="l25"
Dataset v5

↓

Feature Set v3

↓

Experiment 102

↓

Run 567

↓

Model v2.1.0

↓

Deployment prod-01
```

---

# Lineage Metadata

Each lineage record contains:

```text id="l26"
Source Entity

Target Entity

Relationship Type

Timestamp
```

---

# Example

```json id="l27"
{
  "source": "dataset-v5",
  "target": "feature-v3",
  "relationship": "generated_features"
}
```

---

# Relationship Types

Startup V1 supports:

```text id="l28"
trained_from

generated_from

registered_as

deployed_as
```

---

# Example

```json id="l29"
{
  "relationship": "trained_from"
}
```

---

# Lineage Validation

Before approval:

Governance verifies lineage completeness.

---

# Required Links

```text id="l30"
Dataset

Feature Set

Experiment

Model
```

---

# Validation Rule

```text id="l31"
Missing Lineage

↓

Approval Blocked
```

---

# Example

Valid:

```text id="l32"
Dataset

↓

Experiment

↓

Model
```

---

Invalid:

```text id="l33"
Unknown Dataset

↓

Model
```

---

# Approval Integration

Lineage is mandatory for approval.

---

Workflow:

```text id="l34"
Model Registered

      │

      ▼

Lineage Validation

      │

      ▼

Approval Review
```

---

# Deployment Integration

Deployment consumes lineage.

---

Purpose:

```text id="l35"
Know Which Model

Know Which Version

Know Which Dataset
```

---

# Root Cause Analysis

Lineage enables incident investigation.

---

# Example Scenario

Production issue detected.

---

Question:

```text id="l36"
Which Dataset Caused This?
```

---

Lineage Answer:

```text id="l37"
Deployment

↓

Model v2.1.0

↓

Experiment 102

↓

Dataset v5
```

---

# Rollback Support

Lineage enables safe rollback.

---

Example

```text id="l38"
Model v2.1.0

↓

Issue Found

↓

Rollback To v2.0.0
```

---

Governance can verify:

```text id="l39"
Previous Dataset

Previous Experiment

Previous Model
```

---

# Audit Integration

Every lineage modification must be audited.

---

Example

```json id="l40"
{
  "action": "lineage_created",
  "entity": "model-v2.1.0"
}
```

---

# Stored Information

Audit records capture:

```text id="l41"
Who

What

When
```

---

# Storage Strategy

Startup V1 stores lineage metadata in:

```text id="l42"
PostgreSQL
```

---

# Example Tables

```text id="l43"
lineage_nodes

lineage_edges
```

---

# Node Example

```json id="l44"
{
  "entity_id": "model-v2.1.0",
  "entity_type": "model"
}
```

---

# Edge Example

```json id="l45"
{
  "source": "exp-102",
  "target": "model-v2.1.0"
}
```

---

# Query Examples

## Query 1

Find dataset used by model.

```text id="l46"
Model

↓

Experiment

↓

Dataset
```

---

## Query 2

Find deployments using model.

```text id="l47"
Model

↓

Deployments
```

---

## Query 3

Find experiments producing deployment.

```text id="l48"
Deployment

↓

Model

↓

Experiment
```

---

# Observability

Lineage operations emit:

```text id="l49"
Metrics

Logs

Events
```

---

# Example Metrics

```text id="l50"
lineage_records_total

lineage_validation_failures_total
```

---

# Example Events

```text id="l51"
LineageCreated

LineageUpdated

LineageValidated
```

---

# Security

Lineage data is sensitive.

---

Access should be restricted.

---

Allowed:

```text id="l52"
ML Engineers

Platform Engineers

Auditors
```

---

Restricted:

```text id="l53"
Anonymous Users
```

---

# Startup V1 Limitations

Not supported:

```text id="l54"
Cross-Platform Lineage

Graph Databases

Automated Impact Analysis

Column-Level Lineage
```

---

# Growth V2 Evolution

Introduce:

```text id="l55"
Lineage Visualization

Impact Analysis

Dependency Discovery
```

---

# Example

```text id="l56"
Dataset Change

↓

Affected Models
```

---

# Scale V3 Evolution

Introduce:

```text id="l57"
Graph Database

Large Lineage Graphs

Advanced Search
```

---

Potential technologies:

```text id="l58"
Neo4j

Amazon Neptune
```

---

# Enterprise V4 Evolution

Introduce:

```text id="l59"
Cross-Platform Lineage

Policy-Aware Lineage

Compliance-Aware Traceability
```

---

# Lineage Maturity Model

| Capability         | Startup V1 | Growth V2 | Scale V3 | Enterprise V4 |
| ------------------ | ---------- | --------- | -------- | ------------- |
| Basic Lineage      | ✓          | ✓         | ✓        | ✓             |
| Validation         | ✓          | ✓         | ✓        | ✓             |
| Visualization      | ✗          | ✓         | ✓        | ✓             |
| Impact Analysis    | ✗          | ✓         | ✓        | ✓             |
| Graph Storage      | ✗          | ✗         | ✓        | ✓             |
| Compliance Mapping | ✗          | ✗         | ✗        | ✓             |

---

# Requirement → Owner → Verification

| Requirement                                | Owner                 | Verification        |
| ------------------------------------------ | --------------------- | ------------------- |
| Every model must have lineage              | Governance Capability | Lineage validation  |
| Lineage must be complete before approval   | Governance Capability | Approval testing    |
| Lineage records must be auditable          | Governance Capability | Audit review        |
| Lineage queries must be supported          | Governance Capability | Query testing       |
| Deployment must reference approved lineage | Deployment Capability | Integration testing |
| Lineage data must be protected             | Governance Capability | Security review     |

---

# Summary

Lineage is the traceability foundation of the Governance Capability. It connects datasets, features, experiments, models, and deployments into a complete chain of evidence that explains how a production model was created. Startup V1 focuses on artifact-level lineage using PostgreSQL-backed relationship tracking, approval validation, audit integration, and operational traceability. Future versions evolve toward graph-based lineage systems, impact analysis, and enterprise-wide compliance traceability.
