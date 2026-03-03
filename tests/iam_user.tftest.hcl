# Tests IAM user creation toggle.

mock_provider "aws" {
  override_resource {
    target = module.iam.aws_iam_policy.this
    values = {
      arn = "arn:aws:iam::123456789012:policy/testapp-prod-backend-s3"
    }
  }
}

variables {
  project_name = "testapp"
}

run "iam_user_disabled_by_default" {
  command = plan

  assert {
    condition     = output.backend_access_key_id == null
    error_message = "Access key should be null when IAM user is not created"
  }
}

run "iam_user_created_when_enabled" {
  command = plan

  variables {
    create_iam_user = true
  }

  assert {
    condition     = output.backend_access_key_id != null
    error_message = "Access key should be set when IAM user is created"
  }
}
