##########################################################
# For the VPCs
##########################################################
provider "aws" {
  region = var.VPC_A_Region
  alias  = "VPC-A"
}
provider "aws" {
  region = var.VPC_B_Region
  alias  = "VPC-B"
}
provider "aws" {
  region = var.VPC_C_Region
  alias  = "VPC-C"
}


##########################################################
# For the key pairs
##########################################################
provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}
provider "aws" {
  region = "us-east-2"
  alias  = "us_east_2"
}
provider "aws" {
  region = "us-west-1"
  alias  = "us_west_1"
}


