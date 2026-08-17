####################################
# Data Source for VPC
####################################
data "aws_vpc" "vpc_name" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "subnet" {
  filter {
    name   = "tag:Name"
    values = ["us-east-1d"]
  }

  vpc_id = data.aws_vpc.vpc_name.id
}

data "aws_ami" "linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

