###################################
#Subnet to Route Table Association#
###################################

resource "aws_route_table_association" "pm4_dmz_rt_association_a" {
  subnet_id      = aws_subnet.pm4_dmz_a.id
  route_table_id = aws_route_table.pm4_dmz_rt.id
}

resource "aws_route_table_association" "pm4_dmz_rt_association_b" {
  subnet_id      = aws_subnet.pm4_dmz_b.id
  route_table_id = aws_route_table.pm4_dmz_rt.id
}

resource "aws_route_table_association" "pm4_alb_rt_association_a" {
  subnet_id      = aws_subnet.pm4_alb_a.id
  route_table_id = aws_route_table.pm4_dmz_rt.id
}

resource "aws_route_table_association" "pm4_alb_rt_association_b" {
  subnet_id      = aws_subnet.pm4_alb_b.id
  route_table_id = aws_route_table.pm4_dmz_rt.id
}

resource "aws_route_table_association" "pm4_frontend_rt_association_a" {
  subnet_id      = aws_subnet.pm4_frontend_a.id
  route_table_id = aws_route_table.pm4_frontend_a.id
}

resource "aws_route_table_association" "pm4_frontend_rt_association_b" {
  subnet_id      = aws_subnet.pm4_frontend_b.id
  route_table_id = aws_route_table.pm4_frontend_b.id
}
#TASKS
resource "aws_route_table_association" "pm4_tasks_rt_association_a" {
  subnet_id      = aws_subnet.pm4_tasks_a.id
  route_table_id = aws_route_table.pm4_frontend_a.id
}

resource "aws_route_table_association" "pm4_tasks_rt_association_b" {
  subnet_id      = aws_subnet.pm4_tasks_b.id
  route_table_id = aws_route_table.pm4_frontend_b.id
}

resource "aws_route_table_association" "pm4_backend_rt_association_a" {
  subnet_id      = aws_subnet.pm4_backend_a.id
  route_table_id = aws_route_table.pm4_backend.id
}

resource "aws_route_table_association" "pm4_backend_rt_association_b" {
  subnet_id      = aws_subnet.pm4_backend_b.id
  route_table_id = aws_route_table.pm4_backend.id
}
