output "cdn_url" {
  description = "CDN URL for the frontend to load cached assets."
  value       = "https://${module.cdn.domain_name}"
}

output "cdn_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation)."
  value       = module.cdn.distribution_id
}

output "s3_bucket_name" {
  description = "S3 bucket name for backend configuration."
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.s3.bucket_arn
}

output "backend_policy_arn" {
  description = "IAM policy ARN to attach to your backend role/user."
  value       = module.iam.policy_arn
}

output "backend_access_key_id" {
  description = "Access Key ID for Railway/Vercel/Render env vars (only if create_iam_user = true)."
  value       = module.iam.access_key_id
}

output "backend_secret_access_key" {
  description = "Secret Access Key for Railway env vars (only if create_iam_user = true). Run: terraform output -raw backend_secret_access_key"
  value       = module.iam.secret_access_key
  sensitive   = true
}
