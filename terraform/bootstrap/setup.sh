#!/bin/bash
set -e

echo "🚀 Starting Bootstrap..."

# 1. Initialize with local state (since S3 doesn't exist yet)
terraform init

# 2. Apply and auto-approve
terraform apply -auto-approve

# 3. Capture bucket names into variables or a file
DEV_BUCKET=$(terraform output -raw dev_bucket_name)
STAGING_BUCKET=$(terraform output -raw staging_bucket_name)
PROD_BUCKET=$(terraform output -raw prod_bucket_name)

echo "✅ Buckets Created: $DEV_BUCKET, $STAGING_BUCKET, $PROD_BUCKET"
