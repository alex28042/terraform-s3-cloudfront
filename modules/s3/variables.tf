variable "bucket_name" {
  description = "Full name for the S3 bucket."
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution allowed to read from this bucket."
  type        = string
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS requests."
  type        = list(string)
  default     = ["*"]
}

variable "enable_versioning" {
  description = "Enable S3 versioning. Disabled by default to stay within Free Tier (versioning doubles storage)."
  type        = bool
  default     = false
}

variable "noncurrent_expiration_days" {
  description = "Days before deleting old versions (only applies if versioning is enabled)."
  type        = number
  default     = 7
}
