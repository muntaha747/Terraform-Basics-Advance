#######################################################################################
# VPCS
#######################################################################################

resource "aws_vpc" "VPC-A" {
  cidr_block           = var.VPC-A-CIDR
  provider             = aws.VPC-A
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  region               = var.VPC_A_Region
  tags                 = var.tags
}

resource "aws_vpc" "VPC-B" {
  cidr_block           = var.VPC-B-CIDR
  provider             = aws.VPC-B
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  region               = var.VPC_B_Region
  tags                 = var.tags
}

resource "aws_vpc" "VPC-C" {
  cidr_block           = var.VPC-C-CIDR
  provider             = aws.VPC-C
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  region               = var.VPC_C_Region
  tags                 = var.tags
}

#######################################################################################
# Subnetting
#######################################################################################

resource "aws_subnet" "subnet-VPC-A" {
  provider                = aws.VPC-A
  vpc_id                  = aws_vpc.VPC-A.id
  cidr_block              = var.Subnet-VPC-A-CIDR
  map_public_ip_on_launch = var.public_ip_enabled
  availability_zone       = data.aws_availability_zones.az-east-1.names[0]
  tags                    = var.tags
}

resource "aws_subnet" "subnet-VPC-B" {
  provider                = aws.VPC-B
  vpc_id                  = aws_vpc.VPC-B.id
  cidr_block              = var.Subnet-VPC-B-CIDR
  map_public_ip_on_launch = var.public_ip_enabled
  availability_zone       = data.aws_availability_zones.az-east-2.names[0]
  tags                    = var.tags
}

resource "aws_subnet" "subnet-VPC-C" {
  provider                = aws.VPC-C
  vpc_id                  = aws_vpc.VPC-C.id
  cidr_block              = var.Subnet-VPC-C-CIDR
  map_public_ip_on_launch = var.public_ip_enabled
  availability_zone       = data.aws_availability_zones.az-west-1.names[0]
  tags                    = var.tags
}
#######################################################################################
# internet gateways for all three vpcs [A, B & C]
#######################################################################################
resource "aws_internet_gateway" "VPC-A-IGW" {
  provider   = aws.VPC-A
  vpc_id     = aws_vpc.VPC-A.id
  tags       = var.tags
  depends_on = [aws_vpc.VPC-A]
}

resource "aws_internet_gateway" "VPC-B-IGW" {
  provider   = aws.VPC-B
  vpc_id     = aws_vpc.VPC-B.id
  tags       = var.tags
  depends_on = [aws_vpc.VPC-B]
}

resource "aws_internet_gateway" "VPC-C-IGW" {
  provider   = aws.VPC-C
  vpc_id     = aws_vpc.VPC-C.id
  tags       = var.tags
  depends_on = [aws_vpc.VPC-C]
}
#######################################################################################
# Public Route Table
#######################################################################################

resource "aws_route_table" "RT-VPC-A" {
  provider = aws.VPC-A
  vpc_id   = aws_vpc.VPC-A.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC-A-IGW.id
  }
}

resource "aws_route_table" "RT-VPC-B" {
  provider = aws.VPC-B
  vpc_id   = aws_vpc.VPC-B.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC-B-IGW.id
  }
}

resource "aws_route_table" "RT-VPC-C" {
  provider = aws.VPC-C
  vpc_id   = aws_vpc.VPC-C.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC-C-IGW.id
  }
}

#######################################################################################
# Public Route Table Subnet association
#######################################################################################

resource "aws_route_table_association" "RTA-VPC-A" {
  provider       = aws.VPC-A
  subnet_id      = aws_subnet.subnet-VPC-A.id
  route_table_id = aws_route_table.RT-VPC-A.id
}

resource "aws_route_table_association" "RTA-VPC-B" {
  provider       = aws.VPC-B
  subnet_id      = aws_subnet.subnet-VPC-B.id
  route_table_id = aws_route_table.RT-VPC-B.id
}

