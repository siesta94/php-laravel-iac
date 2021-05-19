##############################
# Create VPC with DNS Enabled#
##############################

resource "aws_vpc" "pm4_client_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "PM4-${var.pm4_client_name}-VPC"
  }
}

#####################
# Create IGW for VPC#
#####################

resource "aws_internet_gateway" "pm4_client_igw" {
  vpc_id = aws_vpc.pm4_client_vpc.id

  tags = {
    Name = "PM4-${var.pm4_client_name}-IGW"
  }
}

######################
# Get all AZ's in VPC#
######################

data "aws_availability_zones" "pm4_client_azs" {
  state = "available"
}

###########################
# Create subnets in 2 AZ's#
###########################

resource "aws_subnet" "pm4_dmz_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_dmz_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-DMZ-Subnet-A"
  }
}

resource "aws_subnet" "pm4_dmz_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_dmz_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-DMZ-Subnet-B"
  }
}

resource "aws_subnet" "pm4_efs_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_efs_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-EFS-Subnet-A"
  }
}

resource "aws_subnet" "pm4_efs_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_efs_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-EFS-Subnet-B"
  }
}

resource "aws_subnet" "pm4_redis_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_redis_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Redis-Subnet-A"
  }
}

resource "aws_subnet" "pm4_redis_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_redis_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Redis-Subnet-B"
  }
}

resource "aws_subnet" "pm4_tasks_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_tasks_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Tasks-Subnet-A"
  }
}

resource "aws_subnet" "pm4_tasks_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_tasks_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Tasks-Subnet-B"
  }
}

resource "aws_subnet" "pm4_web_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_web_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Web-Subnet-A"
  }
}

resource "aws_subnet" "pm4_web_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_web_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Web-Subnet-B"
  }
}

resource "aws_subnet" "pm4_alb_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_alb_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-ALB-Subnet-A"
  }
}

resource "aws_subnet" "pm4_alb_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_alb_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-ALB-Subnet-B"
  }
}

resource "aws_subnet" "pm4_backend_a" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 0)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_backend_a"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-BackEnd-Subnet-A"
  }
}

resource "aws_subnet" "pm4_backend_b" {
  availability_zone = element(data.aws_availability_zones.pm4_client_azs.names, 1)
  vpc_id            = aws_vpc.pm4_client_vpc.id
  cidr_block        = var.cidrs["pm4_backend_b"]

  tags = {
    Name = "PM4-${var.pm4_client_name}-BackEnd-Subnet-B"
  }
}

#######################
# Create Route Tables #
#######################

resource "aws_route_table" "pm4_dmz_rt" {
  vpc_id = aws_vpc.pm4_client_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pm4_client_igw.id
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-DMZ-Route-RT"
  }
}

resource "aws_route_table" "pm4_web_a" {
  vpc_id = aws_vpc.pm4_client_vpc.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.pm4_nat_interface_a.id
  }
  tags = {
    Name = "PM4-${var.pm4_client_name}-NAT-Route-A"
  }
}

resource "aws_route_table" "pm4_web_b" {
  vpc_id = aws_vpc.pm4_client_vpc.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.pm4_nat_interface_b.id
  }
  tags = {
    Name = "PM4-${var.pm4_client_name}-NAT-Route-B"
  }
}

resource "aws_route_table" "pm4_backend" {
  vpc_id = aws_vpc.pm4_client_vpc.id
  tags = {
    Name = "PM4-${var.pm4_client_name}-BackEnd-Route"
  }
}
