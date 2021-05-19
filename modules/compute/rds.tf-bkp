resource "aws_db_subnet_group" "pm4_subnet_group" {
  name       = "pm4_${var.pm4_client_name}_subnet_group"
  description = "PM4-${var.pm4_client_name}-RDS-Subnet-Group"
  subnet_ids = [aws_subnet.pm4_backend_a.id, aws_subnet.pm4_backend_b.id]

  tags = {
    Name = "PM4-${var.pm4_client_name}-Subnet-Group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  identifier = "pm4-example-db"
  multi_az = "true"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.rds_instance_type
  name                 = "${var.pm4_client_name}"
  username             = "RDSProdMaster"
  password             = "Wolf159357!"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.pm4_subnet_group.name
  vpc_security_group_ids = [aws_security_group.pm4_backend_sg.id]
  skip_final_snapshot  = true
}
