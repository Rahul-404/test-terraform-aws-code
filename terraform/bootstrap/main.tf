# This fetches your AWS Account ID, User ID, and ARN
data "aws_caller_identity" "current" {}

locals {
  # Build the names here instead of the .tfvars
  dev_bucket_name     = "dev-${var.region}-${var.project_name}-state-bucket"
  staging_bucket_name = "staging-${var.region}-${var.project_name}-state-bucket"
  prod_bucket_name    = "prod-${var.region}-${var.project_name}-state-bucket"

  # Standardized tags to avoid repetition
  common_tags = {
    Project = var.project_name
    Region  = var.region
    Purpose = "backend bucket for ${var.project_name}"
  }

  # Standardizing Allowed Roles
  admin_roles = [
    data.aws_caller_identity.current.arn, # This adds aws cli user dynamically
    #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CI_CD_Pipeline_Role",
    #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Senior_Engineer_Role",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]
}

########################
# dev - tfstate bucket #
########################

# bucket with state locking & preventing deletion
resource "aws_s3_bucket" "dev_tfstate_bucket" {
  bucket              = local.dev_bucket_name
  region              = var.region
  object_lock_enabled = true
  tags = merge(
    local.common_tags,
    {
      Name        = local.dev_bucket_name
      Environment = "dev"
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

# versioning
resource "aws_s3_bucket_versioning" "dev_tfstate_bucket_versioning" {
  bucket = aws_s3_bucket.dev_tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "dev_tfstate_bucket_configuration" {
  bucket = aws_s3_bucket.dev_tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# block public access
resource "aws_s3_bucket_public_access_block" "dev_tfstate_bucket_block_access" {
  bucket                  = aws_s3_bucket.dev_tfstate_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# bucket security policy
resource "aws_s3_bucket_policy" "dev_tfstate_bucket_security" {
  bucket = aws_s3_bucket.dev_tfstate_bucket.id

  # Render the template with dynamic values
  policy = templatefile("${path.module}/policies/bucket_security.json.tftpl", {
    bucket_arn   = aws_s3_bucket.dev_tfstate_bucket.arn
    allowed_arns = local.admin_roles
  })
}

############################
# staging - tfstate bucket #
############################

# bucket with state locking & preventing deletion
resource "aws_s3_bucket" "staging_tfstate_bucket" {
  bucket              = local.staging_bucket_name
  region              = var.region
  object_lock_enabled = true
  tags = merge(
    local.common_tags,
    {
      Name        = local.staging_bucket_name
      Environment = "staging"
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

# versioning
resource "aws_s3_bucket_versioning" "staging_tfstate_bucket_versioning" {
  bucket = aws_s3_bucket.staging_tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "staging_tfstate_bucket_configuration" {
  bucket = aws_s3_bucket.staging_tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# block public access
resource "aws_s3_bucket_public_access_block" "staging_tfstate_bucket_block_access" {
  bucket                  = aws_s3_bucket.staging_tfstate_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# bucket security policy
resource "aws_s3_bucket_policy" "staging_tfstate_bucket_security" {
  bucket = aws_s3_bucket.staging_tfstate_bucket.id

  # Render the template with dynamic values
  policy = templatefile("${path.module}/policies/bucket_security.json.tftpl", {
    bucket_arn   = aws_s3_bucket.staging_tfstate_bucket.arn
    allowed_arns = local.admin_roles
  })
}

#########################
# prod - tfstate bucket #
#########################

# bucket with state locking & preventing deletion
resource "aws_s3_bucket" "prod_tfstate_bucket" {
  bucket              = local.prod_bucket_name
  region              = var.region
  object_lock_enabled = true
  tags = merge(
    local.common_tags,
    {
      Name        = local.prod_bucket_name
      Environment = "prod"
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

# versioning
resource "aws_s3_bucket_versioning" "prod_tfstate_bucket_versioning" {
  bucket = aws_s3_bucket.prod_tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "prod_tfstate_bucket_configuration" {
  bucket = aws_s3_bucket.prod_tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# block public access
resource "aws_s3_bucket_public_access_block" "prod_tfstate_bucket_block_access" {
  bucket                  = aws_s3_bucket.prod_tfstate_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# bucket security policy
resource "aws_s3_bucket_policy" "prod_tfstate_bucket_security" {
  bucket = aws_s3_bucket.prod_tfstate_bucket.id

  # Render the template with dynamic values
  policy = templatefile("${path.module}/policies/bucket_security.json.tftpl", {
    bucket_arn   = aws_s3_bucket.prod_tfstate_bucket.arn
    allowed_arns = local.admin_roles
  })
}