resource "aws_route_table_association" "RTA-VPC-C" {
  provider       = aws.VPC-C
  subnet_id      = aws_subnet.subnet-VPC-C.id
  route_table_id = aws_route_table.RT-VPC-C.id
}

#######################################################################################
# VPC Peering Connection - Requesters (3 total, one per pair)
#######################################################################################
resource "aws_vpc_peering_connection" "VPC-A_to_VPC-B" {
  provider      = aws.VPC-A
  peer_owner_id = var.Peer-Owner-Account-ID
  peer_vpc_id   = aws_vpc.VPC-B.id
  vpc_id        = aws_vpc.VPC-A.id
  peer_region   = var.VPC_B_Region
  auto_accept   = false
  tags          = var.tags
}

resource "aws_vpc_peering_connection" "VPC-A_to_VPC-C" {
  provider      = aws.VPC-A
  peer_owner_id = var.Peer-Owner-Account-ID
  peer_vpc_id   = aws_vpc.VPC-C.id
  vpc_id        = aws_vpc.VPC-A.id
  peer_region   = var.VPC_C_Region
  auto_accept   = false
  tags          = var.tags
}

resource "aws_vpc_peering_connection" "VPC-B_to_VPC-C" {
  provider      = aws.VPC-B
  peer_owner_id = var.Peer-Owner-Account-ID
  peer_vpc_id   = aws_vpc.VPC-C.id
  vpc_id        = aws_vpc.VPC-B.id
  peer_region   = var.VPC_C_Region
  auto_accept   = false
  tags          = var.tags
}

#######################################################################################
# VPC Peering Connection - Accepters (3 total, one per requester)
#######################################################################################
resource "aws_vpc_peering_connection_accepter" "VPC-B_Accepts_VPC-A" {
  provider                  = aws.VPC-B
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-A_to_VPC-B.id
  auto_accept               = true
  tags                      = var.tags
}

resource "aws_vpc_peering_connection_accepter" "VPC-C_Accepts_VPC-A" {
  provider                  = aws.VPC-C
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-A_to_VPC-C.id
  auto_accept               = true
  tags                      = var.tags
}

resource "aws_vpc_peering_connection_accepter" "VPC-C_Accepts_VPC-B" {
  provider                  = aws.VPC-C
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-B_to_VPC-C.id
  auto_accept               = true
  tags                      = var.tags
}

#######################################################################################
# VPC Peerings Route.
#######################################################################################
resource "aws_route" "VPC-A_to_VPC-B" {
  provider                  = aws.VPC-A
  route_table_id            = aws_route_table.RT-VPC-A.id
  destination_cidr_block    = var.VPC-B-CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-A_to_VPC-B.id
}

resource "aws_route" "VPC-A_to_VPC-C" {
  provider                  = aws.VPC-A
  route_table_id            = aws_route_table.RT-VPC-A.id
  destination_cidr_block    = var.VPC-C-CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-A_to_VPC-C.id
}

resource "aws_route" "VPC-B_to_VPC-C" {
  provider                  = aws.VPC-B
  route_table_id            = aws_route_table.RT-VPC-B.id
  destination_cidr_block    = var.VPC-C-CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-B_to_VPC-C.id
}

resource "aws_route" "VPC-B_to_VPC-A" {
  provider                  = aws.VPC-B
  route_table_id            = aws_route_table.RT-VPC-B.id
  destination_cidr_block    = var.VPC-A-CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-A_to_VPC-B.id
}

resource "aws_route" "VPC-C_to_VPC-A" {
  provider                  = aws.VPC-C
  route_table_id            = aws_route_table.RT-VPC-C.id
  destination_cidr_block    = var.VPC-A-CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-A_to_VPC-C.id
}

resource "aws_route" "VPC-C_to_VPC-B" {
  provider                  = aws.VPC-C
  route_table_id            = aws_route_table.RT-VPC-C.id
  destination_cidr_block    = var.VPC-B-CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC-B_to_VPC-C.id
}