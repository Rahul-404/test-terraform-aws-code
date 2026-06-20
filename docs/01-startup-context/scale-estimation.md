# Scale Estimation

## Purpose

This document estimates the expected workload of the Startup Data & AI Platform and explains how those estimates influence architectural decisions.

The objective is not to predict exact production numbers but to design infrastructure that is appropriately sized for a startup environment while documenting clear growth paths.

Every major architectural decision should be justifiable using these estimates.

---

# Estimation Philosophy

The platform is designed for current business needs rather than hypothetical future scale.

Instead of optimizing for millions of users from day one, the architecture prioritizes:

* Simplicity
* Operational efficiency
* Cost effectiveness
* Engineering velocity
* Incremental scalability

As demand grows, the platform can evolve without requiring a complete redesign.

---

# Organization Scale

The platform supports a small but growing engineering organization.

| Metric                     | Estimate |
| -------------------------- | -------- |
| Data Scientists            | 2–5      |
| Machine Learning Engineers | 1–3      |
| Data Engineers             | 1–3      |
| MLOps Engineers            | 1–2      |
| Platform Engineers         | 1–2      |
| Data Analysts              | 1–4      |

## Architectural Implications

* Shared infrastructure is sufficient.
* Self-service workflows reduce operational burden.
* Managed services minimize maintenance.

---

# Product Scale

The organization operates several AI-powered products.

| Metric                    | Estimate          |
| ------------------------- | ----------------- |
| ML Applications           | 3–5               |
| Data Products             | 2–4               |
| Production Models         | 6–10              |
| Active Experiments        | 100–500 per month |
| Registered Model Versions | 200+              |

Each application consumes shared platform capabilities rather than maintaining dedicated infrastructure.

---

# User Traffic

The expected customer-facing workload is moderate.

| Metric                   | Estimate     |
| ------------------------ | ------------ |
| Daily Active Users       | ~2,000       |
| Average User Actions     | 3–5          |
| Total Daily Requests     | 6,000–10,000 |
| ML-backed Requests       | 60–80%       |
| Daily Inference Requests | 5,000–25,000 |

Traffic patterns are expected to be uneven throughout the day.

Peak load is significantly higher than average load.

---

# Peak Request Estimation

Assuming:

* 25,000 inference requests/day
* Most traffic occurs during an 8-hour business window

```
25,000 ÷ (8 × 60 × 60)
≈ 0.87 requests/second average
```

Applying a conservative burst factor of 10x:

```
Peak ≈ 8–10 requests/second
```

Even under unexpected spikes:

```
Peak < 25 requests/second
```

## Architectural Implications

Current traffic does not justify:

* Kubernetes serving infrastructure
* Service mesh
* Complex autoscaling strategies
* Multi-region deployments

Managed inference endpoints remain sufficient.

---

# Training Workload

Training jobs occur much less frequently than inference.

| Metric                  | Estimate          |
| ----------------------- | ----------------- |
| Training Jobs per Month | 20–50             |
| Concurrent Jobs         | 1–3               |
| Average Duration        | 20–90 minutes     |
| Retraining Frequency    | Weekly or Monthly |

Most experimentation occurs locally.

Only promising experiments are promoted to platform-managed training jobs.

## Architectural Implications

Containerized batch training using managed compute is sufficient.

Dedicated GPU clusters or distributed schedulers are unnecessary.

---

# Experiment Tracking

Experiment tracking volume remains relatively modest.

| Metric                         | Estimate       |
| ------------------------------ | -------------- |
| Experiments per Month          | 100–500        |
| Metrics per Experiment         | 20–100         |
| Artifact Size                  | 10 MB – 500 MB |
| Total Monthly Artifact Storage | <100 GB        |

## Architectural Implications

A single centralized experiment tracking service can comfortably support expected workloads.

---

# Model Registry Growth

Model versions accumulate over time.

| Metric                      | Estimate |
| --------------------------- | -------- |
| Models                      | 6–10     |
| Versions per Model per Year | 20–50    |
| Total Versions              | 120–500  |

Metadata volume remains relatively small.

Artifacts are stored externally in object storage.

---

# Data Volume

The startup primarily works with structured datasets.

