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
  default     = "dev"
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