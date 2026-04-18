terraform {
  # Ensures you are using a modern version of Terraform
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  # These variables are defined in your variables.tf file
  project = var.gcp_project_id
  region  = var.gcp_region
}