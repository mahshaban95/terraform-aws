
# The main VPC for the project. 
# We will also create two subnets within this VPC, public and private.

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
      Name = var.vpc_name
      Project = var.project_name
  }
}

# I am just out putting the vpc info to be used later by other modules
output "main_vpc" {
  value = aws_vpc.main_vpc
}

# Create the "internet gatewat" to enable the public subnet to reach the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.igw_name
    Project = var.project_name
  }
}


# The Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = "true"   # This will not be found in the private subnet

  tags = {
    Name = var.public_subnet_name
    Project = var.project_name
  }
}

# I am just out putting the subnet id to be used later by other modules
output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

# Now that we have a public subnet and an internet gateway, we need to connect them together
# This enables the public subnet to reach the internet and be actually public :smiley:
# We do that by creating a route table that points to the igw and associate that to the public subnet

# Creatin the route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_subnet_name
    Project = var.project_name
  }
}

# associate the above route table to the public subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}


# The private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_name
    Project = var.project_name
  }
}

# I am just out putting the subnet id to be used later by other modules
output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

# As we did for the public subnet, we need a route table for the private subnet
# to be able to route trafic to the internet but this time we will not use igw
# Instead we will use the "NAT Gateway" which makes our network design secure.
# The "NAT Gateway" will only allow connections to be initaiated from the private subnet only.

# Creating the NAT gateway will first needs an elastic IP (eip) to enable the traffic from the private subnet to be routed to the internet

# Creating the eip
resource "aws_eip" "nat_gateway_eip" {
  tags = {
    Name = var.eip_name
    Project = var.project_name
  }  
}

# Creating the NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.private_subnet.id

  tags = {
    Name = var.nat_gateway_name
    Project = var.project_name
  }  
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


# Now that we have a private subnet and a NAT gateway, we need a rout table in the private subnet
# to point to the the NAT gateway
# This enables the private subnet to innitiate communication with the internet but the reverse is not true.

# Creatin the route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = var.private_subnet_name
    Project = var.project_name
  }
}

# associate the above route table to the public subnet
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}
