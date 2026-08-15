###############################################################################################################################################################################################
# storage
###############################################################################################################################################################################################

resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = "var.environment"
  }
}

###############################################################################################################################################################################################
# Networking
###############################################################################################################################################################################################

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  region     = var.region
  tags = {
    Environment = "var.environment"
    Name        = local.vpc-name

  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.subnet_cidr
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-subnet"
  }
}

#######################################################################
#Security Group (Firewalls)
#######################################################################
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


###############################################################################################################################################################################################
# Compute
###############################################################################################################################################################################################

resource "aws_instance" "my-vm" {
  #count                       = var.instance_count
  count         = var.dict_regions.instance_count
  instance_type = var.ec2-types[0] #this is with the list variables
  subnet_id     = aws_subnet.my-subnet.id
  #region                      = tolist(var.allowed_regions)[0] # This is with the set variable which we converted to the list with tolist function.
  region = var.dict_regions.region
  ami    = var.ami-image
  #monitoring                  = var.monitoring-enabled
  monitoring                  = var.dict_regions.monitoring
  associate_public_ip_address = var.associate-public-ip
  tags                        = var.tags
}
