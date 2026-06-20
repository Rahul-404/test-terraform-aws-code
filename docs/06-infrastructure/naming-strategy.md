# Naming Strategy

## Purpose

This document defines the naming conventions used across the platform.

Consistent naming improves:

* Resource discoverability
* Operational visibility
* Troubleshooting
* Automation
* Governance
* Infrastructure maintainability

Naming standards ensure that engineers can quickly identify a resource's purpose, environment, ownership, and platform role.

All infrastructure resources should follow the conventions described in this document.

---

# Design Principles

## Consistency

Resources performing similar functions should follow the same naming pattern.

Benefits:

* Easier navigation
* Faster troubleshooting
* Reduced operational errors

---

## Readability

Resource names should clearly communicate:

* Environment
* Service
* Component
* Resource purpose

without requiring additional documentation.

---

## Predictability

Names should be generated from standardized patterns rather than manually chosen values.

Benefits:

* Easier automation
* Reduced naming conflicts
* Improved operational efficiency

---

## Scalability

Naming conventions should remain valid as the platform grows from startup scale to larger production deployments.

---

# Naming Components

The platform uses a structured naming model.

```text
<project>-<environment>-<service>-<component>
```

Example:

```text
mlops-prod-model-serving-eks
```

---

## Component Definitions

| Component   | Description             | Example       |
| ----------- | ----------------------- | ------------- |
| Project     | Platform identifier     | mlops         |
| Environment | Deployment environment  | prod          |
| Service     | Business capability     | model-serving |
| Component   | Infrastructure resource | eks           |

Example:

```text
mlops-prod-model-serving-eks
```

---

# Environment Abbreviations

To maintain consistency, environment names use standardized values.

| Environment | Value |
| ----------- | ----- |
| Development | dev   |
| Staging     | stg   |
| Production  | prod  |

Examples:

```text
mlops-dev-training-s3
```

```text
mlops-stg-training-s3
```

```text
mlops-prod-training-s3
```

---

# Service Naming

Services represent platform capabilities.

Examples:

| Service             |
| ------------------- |
| data-platform       |
| feature-store       |
| model-training      |
| experiment-tracking |
| model-serving       |
| monitoring          |
| cicd                |

Example:

```text
mlops-prod-model-training-eks
```

---

# Infrastructure Component Naming

Infrastructure resources use consistent component identifiers.

| Resource Type  | Component  |
| -------------- | ---------- |
| VPC            | vpc        |
| EKS Cluster    | eks        |
| S3 Bucket      | s3         |
| RDS Database   | rds        |
| ECR Repository | ecr        |
| Prometheus     | prometheus |
| Grafana        | grafana    |
| Loki           | loki       |
| Jenkins        | jenkins    |

Example:

```text
mlops-prod-monitoring-prometheus
```

---

# Resource Naming Patterns

## VPC

Pattern:

```text
<project>-<environment>-vpc
```

Example:

```text
mlops-prod-vpc
```

---

## Subnets

Pattern:

```text
<project>-<environment>-<type>-subnet
```

Examples:

```text
mlops-prod-public-subnet
```

```text
mlops-prod-private-subnet
```

---

## EKS Clusters

Pattern:

```text
<project>-<environment>-eks
```

Example:

```text
mlops-prod-eks
```

---

## ECR Repositories

Pattern:

```text
<project>-<environment>-<service>-ecr
```

Example:

```text
mlops-prod-model-serving-ecr
```

---

## S3 Buckets

Pattern:

```text
<project>-<environment>-<purpose>-s3
```

Examples:

```text
mlops-prod-artifacts-s3
```

```text
mlops-prod-datasets-s3
```

```text
mlops-prod-backups-s3
```

---

## Databases

Pattern:

```text
<project>-<environment>-<service>-rds
```

Example:

```text
mlops-prod-mlflow-rds
```

---

## IAM Roles

Pattern:

```text
<project>-<environment>-<service>-role
```

Examples:

```text
mlops-prod-jenkins-role
```

```text
mlops-prod-training-role
```

---

# Kubernetes Naming

## Namespace Naming

Pattern:

```text
<service>
```

Examples:

```text
model-serving
```

```text
monitoring
```

```text
training
```

---

## Deployment Naming

Pattern:

```text
<application-name>
```

Examples:

```text
inference-api
```

```text
feature-service
```

```text
training-service
```

Environment separation is handled by cluster configuration rather than deployment naming.

---

# Terraform Naming Strategy

Terraform resources should derive names from common variables.

Example:

```text
project
environment
service
```

Combined to generate:

```text
mlops-prod-model-serving
```

Benefits:

* Reduced duplication
* Consistent resource creation
* Easier maintenance

---

# Monitoring Resource Naming

Monitoring resources follow service-based naming.

Examples:

```text
model-serving-dashboard
```

```text
training-alerts
```

```text
platform-metrics
```

This improves observability and alert ownership.

---

# Logging Resource Naming

Log groups should follow:

```text
<environment>/<service>/<component>
```

Examples:

```text
prod/model-serving/api
```

```text
prod/training/jobs
```

```text
prod/monitoring/prometheus
```

Benefits:

* Easier searching
* Better retention management
* Improved troubleshooting

---

# Naming Constraints

Resource names should:

### Allowed

* Lowercase letters
* Numbers
* Hyphens

Example:

```text
mlops-prod-model-serving-eks
```

---

### Avoid

* Spaces
* Special characters
* Inconsistent abbreviations
* Team-specific naming styles

Examples:

```text
❌ MLOps_Prod_EKS
❌ ProdCluster1
❌ RahulEksCluster
```

---

# Automation Considerations

Automation systems rely on predictable names for:

* CI/CD deployments
* Monitoring discovery
* Resource inventory
* Cost reporting
* Security scanning

Consistent naming significantly reduces operational complexity.

---

# Relationship with Tagging

Naming and tagging serve different purposes.

| Naming                    | Tagging                           |
| ------------------------- | --------------------------------- |
| Human-readable identifier | Resource metadata                 |
| Used during operations    | Used for filtering and governance |
| Visible in dashboards     | Used by automation                |
| Limited information       | Rich metadata                     |

Both strategies should be used together.

---

# Future Evolution

As the platform grows, naming conventions may expand to support:

* Multi-account deployments
* Multi-region deployments
* Shared services
* Platform teams
* Compliance requirements

The core naming model should remain stable to avoid operational disruption.

---

# Related Documents

* Tagging Strategy
* Account Strategy
* Environment Strategy
* Provider Configuration
* Cost Management

Together, these documents define how resources are identified, organized, discovered, and governed throughout the platform lifecycle.
