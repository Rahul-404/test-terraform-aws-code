# Tagging Strategy

## Purpose

This document defines the resource tagging standards used across the platform.

Tags provide metadata that enables teams to identify, organize, secure, monitor, and manage cloud resources consistently.

The tagging strategy supports:

* Cost allocation
* Resource ownership
* Governance
* Automation
* Operational visibility
* Security auditing

All infrastructure resources created through Terraform must follow this tagging standard.

---

# Design Principles

## Consistency

All resources should use a common tagging schema.

Consistent tagging improves:

* Searchability
* Reporting
* Automation
* Troubleshooting

---

## Mandatory Metadata

Every resource should include sufficient metadata to identify:

* Ownership
* Environment
* Purpose
* Platform component

---

## Automation Friendly

Tags should support automated processes such as:

* Cost reporting
* Cleanup jobs
* Monitoring policies
* Security checks
* Compliance validation

---

## Human Readability

Tags should be understandable by engineers, operators, and auditors without requiring external documentation.

---

# Tag Categories

Tags are grouped into four categories.

```text id="a7m4k2"
Operational Tags
        │
        ├── Environment
        ├── Service
        └── Component

Ownership Tags
        │
        ├── Team
        └── Owner

Cost Tags
        │
        └── Cost Center

Governance Tags
        │
        ├── Managed By
        └── Data Classification
```

---

# Mandatory Tags

Every managed resource must include the following tags.

| Tag         | Description              | Example        |
| ----------- | ------------------------ | -------------- |
| Project     | Platform identifier      | mlops-platform |
| Environment | Deployment environment   | dev            |
| Service     | Business capability      | model-serving  |
| Component   | Infrastructure component | eks            |
| ManagedBy   | Management system        | terraform      |
| Owner       | Responsible team         | platform-team  |

---

## Example

```text id="v8p2q5"
Project      = mlops-platform
Environment  = prod
Service      = model-serving
Component    = eks
ManagedBy    = terraform
Owner        = platform-team
```

---

# Environment Tags

Environment tags identify deployment boundaries.

Allowed values:

| Tag         | Values  |
| ----------- | ------- |
| Environment | dev     |
| Environment | staging |
| Environment | prod    |

Example:

```text id="d5r9n1"
Environment = prod
```

These tags support:

* Cost allocation
* Monitoring filters
* Access controls
* Resource grouping

---

# Service Tags

Service tags identify business capabilities.

Examples:

| Service             |
| ------------------- |
| data-platform       |
| feature-store       |
| model-training      |
| experiment-tracking |
| model-serving       |
| monitoring          |
| ci-cd               |

Example:

```text id="t3m7v6"
Service = model-training
```

---

# Component Tags

Component tags identify infrastructure modules.

Examples:

| Component  |
| ---------- |
| vpc        |
| eks        |
| s3         |
| rds        |
| prometheus |
| grafana    |
| loki       |
| ecr        |

Example:

```text id="y4p8c2"
Component = eks
```

---

# Ownership Tags

Ownership tags identify who is responsible for a resource.

Required tags:

| Tag   | Example       |
| ----- | ------------- |
| Owner | platform-team |
| Team  | ml-platform   |

Example:

```text id="w2n6r8"
Owner = platform-team
Team  = ml-platform
```

Benefits:

* Faster incident response
* Clear accountability
* Easier resource management

---

# Cost Allocation Tags

Cost allocation tags support budgeting and financial reporting.

Examples:

| Tag          | Example     |
| ------------ | ----------- |
| CostCenter   | engineering |
| BudgetGroup  | platform    |
| BusinessUnit | ai          |

Example:

```text id="g6q1m3"
CostCenter = engineering
```

These tags enable:

* Cost dashboards
* Budget alerts
* Resource utilization reporting

---

# Governance Tags

Governance tags support security and compliance controls.

Examples:

| Tag                | Example   |
| ------------------ | --------- |
| ManagedBy          | terraform |
| DataClassification | internal  |
| BackupRequired     | true      |

---

## Data Classification

Allowed values:

| Classification |
| -------------- |
| public         |
| internal       |
| confidential   |

Example:

```text id="b9v5d7"
DataClassification = internal
```

---

# Monitoring Tags

Monitoring systems use tags to organize infrastructure resources.

Examples:

```text id="r3x8p4"
Environment = prod
Service = model-serving
```

Benefits:

* Dashboard filtering
* Alert routing
* Operational visibility

---

# Security Applications

Security tooling may use tags for:

* Access reviews
* Compliance checks
* Resource auditing
* Backup validation

Example:

```text id="j7m2c9"
BackupRequired = true
```

Resources marked with this tag may be validated through automated backup audits.

---

# Terraform Integration

All Terraform modules inherit a common tag set.

Example pattern:

```text id="k5n4r1"
global_tags
        │
        ▼

resource_tags
        │
        ▼

cloud_resources
```

Benefits:

* Consistent tagging
* Reduced duplication
* Easier maintenance

---

# Resource Discovery

Tags allow resources to be grouped logically.

Example queries:

```text id="e8q6m2"
Environment = prod
```

Returns all production resources.

---

```text id="h4p9v5"
Service = model-serving
```

Returns all model-serving infrastructure.

---

```text id="s1k7n3"
Owner = platform-team
```

Returns resources owned by the platform team.

---

# Enforcement Strategy

Tag compliance is enforced through:

### Terraform Modules

Modules automatically apply mandatory tags.

---

### CI/CD Validation

Infrastructure pipelines validate required tags before deployment.

---

### Policy Checks

Infrastructure policies may reject resources missing required metadata.

---

# Exceptions

Some cloud-managed resources may not support tagging.

Examples:

* Certain provider-managed resources
* Temporary infrastructure
* Service-generated resources

Exceptions should be documented and minimized.

---

# Common Tag Set

The standard tag set for most resources is:

```text id="f2v8r4"
Project            = mlops-platform
Environment        = prod
Service            = model-serving
Component          = eks
ManagedBy          = terraform
Owner              = platform-team
CostCenter         = engineering
DataClassification = internal
```

This provides sufficient metadata for operational, financial, and governance purposes.

---

# Future Evolution

As the platform grows, additional tags may be introduced for:

* Compliance requirements
* Chargeback models
* Multi-team ownership
* Advanced governance controls

The core tagging model should remain stable to ensure consistency across environments.

---

# Related Documents

* Naming Strategy
* Cost Management
* Account Strategy
* Environment Strategy
* Provider Configuration

Together, these documents define how infrastructure resources are identified, organized, governed, and managed throughout the platform lifecycle.
