terraform {
  backend "s3" {
   region = "us-east-1"
   key = "statefile02"
   bucket = "terraform-aws-github-actions-max1"
  }
}


provider "aws" {
  region = var.aws_region
}
