terraform {
  required_version = "1.1.7"
 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }

  backend "s3" {
    bucket  = "wc-python-tf-backend"
    key     = "states/ecr_registry"
    region  = "us-east-1"
    dynamodb_table =  "wc-python-tf-state-lock"
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}