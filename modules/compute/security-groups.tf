###################
# Security Groups #
###################

resource "aws_security_group" "pm4_redis_sg" {
  name        = "pm4-${var.pm4_client_name}-redis-sg"
  description = "Allowing connection from Tasks and Web"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    security_groups = [aws_security_group.pm4_tasks_sg.id, aws_security_group.pm4_web_sg.id]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-Redis-SG"
  }
}

resource "aws_security_group" "pm4_dmz_sg" {
  name        = "pm4-${var.pm4_client_name}-dmz-sg"
  description = "Allowing all traffic from Tasks and Web"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    security_groups = [aws_security_group.pm4_tasks_sg.id, aws_security_group.pm4_web_sg.id]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-DMZ-SG"
  }

}

resource "aws_security_group" "pm4_efs_sg" {
  name        = "pm4-${var.pm4_client_name}-efs-sg"
  description = "Allowing NFS port for EFS for Tasks and Web"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = [aws_security_group.pm4_tasks_sg.id, aws_security_group.pm4_web_sg.id]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-EFS-SG"
  }
}

resource "aws_security_group" "pm4_tasks_sg" {
  name        = "pm4-${var.pm4_client_name}-tasks-sg"
  description = "Allowing SSH"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-Tasks-SG"
  }
}

resource "aws_security_group_rule" "dmz-sg-add-tasks" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pm4_dmz_sg.id
  security_group_id        = aws_security_group.pm4_tasks_sg.id
}

resource "aws_security_group" "pm4_web_sg" {
  name        = "pm4-${var.pm4_client_name}-web-sg"
  description = "Allowing SSH for DMZ and HTTP/S ports for ALB as all traffic too"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-Web-SG"
  }

}

resource "aws_security_group_rule" "dmz-sg-add-web" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pm4_dmz_sg.id
  security_group_id        = aws_security_group.pm4_web_sg.id
}

resource "aws_security_group_rule" "dmz-sg-add-alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.pm4_alb_sg.id
  security_group_id        = aws_security_group.pm4_web_sg.id
}

resource "aws_security_group" "pm4_alb_sg" {
  name        = "pm4-${var.pm4_client_name}-alb-sg"
  description = "Allow HTTP/S on ALB"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-ALB-SG"
  }
}

resource "aws_security_group" "pm4_backend_sg" {
  name        = "pm4-${var.pm4_client_name}-backend-sg"
  description = "Allowing MySQL port for Tasks and Web"
  vpc_id      = aws_vpc.pm4_client_vpc.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [aws_security_group.pm4_web_sg.id, aws_security_group.pm4_tasks_sg.id]
  }

  tags = {
    Name = "PM4-${var.pm4_client_name}-BackEnd-SG"
  }
}
