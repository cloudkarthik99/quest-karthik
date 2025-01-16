terraform {
  backend "gcs" {
    bucket = "gcp-terraform-state-bucket-backend"
    prefix = "terraform/state"
  }
}