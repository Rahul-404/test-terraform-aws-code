# Use Cases

## Purpose

This document describes the primary interactions between users and the Startup Data & AI Platform.

Each use case represents a business workflow that the platform must support. Together, these workflows validate that the platform delivers the capabilities defined in the functional and non-functional requirements.

The use cases are implementation-independent and focus on user goals rather than specific technologies.

---

# Actors

The primary actors interacting with the platform are:

* Data Engineer
* Data Scientist
* Machine Learning Engineer
* MLOps Engineer
* Platform Engineer
* Data Analyst
* Engineering Manager

Each actor consumes one or more platform capabilities.

---

# UC-001: Ingest Data into the Platform

## Primary Actor

Data Engineer

## Goal

Ingest raw data into centralized storage for downstream processing.

## Preconditions

* Data source is available.
* Required permissions are configured.

## Main Flow

1. Configure ingestion pipeline.
2. Validate schema.
3. Execute ingestion.
4. Store raw dataset.
5. Register metadata.
6. Record lineage information.

## Outcome

A versioned dataset becomes available for transformation and analytics.

---

# UC-002: Build Curated Dataset

## Primary Actor

Data Engineer

## Goal

Transform raw data into reusable datasets.

## Main Flow

1. Read raw dataset.
2. Apply transformations.
3. Validate quality checks.
4. Store curated dataset.
5. Update metadata.
6. Publish dataset version.

## Outcome

Trusted datasets become available for analytics and machine learning.

---

# UC-003: Generate Features

## Primary Actor

Data Engineer

## Goal

Create reusable features for downstream machine learning projects.

## Main Flow

1. Load curated dataset.
2. Generate features.
3. Validate outputs.
4. Store feature definitions.
5. Publish feature version.

## Outcome

Reusable features are available to multiple projects.

---

# UC-004: Train a Machine Learning Model

## Primary Actor

Data Scientist

## Goal

Execute a reproducible training job.

## Main Flow

1. Select dataset version.
2. Select feature version.
3. Configure hyperparameters.
4. Submit training request.
5. Execute containerized training.
6. Store artifacts.
7. Record metrics automatically.

## Outcome

A completed experiment is available for evaluation.

---

# UC-005: Compare Experiments

## Primary Actor

Data Scientist

## Goal

Evaluate multiple training runs.

## Main Flow

1. Open experiment history.
2. Compare metrics.
3. Compare artifacts.
4. Identify best-performing model.
5. Select candidate for registration.

## Outcome

Best experiment is identified for production consideration.

---

# UC-006: Register a Model

## Primary Actor

Machine Learning Engineer

## Goal

Promote a trained model into the centralized registry.

## Main Flow

1. Select experiment.
2. Validate metrics.
3. Register artifact.
4. Store metadata.
5. Create model version.

## Outcome

A versioned production candidate is available.

---

# UC-007: Deploy a Model

## Primary Actor

MLOps Engineer

## Goal

Deploy an approved model into production.

## Main Flow

1. Select registered model.
2. Trigger deployment pipeline.
3. Provision inference endpoint.
4. Verify health.
5. Expose prediction API.

## Outcome

Production endpoint becomes available.

---

# UC-008: Consume Model Predictions

## Primary Actor

Application or Service

## Goal

Obtain predictions from deployed models.

## Main Flow

1. Send inference request.
2. Validate payload.
3. Execute prediction.
4. Return response.
5. Record monitoring metrics.

## Outcome

Prediction is returned to the consuming application.

---

# UC-009: Monitor Platform Health

## Primary Actor

MLOps Engineer

## Goal

Observe infrastructure and machine learning behavior.

## Main Flow

1. Review dashboards.
2. Monitor latency.
3. Monitor error rates.
4. Monitor drift metrics.
5. Investigate anomalies.

## Outcome

Operational issues are detected before impacting users.

---

# UC-010: Detect Model Drift

## Primary Actor

MLOps Engineer

## Goal

Identify degradation in production models.

## Main Flow

1. Collect production statistics.
2. Compare with training distribution.
3. Compute drift metrics.
4. Generate alerts if thresholds exceed limits.

## Outcome

Potential degradation is identified.

---

# UC-011: Retrain a Model

## Primary Actor

MLOps Engineer

## Goal

Generate an updated model using standardized workflows.

## Trigger

* Scheduled execution
* Drift detection
* Manual request
* Performance degradation

## Main Flow

