
# This file contains the compute resources
# We will create two ec2 instances for public and private subnets.

# Using the data module to get the ec2 instance AMI ID for Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# Creating the ec2 instance that will reside in the pubic subnet

# First we create a network interface for the instance to be attached to, and put it in the public subnet
resource "aws_network_interface" "public_instance_iface" {
  subnet_id   = var.public_subnet_id
  security_groups = [aws_security_group.public_allow_ssh.id]     # the creation of this security group will be explained later

  tags = {
    Name = var.public_instance_iface
    Project = var.project_name
  }
}

# We also need to create an SSH key to be associated with that public instance
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDF6QzPZ5kQ/IByK/6YQTUsKrohJ2DqslyzBIggL9Wpwfly0nuWKgSJ4sbuxssh3vI1BBLB1qrXp8Ihr2tOnSWHLH+fkt70zBo21znJxicMarmij0eANphZnC8u9Y2chFGpZ8YquJVR2euu70B+g84WnKyp5bC94M7sf5Hawf1BdGUlPUtPyhg4UkqhUcVSpRTC0RXHPSL9zZfsnXxk/jz/r+dYPlZFEVFOIO3iNG0FBmAtXXFAritZlQE1EBuCPzrGDtnpnpicwhXoG6G2TSku/n+0uFWuLk9eeMCig4s4BtYrY5NTlx5LUMmZKirnML3xcs1aUq8k74xMIE1JUnv9 vagrant@vagrant"
}

# Then create the instance and attach the interface to it
resource "aws_instance" "public" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.public_instance_type
  key_name   = "deployer-key"

  network_interface {
    network_interface_id = aws_network_interface.public_instance_iface.id
    device_index = 0
  }

  tags = {
    Name = var.public_instance_name
    Project = var.project_name
  }
}

# If we leave things as it is, the ssh keys will be installed successfully on the instance 
# but we will not be able to access it becasue when creating an ec2 instance a security group will be created
# automatically and it will not allow any inboud traffic by default

# So we need to create another security group to allow ssh inbound traffic (port 22)
resource "aws_security_group" "public_allow_ssh" {
  name        = var.sg_public_allow_ssh_name
  description = "Allow SSH inbound traffic"
  vpc_id      = var.main_vpc.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_public_allow_ssh_name
    Project = var.project_name
  }
}

#############

# Creating the ec2 instance that will reside in the private subnet

# First we create a network interface for the instance to be attached to, and put it in the private subnet
resource "aws_network_interface" "private_instance_iface" {
  subnet_id   = var.private_subnet_id
  tags = {
    Name = var.private_instance_iface
    Project = var.project_name
  }
}

# Then create the instance and attach the interface to it
resource "aws_instance" "private" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.private_instance_type

  network_interface {
    network_interface_id = aws_network_interface.private_instance_iface.id
    device_index = 0
  }

  tags = {
    Name = var.private_instance_name
    Project = var.project_name
  }
}