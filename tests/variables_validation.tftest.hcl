# Tests that variable validations reject invalid inputs.

mock_provider "aws" {}

variables {
  project_name = "testapp"
}

run "invalid_environment_rejected" {
  command = plan

  variables {
    environment = "qa"
  }

  expect_failures = [
    var.environment,
  ]
}

run "invalid_price_class_rejected" {
  command = plan

  variables {
    price_class = "PriceClass_999"
  }

  expect_failures = [
    var.price_class,
  ]
}
