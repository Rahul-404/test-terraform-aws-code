variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "tags" {
  description = "Standard tags applied to the bucket"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS key ARN for SSE-KMS encryption"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

variable "enable_access_logging" {
  description = "Enable access logging"
  type        = bool
  default     = false
}

variable "access_log_bucket" {
  description = "Bucket where access logs are stored"
  type        = string
  default     = null
}

variable "access_log_prefix" {
  description = "Prefix for access logs"
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the bucket"
  type = list(object({
    id      = string
    enabled = bool

    transition = optional(list(object({
      days          = number
      storage_class = string
    })))

    expiration_days = optional(number)
  }))
  default = []
}

variable "attach_bucket_policy" {
  description = "Whether to attch a bucjet policy"
  type        = bool
  default     = false
}

variable "bucket_policy_json" {
  description = "Bucket policy JSON"
  type        = string
  default     = null
}