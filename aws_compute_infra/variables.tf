
# The project name, just to be used as a tag for identification.
variable "project_name" {
  default = "prehire_demo"
}

# Public EC2 instances info
variable "public_instance_type" {
    default = "t2.micro"
}

variable "public_instance_name" {
    default = "public_instance"
}

variable "public_instance_iface" {
    default = "public_instance_iface"
}

variable "sg_public_allow_ssh_name" {
    default = "public_allow_ssh"
}

# private EC2 instances info
variable "private_instance_type" {
    default = "t2.micro"
}

variable "private_instance_name" {
    default = "private_instance"
}

variable "private_instance_iface" {
    default = "private_instance_iface"
}



# Just declaring those variables to act as space holder for the info we want from the network module
variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "main_vpc" {}