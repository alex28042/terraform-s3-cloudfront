terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
      },
      var.tags
    )
  }
}

module "cdn" {
  source = "./modules/cdn"

  name_prefix               = local.name_prefix
  s3_bucket_regional_domain = module.s3.bucket_regional_domain_name
  origin_id                 = local.origin_id
  cache_default_ttl         = var.cache_ttl
  price_class               = var.price_class
  cors_allowed_origins      = var.cors_allowed_origins
}

module "s3" {
  source = "./modules/s3"

  bucket_name                 = local.bucket_name
  cloudfront_distribution_arn = module.cdn.distribution_arn
  cors_allowed_origins        = var.cors_allowed_origins
  enable_versioning           = var.enable_versioning
}

module "iam" {
  source = "./modules/iam"

  policy_name   = "${local.name_prefix}-backend-s3"
  s3_bucket_arn = module.s3.bucket_arn
  create_user   = var.create_iam_user
  user_name     = "${local.name_prefix}-backend"
}

check "cdn_is_deployed" {
  assert {
    condition     = module.cdn.domain_name != ""
    error_message = "CloudFront distribution domain is empty"
  }
}

check "s3_bucket_exists" {
  assert {
    condition     = module.s3.bucket_id != ""
    error_message = "S3 bucket was not created"
  }
}
