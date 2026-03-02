locals {
  name_prefix = "${var.project_name}-${var.environment}"
  bucket_name = "${local.name_prefix}-assets"
  origin_id   = "s3-${local.bucket_name}"
}
