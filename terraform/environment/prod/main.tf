#   /-------------------------------------/
#  / artifact storage : s3 bucket module /
# /-------------------------------------/

module "artifact_bucket" {
  source = "../../modules/s3"

  tags = merge({
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
    },
    var.additional_tags
  )

  bucket_name           = "${var.environment}-lambda-artifacts-bucket"
  kms_key_arn           = null
  enable_versioning     = true
  enable_access_logging = true
  access_log_bucket     = local.resolved_log_bucket
  access_log_prefix     = local.resolved_log_prefix
}
