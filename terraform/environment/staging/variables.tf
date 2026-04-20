########################
#   global variables   #
########################

variable "project_name" {
  description = "Name of project"
  type        = string
  default     = "demo-project"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "owner" {
  description = "Owner name"
  type        = string
  default     = "rahul-shelke"
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "ap-south-1"
}

########################
#     s3 variables     #
########################

variable "access_log_bucket" {
  type    = string
  default = null
}

variable "access_log_prefix" {
  type    = string
  default = null
}

locals {
  # Default values based on environment
  base_log_bucket = "${var.environment}-log-bucket"
  base_log_prefix = "${var.environment}-artifact-logs/"

  # Final resolved values (override > default)
  resolved_log_bucket = coalesce(var.access_log_bucket, local.base_log_bucket)
  resolved_log_prefix = coalesce(var.access_log_prefix, local.base_log_prefix)
}
