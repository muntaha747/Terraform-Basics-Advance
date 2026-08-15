###############################################################################################################################################################################################
# storage
###############################################################################################################################################################################################

resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name
  # "local.bucket_name" means this value comes from a "locals" block elsewhere in the project, not a variable

  tags = {
    Name        = local.bucket_name
    Environment = "var.environment"
    # BUG: this is wrapped in quotes, so Terraform treats it as the literal text "var.environment"
    # instead of actually reading your environment variable. Should be: Environment = var.environment
  }
}

###############################################################################################################################################################################################
# Networking
###############################################################################################################################################################################################

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  region     = var.region
  # NOTE: aws_vpc does not normally have a "region" argument — region is usually set at the provider level, not per-resource. Double check this is valid/needed.
  tags = {
    Environment = "var.environment"
    # BUG: same issue as above — this is a literal string, not a variable reference. Should be var.environment

    Name = local.vpc-name
    # Comes from a locals block, not the "environment" variable

  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  # References the VPC resource above by its internal Terraform id, not a variable — this creates the dependency link between subnet and VPC
  cidr_block = var.subnet_cidr
  tags = {
    Environment = var.environment
    # Correct here — no quotes, so this actually pulls the real variable value
    Name = "${var.environment}-subnet"
    # String interpolation — inserts the value of var.environment into the name, e.g. "dev-subnet"
  }
}

#######################################################################
#Security Group (Firewalls)
#######################################################################
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id
  # Attaches this security group to the VPC created above

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  # Links this rule to the security group above
  cidr_ipv4 = var.cidr_block[0]
  # Pulls the FIRST item from your cidr_block list variable -> "10.0.0.0/8"
  from_port = var.ingress_values[0]
  # First item of the tuple -> 443
  ip_protocol = var.ingress_values[1]
  # Second item of the tuple -> "tcp"
  to_port = var.ingress_values[2]
  # Third item of the tuple -> 443
  # This whole rule reads as: allow inbound TCP traffic on port 443 from 10.0.0.0/8
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  # Hardcoded, not a variable — 0.0.0.0/0 means "anywhere" (all IPv4 addresses)
  ip_protocol = "-1" # semantically equivalent to all ports
  # "-1" is AWS's special value meaning ALL protocols and ALL ports — this allows unrestricted outbound traffic
}


###############################################################################################################################################################################################
# Compute
###############################################################################################################################################################################################

resource "aws_instance" "my-vm" {
  #count                       = var.instance_count
  # Commented out — this was the original plan (using the standalone instance_count variable) but it's not being used right now

  count = var.dict_regions.instance_count
  # Instead, count is being pulled from inside the OBJECT variable (var.dict_regions), specifically its "instance_count" attribute
  # NOTE: your object variable in the vars file was unnamed (variable "") — for this line to work, that variable must actually be named "dict_regions"

  instance_type = var.ec2-types[0] #this is with the list variables
  # Takes the first item from the ec2-types list -> "t2.micro"

  subnet_id = aws_subnet.my-subnet.id
  # Links this instance to the subnet resource created above

  #region                      = tolist(var.allowed_regions)[0] # This is with the set variable which we converted to the list with tolist function.
  # Commented out — this was the alternative approach using the SET variable (allowed_regions), converted to a list so it could be indexed

  region = var.dict_regions.region
  # Instead, region comes from the object variable's "region" attribute

  ami = var.ami-image
  # Straightforward reference to the ami-image variable

  #monitoring                  = var.monitoring-enabled
  # Commented out — original plan was to use the standalone monitoring-enabled bool variable

  monitoring = var.dict_regions.monitoring
  # Instead, pulled from the object variable's "monitoring" attribute

  associate_public_ip_address = var.associate-public-ip
  # This one IS using the standalone variable (not from the object) — worth noting the inconsistency: some fields use var.dict_regions.x, this one uses a separate variable directly

  tags = var.tags
  # Applies the whole tags map variable directly as this instance's tags (Environment, Name, created_by)
}