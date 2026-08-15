###############################################################################################################################################################################################
# Input Variables
###############################################################################################################################################################################################
variable "environment" {
  default = "dev"
  type    = string
}

variable "buck-name" {
  default = "muntaha.best01"
  type    = string
}


variable "cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "ami-image" {
  default = "ami-0bdc7d025135d7b49"
}

