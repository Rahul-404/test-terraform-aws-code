# Project Template

## Purpose

This document defines the standard project template used for all machine learning projects onboarded onto the platform.

The template provides:

* Consistent project structure
* Reusable development patterns
* Standardized deployment workflows
* Built-in MLOps integration
* Reduced setup effort

Every new project should start from this template.

---

# Design Goals

The project template is designed to be:

* Production-ready
* Reproducible
* Deployable
* Observable
* Testable
* Easy to understand

The template prioritizes maintainability over experimentation convenience.

---

# Template Philosophy

The platform follows:

```text id="m7r2p8"
Data
  │
  ▼

Training
  │
  ▼

Model
  │
  ▼

API
  │
  ▼

Deployment
  │
  ▼

Monitoring
```

Every project follows the same lifecycle.

---

# Standard Repository Layout

```text id="k4m8r3"
project/
│
├── src/
│
├── config/
│
├── pipelines/
│
├── deployment/
│
├── docker/
│
├── tests/
│
├── notebooks/
│
├── scripts/
│
├── data/
│
├── artifacts/
│
│
├── requirements.txt
├── README.md
├── Makefile
└── .gitignore
```

---

# High-Level Structure

```text id="v8m3r5"
Repository
    │
    ├── Source Code
    ├── Configuration
    ├── Pipelines
    ├── Deployment
    ├── Testing
    └── Documentation
```

---

# Source Code Layer

All business logic resides in:

```text id="p2m7r9"
src/
```

Structure:

```text id="n5r8m2"
src/
│
├── data/
├── features/
├── models/
├── training/
├── inference/
├── api/
└── utils/
```

---

# Data Module

Location:

```text id="w7m4p3"
src/data/
```

Responsibilities:

* Data ingestion
* Data validation
* Dataset loading
* Schema handling

Example:

```text id="y4m8r1"
src/data/
├── ingestion.py
├── validation.py
└── loader.py
```

---

# Feature Engineering Module

Location:

```text id="q8m3r4"
src/features/
```

Responsibilities:

* Feature generation
* Encoding
* Transformation
* Scaling

Example:

```text id="x2m7r8"
src/features/
├── transformer.py
├── encoder.py
└── pipeline.py
```

---

# Model Module

Location:

```text id="f4m8r2"
src/models/
```

Responsibilities:

* Model definitions
* Model loading
* Model saving

Example:

```text id="k7r3m8"
src/models/
├── trainer.py
├── evaluator.py
└── registry.py
```

---

# Training Module

Location:

```text id="t5m8r1"
src/training/
```

Responsibilities:

* Training orchestration
* Hyperparameter handling
* Experiment tracking

Example:

```text id="p3m7r9"
src/training/
├── train.py
├── evaluate.py
└── register.py
```

---

# Inference Module

Location:

```text id="r8m2p5"
src/inference/
```

Responsibilities:

* Prediction logic
* Request processing
* Response generation

Example:

```text id="u6m4r8"
src/inference/
├── predictor.py
└── service.py
```

---

# API Layer

Location:

```text id="n4m9r2"
src/api/
```

Responsibilities:

* REST endpoints
* Request validation
* Health checks

Example:

```text id="a7m3r5"
src/api/
├── routes.py
├── schemas.py
└── app.py
```

---

# Configuration Layer

Location:

```text id="j8m2r4"
config/
```

Purpose:

Centralized configuration management.

Example:

```text id="g4m7r8"
config/
├── dev.yaml
├── staging.yaml
└── prod.yaml
```

---

# Pipeline Layer

Location:

```text id="z5m2r7"
pipelines/
```

Purpose:

Pipeline entry points.

Example:

```text id="k2m7p9"
pipelines/
├── training_pipeline.py
├── inference_pipeline.py
└── batch_pipeline.py
```

---

# Deployment Layer

Location:

```text id="r6m3p8"
deployment/
```

Purpose:

Deployment manifests.

Example:

```text id="w4p7m2"
deployment/
├── kubernetes/
├── helm/
└── manifests/
```

---

# Docker Layer

Location:

```text id="n9r4m7"
docker/
```

Example:

```text id="p3m7n8"
docker/
├── Dockerfile
└── .dockerignore
```

Provides reproducible container builds.

---

# Testing Layer

Location:

```text id="f6r2m9"
tests/
```

Structure:

```text id="v7r3m8"
tests/
├── unit/
├── integration/
└── api/
```

---

# Notebook Layer

Location:

```text id="k5m2r7"
notebooks/
```

Purpose:

Exploration only.

Rule:

```text id="n2m9r4"
Production logic
must never live
inside notebooks.
```

---

# Scripts Layer

Location:

```text id="m3r8p5"
scripts/
```

Purpose:

Utility operations.

Examples:

```text id="q4m7r2"
download_data.sh

bootstrap.sh

seed_data.py
```

---

# Data Directory

Location:

```text id="w8m3r6"
data/
```

Structure:

```text id="p7m2r8"
data/
├── raw/
├── processed/
└── external/
```

For local development only.

Large datasets should live in object storage.

---

# Artifacts Directory

Location:

```text id="t4m8r3"
artifacts/
```

Examples:

```text id="x9m2r5"
trained models

reports

evaluation outputs
```

Production artifacts should be stored in MLflow or S3.

---

# Required Endpoints

Every serving application must expose:

```text id="c7m4r9"
/predict

/health

/metrics
```

---

# Required CI/CD Integration

Every project must support:

```text id="r5m8p2"
Lint

Tests

Build

Deploy
```

GitHub Actions workflows should work without modification.

---

# Required Observability

Every project should provide:

```text id="u2m7r4"
Structured Logs

Metrics

Health Checks
```

---

# Required Documentation

Each project must include:

```text id="j7m3r8"
README

Architecture Diagram

Model Description

Deployment Instructions
```

---

# Example Repository

```text id="d8m4r1"
heart-stroke-prediction/
│
├── src/
├── config/
├── pipelines/
├── deployment/
├── tests/
├── docker/
├── notebooks/
├── scripts/
├── data/
├── artifacts/
│
├── requirements.txt
├── README.md
└── Makefile
```

---

# Template Inheritance

Every onboarded project inherits:

```text id="z2m8r7"
CI/CD Standards

Deployment Standards

Security Standards

Observability Standards

Governance Standards
```

This ensures consistency across the platform.

---

# Anti-Patterns

## Business Logic in Notebooks

```text id="e4m7r2"
❌ notebooks/train.ipynb
```

---

## Flat Project Structure

```text id="p6m3r8"
❌ 50 files in root directory
```

---

## Hardcoded Configuration

```text id="s8m2r4"
❌ config values inside code
```

---

## No Tests

```text id="h5m7r9"
❌ deployment without validation
```

---

# Future Evolution

As the platform grows, the template may include:

* Feature store integration
* Automated data validation
* Model monitoring hooks
* LLMOps support
* Agentic AI support
* Multi-model serving support

---

# Core Principle

```text id="f3m8r2"
Every project should look familiar,
regardless of who created it.
```

---

# Related Documents

* Onboarding Overview
* Adding New Project
* Heart Stroke Prediction Example
* Fraud Detection Example
* Recommendation System Example

Together, these documents define the standard foundation used for every machine learning project onboarded onto the platform.
