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


