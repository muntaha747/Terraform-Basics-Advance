terraform {
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
