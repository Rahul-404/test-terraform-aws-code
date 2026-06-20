# Fraud Detection Example

## Purpose

This document demonstrates how a real-time fraud detection system is onboarded, developed, deployed, and operated on the platform.

The example shows how the platform supports:

* High-volume inference
* Low-latency predictions
* Continuous model improvement
* Production monitoring
* Safe deployment practices

This serves as a reference implementation for real-time machine learning systems.

---

# Business Problem

Financial transactions occur continuously.

Some transactions may be fraudulent and must be identified before they are approved.

The model predicts:

```text id="m7r2p8"
Fraudulent Transaction

Yes / No
```

for each incoming transaction.

---

# Business Goal

Reduce financial losses by detecting suspicious transactions in real time.

Expected benefits:

* Fraud prevention
* Reduced chargebacks
* Improved customer trust
* Faster fraud investigation

---

# Success Metrics

| Metric            | Target  |
| ----------------- | ------- |
| Recall            | > 95%   |
| Precision         | > 85%   |
| F1 Score          | > 90%   |
| Inference Latency | < 100ms |
| Availability      | > 99.9% |

Recall is prioritized because missed fraud is expensive.

---

# Project Creation

Repository:

```text id="k4m8r3"
fraud-detection-system
```

---

# Repository Structure

Uses the standard platform template.

```text id="v8m3r5"
fraud-detection-system/
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
└── artifacts/
```

---

# Project Metadata

```yaml id="p2m7r9"
project:
  name: fraud-detection
  owner: risk-team
  domain: fintech
```

---

# Input Data

Transaction events may include:

```text id="n5r8m2"
Transaction Amount

Merchant Category

Customer ID

Transaction Time

Country

Device Information

Payment Method
```

---

# Data Pipeline

```text id="w7m4p3"
Raw Transactions
        │
        ▼

Validation
        │
        ▼

Feature Generation
        │
        ▼

Training Dataset
```

---

# Data Processing Layer

Location:

```text id="y4m8r1"
src/data/
```

Responsibilities:

```text id="q8m3r4"
Data Validation

Data Cleaning

Feature Extraction
```

---

# Feature Engineering

Location:

```text id="x2m7r8"
src/features/
```

Examples:

```text id="f4m8r2"
Transaction Velocity

Transaction Frequency

Customer Spending Patterns

Geographic Features
```

---

# Handling Class Imbalance

Fraud datasets are highly imbalanced.

Example:

```text id="k7r3m8"
Normal Transactions: 99.8%

Fraud Transactions: 0.2%
```

Techniques:

```text id="t5m8r1"
Class Weighting

SMOTE

Undersampling

Threshold Tuning
```

---

# Training Pipeline

Location:

```text id="p3m7r9"
pipelines/training_pipeline.py
```

Workflow:

```text id="r8m2p5"
Load Data
      │
      ▼

Feature Engineering
      │
      ▼

Train
      │
      ▼

Evaluate
      │
      ▼

Register Model
```

---

# Candidate Models

Examples:

```text id="u6m4r8"
XGBoost

LightGBM

Random Forest

Logistic Regression
```

Model selection is based on business metrics.

---

# Experiment Tracking

MLflow tracks:

```text id="n4m9r2"
Parameters

Metrics

Artifacts

Model Versions
```

Example:

```text id="a7m3r5"
Run #108

Model: XGBoost

Recall: 97%
```

---

# Evaluation Strategy

Evaluation focuses on:

```text id="j8m2r4"
Precision

Recall

F1

ROC-AUC

PR-AUC
```

PR-AUC is important due to class imbalance.

---

# Model Registration

Approved model:

```text id="g4m7r8"
FraudDetectionModel

Version 3
```

Stored in model registry.

---

# Real-Time Inference Service

Location:

```text id="z5m2r7"
src/inference/
```

Responsibilities:

```text id="k2m7p9"
Feature Construction

Model Prediction

Risk Scoring

Response Generation
```

