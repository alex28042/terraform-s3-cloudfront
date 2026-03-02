variable "policy_name" {
  description = "Name for the IAM policy."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to grant permissions on."
  type        = string
}
