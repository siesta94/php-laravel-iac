terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.69"
    }
    template = {
      source = "hashicorp/template"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

###########################################
#Create VPC, Subnets, Route Tables, IGW...#
###########################################
#VPC with DNS enabled#
######################

resource "aws_vpc" "client_vpc" {
  cidr_block           = "10.0.0.0/21"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Client-VPC"
  }
}

#####################
# Create IGW for VPC#
#####################

resource "aws_internet_gateway" "client_igw" {
  vpc_id = aws_vpc.client_vpc.id

  tags = {
    Name = "Client-IGW"
  }
}

######################
# Get all AZ's in VPC#
######################

data "aws_availability_zones" "client_azs" {
  state = "available"
}

###########################
# Create subnets in 3 AZ's#
###########################

resource "aws_subnet" "public_a" {
  availability_zone = element(data.aws_availability_zones.client_azs.names, 0)
  vpc_id            = aws_vpc.client_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Client-Public-Subnet-A"
  }
}

resource "aws_subnet" "public_b" {
  availability_zone = element(data.aws_availability_zones.client_azs.names, 1)
  vpc_id            = aws_vpc.client_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Client-Public-Subnet-B"
  }
}

resource "aws_subnet" "public_c" {
  availability_zone = element(data.aws_availability_zones.client_azs.names, 2)
  vpc_id            = aws_vpc.client_vpc.id
  cidr_block        = "10.0.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Client-Public-Subnet-C"
  }
}

resource "aws_subnet" "private_a" {
  availability_zone = element(data.aws_availability_zones.client_azs.names, 0)
  vpc_id            = aws_vpc.client_vpc.id
  cidr_block        = "10.0.4.0/24"

  tags = {
    Name = "Client-Private-Subnet-A"
  }
}

resource "aws_subnet" "private_b" {
  availability_zone = element(data.aws_availability_zones.client_azs.names, 1)
  vpc_id            = aws_vpc.client_vpc.id
  cidr_block        = "10.0.5.0/24"

  tags = {
    Name = "Client-Private-Subnet-B"
  }
}

resource "aws_subnet" "private_c" {
  availability_zone = element(data.aws_availability_zones.client_azs.names, 2)
  vpc_id            = aws_vpc.client_vpc.id
  cidr_block        = "10.0.6.0/24"

  tags = {
    Name = "Client-Private-Subnet-C"
  }
}

############################
#NAT GATEWAY               #
############################


resource "aws_nat_gateway" "client_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "Client-NAT-GW"
  }

  depends_on = [aws_internet_gateway.client_igw]
}

resource "aws_eip" "nat_eip" {
  vpc               = true

}


###############################
#Route Tables and associations#
###############################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.client_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.client_igw.id
  }

  tags = {
    Name = "Public-Route-RT"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.client_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.client_nat_gw.id
  }

  tags = {
    Name = "Private-Route-RT"
  }
}

resource "aws_route_table_association" "public_association_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_association_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_association_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_association_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_rt.id
}

######################################
#SSH Keys and Instance to control EKS#
######################################

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "Control Instance"
  public_key = tls_private_key.ssh.public_key_openssh
}

output "ssh_private_key_pem" {
  value = tls_private_key.ssh.private_key_pem
  sensitive = true
}

output "ssh_public_key_pem" {
  value = tls_private_key.ssh.public_key_pem
  sensitive = true
}

resource "aws_security_group" "client_control_instance_sg" {
  name = "Client-Control-Instance-SG"
  description = "Client-Control-Instance-SG"
  vpc_id = aws_vpc.client_vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "Client-Control-Instance-SG"
  }
}

resource "aws_instance" "client_control_instance_sg" {
  instance_type = "t3.micro"
  ami = "ami-08e4e35cccc6189f4"
  subnet_id = aws_subnet.public_a.id
  iam_instance_profile = aws_iam_instance_profile.s3_ec2_role.name
  security_groups = [aws_security_group.client_control_instance_sg.id]
  key_name = aws_key_pair.ssh.key_name

  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" | mv kubectl /usr/bin/
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"  | mv kubectl /usr/bin/
sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl

sudo aws s3 sync s3://k8s-configuration-bucket-1994 /root/

EOF

  tags = {
    "Name" = "Control-Instance"
  }
}

#############################
#S3 uploads K8s config to S3#
#############################

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "k8s-configuration-bucket-1994"
  acl    = "private"

  tags = {
    Name        = "k8s-configuration-bucket-1994"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_object" "stm_objects" {
  for_each = fileset("config/", "*")
  bucket = "k8s-configuration-bucket-1994"
  key = each.value
  source = "config/${each.value}"
  etag = filemd5("config/${each.value}")
  
  depends_on = [aws_s3_bucket.s3_bucket]
}

#########################################
#Roles and policies for Control Instance#
#########################################

resource "aws_iam_role" "s3_role" {
  name = "s3_role"
  assume_role_policy = file("./policies/s3-upload-role.json")
  tags = {
    Name = "s3-role-control-instance"
  }
}

resource "aws_iam_role_policy" "orchestrator_s3_policy" {
  name   = "s3_policy"
  role   = aws_iam_role.s3_role.id
  policy = file("./policies/s3-upload-policy.json")
}

resource "aws_iam_instance_profile" "s3_ec2_role" {
  name = "s3_role_profile"
  role = aws_iam_role.s3_role.name
}































