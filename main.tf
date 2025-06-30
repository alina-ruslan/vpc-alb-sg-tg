# vpc code 
resource "aws_vpc" "vpc1" {
  cidr_block           = "172.120.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "utc-app"
    env  = "dev"
    Team = "devops"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "utc-app-igw"
    env  = "dev"
    Team = "devops"
  }
}

# Subnet Public 
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block              = "172.120.1.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-useeast1b"
  }

}
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block              = "172.120.2.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "public-useeast1b"
  }
}
# Subnet Private
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  availability_zone = "us-east-1a"
  cidr_block        = "172.120.3.0/24"
  tags = {
    Name = "private-useeast1a"
  }

}
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc1.id
  availability_zone = "us-east-1b"
  cidr_block        = "172.120.4.0/24"
  tags = {
    Name = "private-useeast1b"
  }

}
#nat Gateway
resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "natgtw1" {
  subnet_id     = aws_subnet.public_subnet1.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "utc-app-nat-gateway"
    env  = "dev"
    Team = "devops"
  }
}

# Private Route Table

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgtw1.id
  }
}

#public Route Table
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id

  }
}

# Private Route Table Association
resource "aws_route_table_association" "private_rta1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.rt1.id

}
resource "aws_route_table_association" "private_rta2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.rt1.id

}
# Public Route Table Association
resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt2.id

}
resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt2.id

}

