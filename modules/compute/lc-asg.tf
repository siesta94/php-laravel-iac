#---launch configuration---

resource "aws_launch_configuration" "ecs_lc" {
  name            = "PM4-Client-ECS-Web"
  image_id        = var.ecs_instance_ami
  instance_type   = var.ecs_instance_type
  security_groups = [aws_security_group.pm4_web_sg.id]
  key_name        = aws_key_pair.pm4_nat_key.id
  #user_data       = file("userdata")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "PM4-Client-ECS-WEB-ASG"
  launch_configuration = aws_launch_configuration.ecs_lc.name
  desired_capacity     = 2
  min_size             = 2
  max_size             = 4

  vpc_zone_identifier = [aws_subnet.pm4_web_a.id, aws_subnet.pm4_web_b.id]

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#########
#WORKERS# 
#########

resource "aws_launch_configuration" "workers_lc" {
  name            = "PM4-Client-Workers"
  image_id        = var.tasks_instance_ami
  instance_type   = var.tasks_instance_type
  security_groups = [aws_security_group.pm4_tasks_sg.id]
  key_name        = aws_key_pair.pm4_nat_key.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "workers_asg" {
  name                 = "PM4-Client-Workers"
  launch_configuration = aws_launch_configuration.workers_lc.name
  desired_capacity     = 2
  min_size             = 2
  max_size             = 4

  vpc_zone_identifier = [aws_subnet.pm4_tasks_a.id, aws_subnet.pm4_tasks_b.id]

  lifecycle {
    create_before_destroy = true
  }
}
