###################################
# NAT Instances and it's resources#
###################################

resource "aws_network_interface" "pm4_nat_interface_a" {
  subnet_id         = aws_subnet.pm4_dmz_a.id
  source_dest_check = false

  tags = {
    Name = "PM4-NAT-${var.pm4_client_name}-ENI-A"
  }
}

resource "aws_network_interface" "pm4_nat_interface_b" {
  subnet_id         = aws_subnet.pm4_dmz_b.id
  source_dest_check = false
  tags = {
    Name = "PM4-NAT-${var.pm4_client_name}-ENI-B"
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
    Name = "PM4-${var.pm4_client_name}-NAT-Instance-A"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.pm4_dmz_sg.id
  network_interface_id = aws_instance.pm4_nat_instance_a.primary_network_interface_id
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
    Name = "PM4-${var.pm4_client_name}-NAT-Instance-B"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment_b" {
  security_group_id    = aws_security_group.pm4_dmz_sg.id
  network_interface_id = aws_instance.pm4_nat_instance_b.primary_network_interface_id
}

resource "aws_eip" "nat_eip_a" {
  vpc               = true
  network_interface = aws_network_interface.pm4_nat_interface_a.id
}

resource "aws_eip" "nat_eip_b" {
  vpc               = true
  network_interface = aws_network_interface.pm4_nat_interface_b.id
}

##################################################
#Generate and write in file key for NAT instances#
##################################################

#resource "tls_private_key" "nat_key" {
#  algorithm = "RSA"
#}

#resource "aws_key_pair" "pm4_nat_key" {
#  key_name   = "pm4_nat_key"
  #public_key = var.nat_key
#  public_key = tls_private_key.nat_key.public_key_openssh
#
#  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
#    command = "echo '${tls_private_key.nat_key.private_key_pem}' > ./nat_key.pem"
#  }

#  tags = {
#    Name = "PM4-${var.pm4_client_name}-NAT-Key"
#  }
#}
