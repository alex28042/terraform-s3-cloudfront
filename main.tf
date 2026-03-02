terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
}
