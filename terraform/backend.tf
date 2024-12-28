# terraform/backend.tf
terraform {
  backend "s3" {
    bucket = "fanout-terraform-state"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}