# Tests different environment configurations produce valid plans.

mock_provider "aws" {}

variables {
  project_name = "myapp"
}

run "prod_environment" {
  command = plan

  variables {
    environment = "prod"
  }
}

run "dev_environment" {
  command = plan

  variables {
    environment = "dev"
  }
}

run "staging_environment" {
  command = plan

  variables {
    environment = "staging"
  }
}

run "dev_with_versioning" {
  command = plan

  variables {
    environment       = "dev"
    enable_versioning = true
  }
}

run "custom_cors_origins" {
  command = plan

  variables {
    cors_allowed_origins = ["https://example.com", "https://app.example.com"]
  }
}

run "all_price_classes_valid" {
  command = plan

  variables {
    price_class = "PriceClass_200"
  }
}
