# The Bootstrap Layer

## Production-Grade Checklist for our backend

When creating these buckets, ensure they meet these "production-grade" standards:

- **Versioning Enabled:** Crucial for recovering froma corrupyed state file.

- **Server-Side Encryption:** State files oftem contain sensitive data (like database passwords or API keys) in plain text.

- **Public Access Blocked:** Ensure the bucket has "Block all public access" turned on.

- **State locking:**

    - **Traditional:** Use a **DynamoDB table** with a partition key named `LockID`.
    - **Modern (Terraform 1.10+):** Use the new **Native S3 Locking** feature, which eliminates the need for a separate DynamoDB table.

- **Deletion Protection:** Set `prevent_destroy = true` on the S3 bucket resource to prevent accidental deletion.

---

The goal is to balance **maximum isolation** with **managable complexity**, while we can create a separate bucket for every layer and environment, it is generally considered overkill and introduces significant overhead.

## The Recommended Strategy: One Bucket per Environment

The industry standard is to create **one S3 bucket per AWS account/environment** (e.g., one for `staging`, one for `prod`). We then use **folder-like "keys"** within that bucket to separate our layers

Layers | Environment | S3 Bucket | Key (Path)
--- | --- | --- |---
Identity | Staging    | `myproject-staging-tfstate` | `identity/terraform.tfstate`
Platform | Staging    | `myproject-staging-tfstate` | `platform/terraform.tfstate`
Identity | Production | `myproject-prod-tfstate`    | `identity/terraform.tfstate`
Platform | Production | `myproject-prod-tfstate`    | `platform/terraform.tfstate`

### Why this works:

- **Security Isolation:** We can apply strict IAM policies to the `prod` bucket so only our CI/CD pipeline or a few senior can access it.

- **Blast Radius Control:** If a state file in the `platform` layer gets corrupted, the `identity` layer remains untouched because they are separate files.

- **Reduced Management:** We only have 2-3 "foundtaion" buckets to maintain (versioning, encyrption, etc.) instead of 12+.


---

## Addressing Our "Dev" State

While we mentiosned using **local state** for `dev`, this is generally **discouraged** for anything beyond a solo learning project for a few reasons:

1. **Collaberaiton:** If another developer need to jump into the `dev` environment, they won't have our state file.

2. **State Loss:** If our laptop crached or we accidentlly delete the `.tfstate` file, we lose track of everything we built, and we'll have to manually clean up cloud resources.

3. **Consisteny:** Using the same **Remote S3** setup for `dev` ensure that your "dev-to-prod" promotion process is identical. It's better to find out your backend config is broken in `dev` than in `staging`.

---

## The Final Hierarchy (the Pro Way)

If we want a truly "production-garde" setup, we need to organize our project like this:

1. **Staging AWS Account:** One bucket `company-staging-tfstate`

    1. `identity/`
    2. `core/`
    3. `platform/`
    4. `apps/`

2. **Production AWS Account:** One bucket `company-prod-tfstate`

    1. `identity/`
    2. `code/`
    3. `platform/`
    4. `apps/`

**Tip:** We cal also use tool like [Terragrunt](https://docs.terragrunt.com/features/units/state-backend/) to automatically generate these bucket paths based on our folder structure so we don't have to manually write `backend "s3" {}` block for ever layer.
