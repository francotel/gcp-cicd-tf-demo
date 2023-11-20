###############################################################################
# Terraform specific configuration
###############################################################################
terraform {
  required_version = ">=0.12.29, <=1.7.2"
  required_providers {
    google = "~> 5.1.0"
  }
  backend "gcs" {
    bucket = "tf-state-orion-demo"
    prefix = "ts-demo-terraform/state"
  }
}

###############################################################################
# Providers
###############################################################################
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name          = "tf-state-orion-demo"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}