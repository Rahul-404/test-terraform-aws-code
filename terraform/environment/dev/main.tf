#   /-------------------------------------/
#  / artifact storage : s3 bucket module /
# /-------------------------------------/

module "artifact_bucket" {
  source = "../../modules/s3"

  tags = merge({
    Environment = "dev"
    Project     = "demo"
    },
    var.additional_tags
  )

  bucket_name           = "${var.environment}-lambda-artifacts-bucket"
  kms_key_arn           = null
  enable_versioning     = false
  enable_access_logging = false
}