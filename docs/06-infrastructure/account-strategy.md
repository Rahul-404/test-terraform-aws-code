# Account Strategy

## Purpose

This document defines how cloud accounts are organized across the platform.

The account strategy aims to balance:

* Security
* Operational simplicity
* Cost efficiency
* Environment isolation
* Future scalability

As a startup-oriented platform, the initial design avoids unnecessary complexity while providing a clear migration path toward a multi-account architecture as the organization grows.

---

## Design Principles

The account strategy follows several guiding principles.

### Simplicity First

Early-stage startups typically have small engineering teams and limited operational resources.

The platform prioritizes operational simplicity over enterprise-scale account segmentation.

---

### Isolation Where It Matters

Critical workloads should be isolated from development activities to reduce operational risk.

Isolation helps prevent:

* Accidental resource modification
* Production outages
* Security boundary violations
* Cost allocation confusion

---

### Infrastructure Evolution

The account model should evolve with organizational maturity.

The architecture should support migration from a startup deployment model to a larger production environment without requiring major redesign.

---

## Current Strategy

### Startup Phase

The platform uses a single AWS account containing multiple environments.

```text id="5p7qk1"
AWS Account
│
├── Development
├── Staging
└── Production
```

Environment separation is achieved through:

* Dedicated Terraform workspaces
* Independent Terraform state
* Environment-specific resources
* Naming conventions
* IAM controls

Benefits:

* Lower operational overhead
* Easier administration
* Reduced cloud costs
* Faster onboarding

Risks:

* Weaker security boundaries compared to multi-account architectures
* Greater need for disciplined access control
* Shared account quotas

These risks are considered acceptable during the startup phase.

---

## Planned Evolution

As platform adoption increases, environments can be separated into dedicated accounts.

### Growth Phase

```text id="y8n4d2"
AWS Organization
│
├── Shared Services Account
├── Development Account
├── Staging Account
└── Production Account
```

Benefits:

* Stronger environment isolation
* Independent account quotas
* Reduced blast radius
* Better cost attribution

---

### Scale Phase

```text id="k3m7w9"
AWS Organization
│
├── Security Account
├── Shared Services Account
├── Development Account
├── Staging Account
├── Production Account
└── Data Platform Account
```

Additional accounts may be introduced for:

* Security tooling
* Centralized logging
* Data processing
* Specialized workloads

This stage is only justified when operational complexity and compliance requirements increase significantly.

---

## Environment Ownership

Each environment owns its infrastructure resources.

### Development

Purpose:

* Feature development
* Experimentation
* Infrastructure testing

Characteristics:

* Lower availability requirements
* Frequent changes
* Cost optimization prioritized

---

### Staging

Purpose:

* Pre-production validation
* Deployment testing
* Integration testing

Characteristics:

* Production-like configuration
* Controlled deployments
* Temporary workloads

---

### Production

Purpose:

* Customer-facing workloads
* Critical business services

Characteristics:

* Highest reliability requirements
* Strict change controls
* Enhanced monitoring
* Backup and recovery procedures

---

## Shared Services

Some services may be shared across environments.

Examples:

* Container registry
* Source control integrations
* CI/CD tooling
* Documentation hosting

Shared services should remain logically separated from environment-specific resources.

---

## Access Model

Access to cloud resources follows the principle of least privilege.

Guidelines:

* No long-lived access keys
* Role-based access
* Temporary credentials where possible
* Environment-specific permissions
* Production access restricted to authorized personnel

Access policies are managed through IAM roles and Terraform.

---

## Cost Allocation

Costs are tracked through:

* Resource tagging
* Environment identifiers
* Team ownership tags

This enables:

* Environment-level cost visibility
* Budget monitoring
* Resource accountability

Detailed tagging standards are defined in the Tagging Strategy document.

---

## Security Considerations

Even within a single-account architecture, security boundaries are maintained through:

* IAM policies
* Environment-specific roles
* Secret isolation
* Resource-level permissions
* Audit logging

As the platform matures, stronger isolation can be achieved through dedicated accounts.

---

## Trade-Off Analysis

| Option                   | Advantages                            | Disadvantages                    |
| ------------------------ | ------------------------------------- | -------------------------------- |
| Single Account           | Simple, low cost, easy management     | Weaker isolation                 |
| Multi-Account            | Strong isolation, improved governance | Increased operational complexity |
| Enterprise Multi-Account | Maximum security and governance       | High operational overhead        |

The platform currently adopts the Single Account strategy because it best aligns with startup constraints while preserving a migration path toward future growth.

---

## Related Documents

* Environment Strategy
* Terraform State
* State Isolation
* Provider Configuration
* Cost Management
* Disaster Recovery
