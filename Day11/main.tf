resource "aws_instance" "ec2-instance" {
  ami   = var.ami-image
  count = var.resource_count
  # instance_type = var.ec2-types[0]
  instance_type = var.environment == "dev" ? "t2.micro" : "t2.medium"
  tags          = var.tags
}


########################################################################
# AWS Security Group Dynamic Ingress
########################################################################

resource "aws_security_group" "ingress_rule" {
  name = "ingress-sg"
  #vpc_id = aws_vpc.example.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

########################################################################
# AWS Security Group Dynamic Egress
########################################################################

resource "aws_security_group" "egress_rule" {
  name = "egress-sg"

  dynamic "egress" {
    for_each = var.egress_rule
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}


