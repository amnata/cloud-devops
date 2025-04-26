# Configure Terraform providers
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.80.0"
    }
  }
  required_version = ">= 1.0.0"
}