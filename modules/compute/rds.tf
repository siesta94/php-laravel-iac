resource "aws_db_subnet_group" "pm4_subnet_group" {
  name       = "pm4_client_subnet_group"
  description = "PM4-Client-RDS-Subnet-Group"
  subnet_ids = [aws_subnet.pm4_backend_a.id, aws_subnet.pm4_backend_b.id]

  tags = {
    Name = "PM4-Client-Subnet-Group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "RDSProdMaster"
  password             = "Wolf159357!"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.pm4_subnet_group.name
  vpc_security_group_ids = [aws_security_group.pm4_backend_sg.id]
  skip_final_snapshot  = true
}
