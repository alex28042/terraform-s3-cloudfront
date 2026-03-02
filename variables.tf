variable "project_name" {
  description = "Project name used as prefix for all resource names."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)."
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region where resources will be deployed."
  type        = string
  default     = "eu-west-1"
}

variable "cache_ttl" {
  description = "Default CloudFront cache TTL in seconds. Higher = fewer S3 requests = cheaper."
  type        = number
  default     = 604800 # 7 days - maximizes cache hits to reduce S3 GET costs
}

variable "enable_versioning" {
  description = "Enable S3 versioning. Disabled by default to save storage costs (Free Tier = 5GB)."
  type        = bool
  default     = false
}

variable "price_class" {
  description = "CloudFront price class. PriceClass_100 = US+EU, PriceClass_200 = +Asia, PriceClass_All = global."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "Price class must be PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS. Restrict to your frontend domain in production."
  type        = list(string)
  default     = ["*"]
}

variable "create_iam_user" {
  description = "Create an IAM user with access keys for external platforms (Railway, Vercel, Render, etc.)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
