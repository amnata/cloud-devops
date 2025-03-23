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

# Configure the Google Cloud provider
provider "google" {
  credentials = file("service-account-key.json")
  project     = local.project_id
  region      = local.region
}

