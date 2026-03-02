output "policy_arn" {
  description = "IAM policy ARN to attach to the backend role."
  value       = aws_iam_policy.this.arn
}

output "access_key_id" {
  description = "Access Key ID for the backend IAM user."
  value       = var.create_user ? aws_iam_access_key.this[0].id : null
}

output "secret_access_key" {
  description = "Secret Access Key for the backend IAM user."
  value       = var.create_user ? aws_iam_access_key.this[0].secret : null
  sensitive   = true
}
