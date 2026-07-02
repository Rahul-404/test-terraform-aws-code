variable "project_name" {
  description = "The name of the project, used as a prefix for resource naming and identification."
  type        = string
}

variable "region" {
  description = "The AWS region where resources will be deployed. Defaults to Mumbai (ap-south-1)."
  type        = string
  default     = "ap-south-1"
}

# variable "dev_bucket_name" {
#   description = "The globally unique name for the S3 bucket that will store the development environment state."
#   type        = string
# }

# variable "dev_bucket_tags" {
#   description = "A mapping of tags (e.g., Environment, Owner, CostCenter) to assign to the development S3 bucket."
#   type        = map(string)
# }

# variable "staging_bucket_name" {
#   description = "The globally unique name for the S3 bucket that will store the staging environment state."
#   type        = string
# }

# variable "staging_bucket_tags" {
#   description = "A mapping of tags (e.g., Environment, Owner, CostCenter) to assign to the staging S3 bucket."
#   type        = map(string)
# }

# variable "prod_bucket_name" {
#   description = "The globally unique name for the S3 bucket that will store the production environment state."
#   type        = string
# }

# variable "prod_bucket_tags" {
#   description = "A mapping of tags (e.g., Environment, Owner, CostCenter) to assign to the production S3 bucket."
#   type        = map(string)
# }
