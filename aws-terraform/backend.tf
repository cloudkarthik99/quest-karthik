terraform {
  backend "s3" {
    profile = "karthik"
    bucket = "terraform-state-buckets-k8s-and-tools"
    key = "terraform/quest.tfstate"
    region = "us-east-1"
  }
}