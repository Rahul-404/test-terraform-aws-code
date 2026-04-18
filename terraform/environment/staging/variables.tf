########################
#   global variables   #
########################

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "ap-south-1"
}