###############################################################################################################################################################################################
# Input Variables
###############################################################################################################################################################################################
variable "environment" {
  type    = string
  default = "dev"

}

variable "bucket_name" {
  type    = string
  default = "storage-cloudfront-bucket"

}

variable "monitoring-enabled" {
  type    = bool
  default = true
}

variable "associate-public-ip" {
  type    = bool
  default = true
}


variable "vpc_cidr" {
  default = "10.0.0.0/16"
  # No "type" set here — Terraform will infer it as string from the default value
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"

}

variable "region" {
  type    = string
  default = "us-east-1"

}

variable "ami-image" {
  default = "ami-0bdc7d025135d7b49"
  # No "type" set here either — inferred as string
}

# variable "resource_count" {
#   description = "Number of Instances to be created"
#   type        = number
#   # No default value — this variable MUST be supplied externally (e.g. via terraform.tfvars or -var flag)
# } # We have mentioned the default value in the terraform.tfvars



###############################################################################################################################################################################################
# List type Variables
###############################################################################################################################################################################################

variable "cidr_block" {
  description = "CIDR Multiple blocks for the Ec2 Machine"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"] #This data type is the list --> ["string"]
  # Ordered list — access by index e.g. var.cidr_block[0], duplicates allowed
}


variable "ec2-types" {
  description = "Types of Ec2s"
  type        = list(string)
  default     = ["t2.micro", "t2.medium", "t2.large"]
  # Ordered list — access by index e.g. var.ec2-types[0]
}

variable "multiple_buckets" {
  description = "list of buckets"
  type        = list(string)
  default     = ["my-unique-bucket-day0-8-abc", "my-unique-bucket-day0-8-def"]
}

###############################################################################################################################################################################################
# Set type Variables
###############################################################################################################################################################################################
variable "bucket_name_set" {
  description = "list of buckets"
  type        = set(string)
  default     = ["my-unique-bucket-day0-8-abc1234", "my-unique-bucket-day0-8-def5678"]
}


variable "allowed_regions" {
  description = "Set of Regions"
  type        = set(string)
  default     = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
  #this is for the differrent regions
  # Set = unordered, unique values only. Cannot index directly (var.allowed_regions[0] will error)
  # Must convert first: tolist(var.allowed_regions)[0]
}

variable "availability_zones" {
  description = "These are the list of AZ's"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}




###############################################################################################################################################################################################
# Tag Maps Variables
###############################################################################################################################################################################################

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-Instance"
    created_by  = "terraform"
    compliance  = true
  }
  # Map = key-value pairs — access by key e.g. var.tags["Name"]
}

###############################################################################################################################################################################################
# Tupple type Variables
###############################################################################################################################################################################################

variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
  # Tuple = fixed-length, fixed order, each position has its own declared type (number, string, number here)
  # Access by index e.g. var.ingress_values[0] -> 443, var.ingress_values[1] -> "tcp"
}

###############################################################################################################################################################################################
# Dictionary or Object type Variable
###############################################################################################################################################################################################

variable "dict_regions" {
  # NOTE: this variable has no name between the quotes — Terraform requires a name here, this will cause an error
  type = object({
    region         = string,
    monitoring     = bool,
    instance_count = number
  })
  default = {
    region         = "us-east-1",
    monitoring     = true,
    instance_count = 1
  }
  # Object = like a struct, fixed set of named attributes each with its own type
  # Access by attribute name e.g. var.<name>.region
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
  }]
}

###########################################################################################################################################################################
# Dynamic Block SG Variable (it is the object or dictionary data types which contains list of string or any other data types [{key = value}, {key = value}], {key = value}]
###########################################################################################################################################################################
variable "egress_rule" {
  description = "egress values in the object block in the key value key pair. It is egress(outbound). So, we only need one complete object block"
  type = list(object({
    from_port   = number,
    to_port     = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string
  }))

  default = [{
    from_port   = 0,
    to_port     = 0,
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"],
    description = "these are the egress outbound protocols"
  }]
}


