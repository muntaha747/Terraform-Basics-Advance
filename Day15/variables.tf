###############################################################################################################################################################################################
# Input Variables for VPCs
###############################################################################################################################################################################################


variable "VPC-A-CIDR" {
  type    = string
  default = "10.0.0.0/16"

  # No "type" set here — Terraform will infer it as string from the default value
}

variable "VPC-B-CIDR" {
  type    = string
  default = "10.1.0.0/16"
  # No "type" set here — Terraform will infer it as string from the default value
}

variable "VPC-C-CIDR" {
  type    = string
  default = "20.0.0.0/16"
  # No "type" set here — Terraform will infer it as string from the default value
}


variable "VPC_A_Region" {
  type    = string
  default = "us-east-1"
}

variable "VPC_B_Region" {
  type    = string
  default = "us-east-2"
}

variable "VPC_C_Region" {
  type    = string
  default = "us-west-1"
}

variable "Subnet-VPC-A-CIDR" {
  type    = string
  default = "10.0.0.0/24"
}

variable "Subnet-VPC-B-CIDR" {
  type    = string
  default = "10.1.0.0/24"
}

variable "Subnet-VPC-C-CIDR" {
  type    = string
  default = "20.0.0.0/24"
}

variable "public_ip_enabled" {
  type    = bool
  default = true
}

variable "Peer-Owner-Account-ID" {
  type    = string
  default = "747482682170"
}

variable "Peering_request" {
  type    = bool
  default = false
}

###############################################################################################################################################################################################
# Tag Maps Variables
###############################################################################################################################################################################################

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "Dev-VPCS-Connectiond"
    created_by  = "Muntaha"
    compliance  = true
    Client      = "TCH"
  }
}

##############################################################################################################################################################
# Dynamic Block SG Variable (it is the object or dictionary data types which contains list of string or any other data types [{key = value}, {key = value}], {key = value}]
##############################################################################################################################################################
variable "ingress_rules" {
  description = "list of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = [{
    from_port   = 80,
    to_port     = 80,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
    description = "http"
    }, {
    from_port   = 443,
    to_port     = 443,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
    description = "https"
    },
    {
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "https"
    },
    {
      from_port   = -1,
      to_port     = -1,
      protocol    = "icmp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "Ping"
    },
    {
      from_port   = 8080,
      to_port     = 8080,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "these are the ingress outbound protocols"
  }]
}

###########################################################################################################################################################################
# Dynamic Block SG Variable (it is the object or dictionary data types which contains list of string or any other data types [{key = value}, {key = value}], {key = value}]
###########################################################################################################################################################################
variable "egress_rules" {
  description = "egress values in the object block in the key value key pair. It is egress(outbound). So, we only need one complete object block"
  type = list(object({
    from_port   = number,
    to_port     = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string
  }))

  default = [{
    from_port   = 443,
    to_port     = 443,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
    description = "these are the egress outbound protocols"
    },
    {
      from_port   = 80,
      to_port     = 80,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "these are the egress outbound protocols"
    },
    {
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "these are the egress outbound protocols"
    },
    {
      from_port   = -1,
      to_port     = -1,
      protocol    = "icmp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "these are the egress outbound protocols"
    },
    {
      from_port   = 8080,
      to_port     = 8080,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "these are the egress outbound protocols"
  }]
}

###########################################################################################################################################################################
# Instance type
###########################################################################################################################################################################
variable "Instance_Type" {
  type    = list(string)
  default = ["t3.medium", "t3.xlarge", "t3.xlarge"]
}