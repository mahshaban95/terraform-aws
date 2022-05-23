
# The project name, just to be used as a tag for identification.
variable "project_name" {
  default = "prehire_demo"
}


# The main VPC info
variable "vpc_name" {
    default = "main_vpc"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "igw_name" {
    default = "internet_gateway"
}

# The public subnet info
variable "public_subnet_name" {
    default = "public_subnet"
}

variable "public_subnet_cidr" {
    default = "10.0.1.0/24"
}


# The private subnet info
variable "private_subnet_name" {
    default = "private_subnet"
}

variable "private_subnet_cidr" {
    default = "10.0.2.0/24"
}

variable "eip_name" {
    default = "nat_gateway_eip"
}

variable "nat_gateway_name" {
    default = "nat_gateway"
}
