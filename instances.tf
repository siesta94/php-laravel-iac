######################
# NAT Instances      #
######################

resource "aws_network_interface" "pm4_nat_interface_a" {
  subnet_id         = aws_subnet.pm4_dmz_a.id
  source_dest_check = false

  tags = {
    Name = "PM4-NAT-Network-Interface-A"
  }
}

resource "aws_network_interface" "pm4_nat_interface_b" {
  subnet_id         = aws_subnet.pm4_dmz_b.id
  source_dest_check = false
  tags = {
    Name = "PM4-NAT-Network-Interface-B"
  }
}


resource "aws_instance" "pm4_nat_instance_a" {
  ami           = var.nat_ami
  instance_type = var.nat_instance_type
  key_name      = aws_key_pair.pm4_nat_key.id
  network_interface {
    network_interface_id = aws_network_interface.pm4_nat_interface_a.id
    device_index         = 0
  }

  tags = {
    Name = "PM4-NAT-Instance-A"
  }
}

resource "aws_instance" "pm4_nat_instance_b" {
  ami           = var.nat_ami
  instance_type = var.nat_instance_type
  key_name      = "pm4_nat_key"
  network_interface {
    network_interface_id = aws_network_interface.pm4_nat_interface_b.id
    device_index         = 0
  }

  tags = {
    Name = "PM4-NAT-Instance-B"
  }
}

resource "aws_eip" "nat_eip_a" {
  vpc               = true
  network_interface = aws_network_interface.pm4_nat_interface_a.id
}

resource "aws_eip" "nat_eip_b" {
  vpc               = true
  network_interface = aws_network_interface.pm4_nat_interface_b.id
}

resource "aws_key_pair" "pm4_nat_key" {
  key_name   = "pm4_nat_key"
  public_key = var.nat_key

  tags = {
    Name = "PM4-Client-NAT-Key"
  }
}


# Testing Subnets #
#
#resource "aws_network_interface" "pm4_test_interface" {
#  subnet_id         = aws_subnet.pm4_frontend_a.id
#  tags = {
#    Name = "PM4-Test-Network-Interface"
#  }
#}


#resource "aws_instance" "pm4_test_instance" {
#  ami           = var.nat_ami
#  instance_type = var.nat_instance_type
#  key_name      = aws_key_pair.pm4_nat_key.id
#  network_interface {
#    network_interface_id = aws_network_interface.pm4_test_interface.id
#    device_index         = 0
#  }

#  tags = {
#    Name = "PM4-Test-Instance-A"
#  }
#}