1. Trigger retraining.
2. Execute standard training pipeline.
3. Track experiment.
4. Register new candidate.
5. Notify stakeholders.

## Outcome

Updated model becomes available for evaluation.

---

# UC-012: Roll Back a Deployment

## Primary Actor

MLOps Engineer

## Goal

Restore a previous production model.

## Main Flow

1. Select previous version.
2. Trigger rollback.
3. Update serving endpoint.
4. Verify health.
5. Resume production traffic.

## Outcome

Stable service is restored quickly.

---

# UC-013: Explore Curated Data

## Primary Actor

Data Analyst

## Goal

Analyze trusted datasets without managing infrastructure.

## Main Flow

1. Access curated dataset.
2. Query historical data.
3. Perform analysis.
4. Generate reports.
5. Share business insights.

## Outcome

Business decisions are supported through reliable data.

---

# UC-014: Provision Platform Infrastructure

## Primary Actor

Platform Engineer

## Goal

Create reproducible infrastructure using Infrastructure as Code.

## Main Flow

1. Update Terraform modules.
2. Review changes.
3. Execute plan.
4. Apply infrastructure.
5. Validate deployment.

## Outcome

Platform infrastructure remains version-controlled and reproducible.

---

# UC-015: Onboard a New ML Project

## Primary Actor

Platform Engineer

## Goal

Enable a new project to use shared platform capabilities.

## Main Flow

1. Create project configuration.
2. Configure permissions.
3. Connect storage.
4. Enable experiment tracking.
5. Enable registry access.
6. Enable deployment workflows.

## Outcome

New projects begin using standardized platform services with minimal setup.

---

# End-to-End Lifecycle

The platform supports the following high-level workflow:

```text
Raw Data
    │
    ▼
Data Ingestion
    │
    ▼
Curated Dataset
    │
    ▼
Feature Generation
    │
    ▼
Model Training
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
Inference
    │
    ▼
Monitoring
    │
    ▼
Drift Detection
    │
    ▼
Retraining
    │
    └───────────────┐
                    ▼
             New Model Version
```

---

# Use Case Traceability

| Use Case | Related Functional Requirements |
| -------- | ------------------------------- |
| UC-001   | FR-001, FR-002, FR-003          |
| UC-002   | FR-001, FR-003                  |
| UC-003   | FR-014, FR-015, FR-016          |
| UC-004   | FR-004, FR-005, FR-006          |
| UC-005   | FR-007, FR-008, FR-009          |
| UC-006   | FR-010, FR-011, FR-013          |
| UC-007   | FR-017, FR-018, FR-021          |
| UC-008   | FR-017, FR-023                  |
| UC-009   | FR-022, FR-023, FR-024          |
| UC-010   | FR-024, FR-025                  |
| UC-011   | FR-026, FR-027, FR-028          |
| UC-012   | FR-020                          |
| UC-013   | FR-001, FR-016                  |
| UC-014   | FR-033                          |
| UC-015   | FR-034, FR-035, FR-036          |

---

# Capability Ownership Matrix

| Capability          | Data Eng | Data Scientist | ML Eng | MLOps | Platform | Analyst |
| ------------------- | :------: | :------------: | :----: | :---: | :------: | :-----: |
| Data Ingestion      |     ✅    |        ❌       |    ❌   |   ❌   |     ❌    |    ❌    |
| Feature Store       |     ✅    |        ✅       |    ❌   |   ❌   |     ❌    |    ✅    |
| Training            |     ❌    |        ✅       |    ✅   |   ✅   |     ❌    |    ❌    |
| Experiment Tracking |     ❌    |        ✅       |    ✅   |   ✅   |     ❌    |    ❌    |
| Model Registry      |     ❌    |        ❌       |    ✅   |   ✅   |     ❌    |    ❌    |
| Deployment          |     ❌    |        ❌       |    ✅   |   ✅   |     ❌    |    ❌    |
| Monitoring          |     ❌    |        ❌       |    ❌   |   ✅   |     ✅    |    ❌    |
| Infrastructure      |     ❌    |        ❌       |    ❌   |   ❌   |     ✅    |    ❌    |

---

# Summary

These use cases demonstrate how different personas collaborate through shared platform capabilities to build, deploy, monitor, and improve data and machine learning solutions.

Rather than implementing isolated project-specific workflows, the Startup Data & AI Platform standardizes the end-to-end lifecycle, enabling consistent operations, reproducibility, governance, and scalability across multiple applications and teams.
