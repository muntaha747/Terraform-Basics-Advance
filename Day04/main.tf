terraform {

  backend "s3" {
    bucket       = "muntaha-terraform-statefile-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" #This is the AWS Provider Version.
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Creating a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = "muntaha.best01"

  tags = {
    Name        = "storage1.0"
    Environment = "Dev"
  }
}

terraform {

}

