variable "policy_name" {
  description = "Name for the IAM policy."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to grant permissions on."
  type        = string
}

variable "create_user" {
  description = "Create an IAM user with access keys (for external platforms like Railway, Vercel, etc.)."
  type        = bool
  default     = false
}

variable "user_name" {
  description = "Name for the IAM user (only used if create_user = true)."
  type        = string
  default     = "backend-s3"
}
