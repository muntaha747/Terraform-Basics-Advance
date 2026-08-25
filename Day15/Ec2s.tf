#######################################################################################
# Key Pairs for Ec2 Instances
#######################################################################################
resource "aws_key_pair" "us-east-1-key-pair" {
  provider   = aws.us_east_1
  key_name   = "my-key-pair"
  public_key = file("${path.module}/my-key-pair.pub")
}

resource "aws_key_pair" "us-east-2-key-pair" {
  provider   = aws.us_east_2
  key_name   = "my-key-pair"
  public_key = file("${path.module}/my-key-pair.pub")
}

resource "aws_key_pair" "us-west-1-key-pair" {
  provider   = aws.us_west_1
  key_name   = "my-key-pair"
  public_key = file("${path.module}/my-key-pair.pub")
}

#######################################################################################
# Ec2 Instances
#######################################################################################
resource "aws_instance" "ec2-instance-VPC-A" {
  provider               = aws.VPC-A
  ami                    = data.aws_ami.ami_VPC_A.id
  subnet_id              = aws_subnet.subnet-VPC-A.id
  instance_type          = var.Instance_Type[0]
  key_name               = aws_key_pair.us-east-1-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.EC2-VPC-A_Ingress.id, aws_security_group.EC2-VPC-A_Egress.id]
  tags                   = var.tags
}

resource "aws_instance" "ec2-instance-VPC-B" {
  provider               = aws.VPC-B
  ami                    = data.aws_ami.ami_VPC_B.id
  subnet_id              = aws_subnet.subnet-VPC-B.id
  instance_type          = var.Instance_Type[1]
  key_name               = aws_key_pair.us-east-2-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.EC2-VPC-B_Ingress.id, aws_security_group.EC2-VPC-B_Egress.id]
  tags                   = var.tags
}

resource "aws_instance" "ec2-instance-VPC-C" {
  provider               = aws.VPC-C
  ami                    = data.aws_ami.ami_VPC_C.id
  subnet_id              = aws_subnet.subnet-VPC-C.id
  instance_type          = var.Instance_Type[2]
  key_name               = aws_key_pair.us-west-1-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.EC2-VPC-C_Ingress.id, aws_security_group.EC2-VPC-C_Egress.id]
  tags                   = var.tags
}

#######################################################################################
# Security Groups - VPC-A
#######################################################################################

resource "aws_security_group" "EC2-VPC-A_Ingress" {
  provider = aws.VPC-A
  vpc_id   = aws_vpc.VPC-A.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = var.tags
}

resource "aws_security_group" "EC2-VPC-A_Egress" {
  provider = aws.VPC-A
  vpc_id   = aws_vpc.VPC-A.id

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}

#######################################################################################
# Security Groups - VPC-B
#######################################################################################

resource "aws_security_group" "EC2-VPC-B_Ingress" {
  provider = aws.VPC-B
  vpc_id   = aws_vpc.VPC-B.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = var.tags
}

resource "aws_security_group" "EC2-VPC-B_Egress" {
  provider = aws.VPC-B
  vpc_id   = aws_vpc.VPC-B.id

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}

#######################################################################################
# Security Groups - VPC-C
#######################################################################################

resource "aws_security_group" "EC2-VPC-C_Ingress" {
  provider = aws.VPC-C
  vpc_id   = aws_vpc.VPC-C.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = var.tags
}

resource "aws_security_group" "EC2-VPC-C_Egress" {
  provider = aws.VPC-C
  vpc_id   = aws_vpc.VPC-C.id

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = var.tags
}