---

# API Layer

Endpoints:

```text id="r6m3p8"
/predict

/health

/metrics
```

---

# Example Request

```json id="w4p7m2"
{
  "amount": 25000,
  "country": "US",
  "merchant_category": "electronics",
  "payment_method": "credit_card"
}
```

---

# Example Response

```json id="n9r4m7"
{
  "fraud": true,
  "risk_score": 0.96
}
```

---

# Runtime Prediction Flow

```text id="p3m7n8"
Transaction
      │
      ▼

Fraud API
      │
      ▼

Feature Processing
      │
      ▼

Model
      │
      ▼

Risk Score
```

---

# Containerization

Image:

```text id="f6r2m9"
fraud-detection:v1.0.0
```

Built via Docker and stored in ECR.

---

# CI/CD Workflow

```text id="v7r3m8"
Lint
 │
 ▼

Tests
 │
 ▼

Build
 │
 ▼

Deploy
```

---

# Deployment Architecture

```text id="k5m2r7"
GitHub Actions
       │
       ▼

AWS ECR
       │
       ▼

AWS EKS
       │
       ▼

Fraud API Service
```

---

# Scaling Requirements

Fraud systems often require horizontal scaling.

```text id="n2m9r4"
Low Latency

High Throughput

Multiple Replicas
```

Example:

```text id="m3r8p5"
3-10 pods
```

depending on traffic.

---

# Environment Promotion

```text id="q4m7r2"
dev
 │
 ▼

staging
 │
 ▼

prod
```

Same promotion strategy as all platform projects.

---

# Monitoring Metrics

Key metrics:

```text id="w8m3r6"
Request Rate

Prediction Latency

Error Rate

CPU Usage

Memory Usage
```

---

# ML Monitoring Metrics

Additional model metrics:

```text id="p7m2r8"
Fraud Rate

Prediction Distribution

Data Drift

Feature Drift
```

---

# Alerting

Examples:

```text id="t4m8r3"
Latency > 100ms

Error Rate > 2%

Model Drift Detected
```

---

# Drift Detection

Fraud behavior changes over time.

Monitoring checks:

```text id="x9m2r5"
Input Distribution Changes

Prediction Distribution Changes
```

Drift may trigger retraining.

---

# Retraining Workflow

```text id="c7m4r9"
New Data
    │
    ▼

Retraining
    │
    ▼

Evaluation
    │
    ▼

Registry
    │
    ▼

Deployment
```

---

# Rollback Example

```text id="r5m8p2"
Model v4
   │
   ▼

Performance Drop
   │
   ▼

Rollback
   │
   ▼

Model v3
```

---

# End-to-End Lifecycle

```text id="u2m7r4"
Transactions
      │
      ▼

Data Pipeline
      │
      ▼

Training
      │
      ▼

Evaluation
      │
      ▼

Model Registry
      │
      ▼

Deployment
      │
      ▼

Monitoring
      │
      ▼

Retraining
```

---

# Platform Components Used

```text id="j7m3r8"
MLflow

GitHub Actions

Docker

AWS ECR

AWS EKS

Prometheus

Grafana
```

---

# What This Example Demonstrates

This project demonstrates:

* Real-time inference workloads
* Low-latency serving
* Imbalanced classification handling
* Drift monitoring
* Continuous model improvement

The platform architecture remains unchanged despite different workload characteristics.

---

# Lessons Learned

```text id="d8m4r1"
The platform should support
different ML workloads
without requiring
different operational models.
```

Fraud Detection and Heart Stroke Prediction have different business requirements, but they follow the same onboarding, deployment, monitoring, and governance framework.

---

# Related Documents

* Onboarding Overview
* Adding New Project
* Project Template
* Heart Stroke Prediction Example
* Recommendation System Example

Together, these examples demonstrate how diverse machine learning systems can be standardized on a single MLOps platform.
