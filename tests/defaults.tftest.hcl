# Tests that the root module plans successfully with default values.

mock_provider "aws" {
  override_resource {
    target = module.s3.aws_s3_bucket.this
    values = {
      id                          = "testapp-prod-assets"
      arn                         = "arn:aws:s3:::testapp-prod-assets"
      bucket_regional_domain_name = "testapp-prod-assets.s3.eu-west-1.amazonaws.com"
    }
  }

  override_resource {
    target = module.iam.aws_iam_policy.this
    values = {
      arn = "arn:aws:iam::123456789012:policy/testapp-prod-backend-s3"
    }
  }

  override_resource {
    target = module.cdn.aws_cloudfront_distribution.this
    values = {
      id          = "E1234567890"
      arn         = "arn:aws:cloudfront::123456789012:distribution/E1234567890"
      domain_name = "d111111abcdef8.cloudfront.net"
    }
  }
}

variables {
  project_name = "testapp"
}

run "plan_with_defaults" {
  command = plan

  assert {
    condition     = output.s3_bucket_name == "testapp-prod-assets"
    error_message = "S3 bucket name should follow {project}-{env}-assets pattern"
  }

  assert {
    condition     = output.cdn_url == "https://d111111abcdef8.cloudfront.net"
    error_message = "CDN URL should use CloudFront domain"
  }

  assert {
    condition     = can(regex("^arn:aws:iam:", output.backend_policy_arn))
    error_message = "IAM policy ARN must be a valid ARN"
  }

  assert {
    condition     = output.backend_access_key_id == null
    error_message = "Access key should be null when create_iam_user is false"
  }
}