| Metric          | Estimate       |
| --------------- | -------------- |
| Raw Data        | 100 GB – 2 TB  |
| Curated Data    | 50 GB – 1 TB   |
| Feature Data    | 20 GB – 500 GB |
| Model Artifacts | <500 GB        |
| Logs & Metrics  | Several GB/day |

Storage growth is expected to be linear rather than exponential.

---

# Feature Store Usage

The platform initially supports offline feature management.

Typical characteristics:

* Daily batch updates
* Shared feature definitions
* Historical versioning
* Analytics reuse

Online feature serving is intentionally excluded.

## Architectural Implications

Object storage combined with metadata management is sufficient.

Dedicated online feature databases are unnecessary.

---

# Deployment Scale

| Metric                   | Estimate |
| ------------------------ | -------- |
| Active Endpoints         | 6–10     |
| Simultaneous Deployments | 1–2      |
| Rollbacks                | Rare     |
| Canary Releases          | Optional |

Deployment frequency remains moderate.

Infrastructure should prioritize reliability over deployment throughput.

---

# Monitoring Volume

Monitoring generates significantly more data than model metadata.

Expected telemetry includes:

* Infrastructure metrics
* Application metrics
* Endpoint logs
* Training logs
* Drift metrics
* Audit events

Estimated log volume:

* 1–5 GB/day

Estimated metrics:

* Thousands of time series

## Architectural Implications

Managed monitoring services combined with centralized dashboards are sufficient.

---

# Retraining Frequency

Retraining occurs through:

* Scheduled execution
* Manual execution
* Drift triggers
* Performance degradation triggers

Expected retraining volume:

| Metric               | Estimate    |
| -------------------- | ----------- |
| Scheduled Runs       | Weekly      |
| Drift-triggered Runs | Rare        |
| Emergency Retraining | Exceptional |

The same training capability should support both initial training and retraining.

---

# Infrastructure Growth

The expected evolution of the platform can be summarized as follows.

| Stage      | Characteristics                                                             |
| ---------- | --------------------------------------------------------------------------- |
| Startup    | Single AWS account, shared services, managed infrastructure                 |
| Growth     | Increased automation, more models, higher concurrency                       |
| Scale-up   | Multi-account architecture, stronger isolation, dedicated platform services |
| Enterprise | Multi-region, online feature store, advanced governance, Kubernetes serving |

Each stage builds on the previous one rather than replacing it.

---

# Capacity Planning Summary

| Area                | Startup Design Decision     |
| ------------------- | --------------------------- |
| Cloud               | Single AWS Account          |
| Compute             | Managed Services            |
| Training            | SageMaker Training Jobs     |
| Deployment          | Managed Inference Endpoints |
| Feature Store       | Offline First               |
| Registry            | Centralized                 |
| Experiment Tracking | Shared                      |
| Monitoring          | Centralized                 |
| Retraining          | Scheduled + Event Driven    |

These choices balance cost, simplicity, and operational efficiency for the expected workload.

---

# Bottleneck Analysis

The first scaling bottlenecks are expected to appear in:

1. Shared AWS account quotas
2. Training concurrency
3. Experiment artifact storage
4. Model endpoint concurrency
5. Monitoring data retention
6. IAM policy complexity
7. Shared networking resources

None of these are expected to become immediate blockers at startup scale but should be monitored as adoption increases.

---

# Evolution Thresholds

The current architecture should be reconsidered when one or more of the following thresholds are exceeded:

* More than 50 deployed models
* More than 20 concurrent training jobs
* Sustained traffic above 100 requests/second
* Multiple independent engineering organizations
* Regulatory compliance requirements
* Multi-region deployments
* Need for online feature serving
* Tenant isolation requirements

These thresholds justify introducing more sophisticated infrastructure rather than prematurely increasing complexity.

---

# Summary

The estimated workload demonstrates that startup-scale machine learning platforms benefit more from simplicity, automation, and managed services than from highly distributed infrastructure.

The current architecture intentionally optimizes for engineering productivity and operational maintainability while preserving clear migration paths for future growth.

As traffic, organizational complexity, and operational requirements increase, individual platform capabilities can evolve independently without requiring a complete architectural rewrite.
