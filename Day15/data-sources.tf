data "aws_availability_zones" "az-east-1" {
  provider = aws.VPC-A
  state    = "available"
}

data "aws_availability_zones" "az-east-2" {
  provider = aws.VPC-B
  state    = "available"
}

data "aws_availability_zones" "az-west-1" {
  provider = aws.VPC-C
  state    = "available"
}
##########################################################
# AMI ID for Ec2s
##########################################################

data "aws_ami" "ami_VPC_A" {
  provider    = aws.VPC-A
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_VPC_B" {
  provider    = aws.VPC-B
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_VPC_C" {
  provider    = aws.VPC-C
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}