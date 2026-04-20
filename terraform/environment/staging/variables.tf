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
  default = "my-log-bucket"
}

variable "access_log_prefix" {
  type    = string
  default = "artifact-logs/"
}
