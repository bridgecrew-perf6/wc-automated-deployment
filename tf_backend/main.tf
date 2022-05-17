# This uses Terraform to configure the resources required for remote state
variable "aws_access_key"   {}
variable "aws_secret_key"   {}
variable "region"           { default = "us-east-1"     }

terraform {
  required_version = "1.1.7"
 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# when removing, remove this manually by login to aws console
resource "aws_s3_bucket" "state" {
  bucket = "wc-python-tf-backend"
  
  tags = {
    Name = "wc-python-tf-backend"
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# when removing, remove this manually by login to aws console
resource "aws_dynamodb_table" "state" {
  name           = "wc-python-tf-state-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "wc-python-tf-state-lock"
  }

}

resource "null_resource" "sleep" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
}