variable "name_prefix" {
  description = "Prefix for naming CloudFront resources."
  type        = string
}

variable "s3_bucket_regional_domain" {
  description = "Regional domain name of the S3 bucket origin."
  type        = string
}

variable "origin_id" {
  description = "Identifier for the S3 origin within CloudFront."
  type        = string
}

variable "cache_default_ttl" {
  description = "Default cache TTL in seconds."
  type        = number
  default     = 86400
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "cors_allowed_origins" {
  description = "Allowed origins for the response headers CORS policy."
  type        = list(string)
  default     = ["*"]
}
