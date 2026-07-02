# State Isolation

## Purpose

This document defines how Terraform state is isolated across the platform.

State isolation ensures that infrastructure changes are scoped to a specific environment and infrastructure domain, reducing operational risk and limiting the impact of deployment failures.

Without proper isolation, a single Terraform operation can unintentionally affect unrelated resources, increasing the likelihood of outages and deployment errors.

---

## Objectives

The state isolation strategy aims to achieve:

* Reduced deployment risk
* Smaller Terraform plans
* Faster Terraform execution
* Independent infrastructure ownership
* Environment separation
* Simplified disaster recovery
* Improved team scalability

---

## Why State Isolation Matters

Terraform state represents the source of truth for managed infrastructure.

When too many resources are stored within a single state file:

* Terraform plans become slow
* Apply operations become risky
* Resource dependencies become difficult to understand
* Failures impact larger portions of the platform

Example:

```text id="s2m8q4"
Single State File

network
database
storage
monitoring
kubernetes
security
ci-cd
```

A failure during deployment could potentially impact unrelated infrastructure components.

---

## Isolation Principles

### Environment Isolation

Each environment maintains independent Terraform state.

```text id="w6n1p9"
Development
    │
    ├── State Files

Staging
    │
    ├── State Files

Production
    │
    ├── State Files
```

Benefits:

* Production resources cannot be modified accidentally from development deployments.
* Environment rollbacks remain independent.
* State corruption remains isolated.

---

### Domain Isolation

Infrastructure domains maintain separate state files.

Examples:

```text id="h3v7k2"
network
security
storage
compute
monitoring
platform-services
```

Each domain is deployed independently.

Benefits:

* Smaller plans
* Reduced blast radius
* Independent deployment cycles
* Easier troubleshooting

---

## State Hierarchy

The platform uses a two-level isolation model.

```text id="r9d4c8"
Environment
      │
      ▼

Infrastructure Domain
      │
      ▼

Terraform State
```

Example:

```text id="p5x8f1"
development/network
development/storage
development/compute

staging/network
staging/storage
staging/compute

production/network
production/storage
production/compute
```

Each combination has its own Terraform state.

---

## Recommended State Structure

```text id="k7n3m6"
terraform/
│
├── environments/
│
│   ├── dev/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── compute/
│   │   └── monitoring/
│
│   ├── staging/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── compute/
│   │   └── monitoring/
│
│   └── prod/
│       ├── network/
│       ├── storage/
│       ├── compute/
│       └── monitoring/
```

Each directory manages its own state.

---

## State Ownership

Each Terraform state owns a specific set of resources.

### Network State

Owns:

* VPC
* Subnets
* Route Tables
* Internet Gateways
* NAT Gateways

---

### Storage State

Owns:

* S3 Buckets
* Lifecycle Policies
* Storage Configurations

---

### Compute State

Owns:

* EC2 Instances
* EKS Clusters
* Node Groups
* Auto Scaling Resources

---

### Monitoring State

Owns:

* Prometheus
* Grafana
* Loki
* Alerting Resources

---

### Security State

Owns:

* IAM Roles
* IAM Policies
* Security Controls

---

## Dependency Management

Direct resource references across states should be minimized.

Instead, states communicate through:

### Remote State Outputs

Example:

```text id="t8y2n7"
Network State
       │
       ▼

Exports:
- vpc_id
- subnet_ids

       │
       ▼

Compute State
```

This allows infrastructure modules to remain loosely coupled.

---

## Blast Radius Reduction

State isolation reduces deployment blast radius.

Example:

### Without Isolation

```text id="u5m1k3"
terraform apply

network
storage
compute
monitoring
security
```

Potential impact:

Entire platform.

---

### With Isolation

```text id="n4p7x9"
terraform apply

compute
```

Potential impact:

Only compute resources.

This significantly improves operational safety.

---

## Recovery Strategy

If state corruption occurs:

```text id="b2d8q5"
network state failure
       │
       ▼

recover network state only
```

Other infrastructure domains remain unaffected.

Benefits:

* Faster recovery
* Lower operational risk
* Simpler troubleshooting

---

## CI/CD Integration

Infrastructure pipelines operate on isolated states.

Example:

```text id="m7r4v2"
Network Pipeline
        │
        ▼
Network State

Storage Pipeline
        │
        ▼
Storage State

Compute Pipeline
        │
        ▼
Compute State
```

Each pipeline only modifies resources owned by its corresponding state.

---

## Trade-Off Analysis

| Strategy                       | Advantages                    | Disadvantages               |
| ------------------------------ | ----------------------------- | --------------------------- |
| Single State                   | Simple setup                  | Large blast radius          |
| Environment Isolation Only     | Better separation             | Large state size            |
| Domain Isolation Only          | Smaller plans                 | Weak environment separation |
| Environment + Domain Isolation | Strong safety and scalability | More state files to manage  |

The platform adopts Environment + Domain Isolation because it provides the best balance between operational safety and long-term scalability.

---

## Future Evolution

As the platform grows, additional infrastructure domains may be separated into dedicated state files.

Examples:

* Data Platform
* Feature Store
* ML Platform
* Observability
* Security Operations

This evolution allows infrastructure complexity to grow incrementally without requiring major architectural changes.

---

## Related Documents

* Terraform State
* Environment Strategy
* Account Strategy
* Provider Configuration
* Disaster Recovery

Together, these documents define how infrastructure state is stored, isolated, protected, and recovered across the platform.
