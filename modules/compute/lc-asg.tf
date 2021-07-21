###################################
#ECS Launch Configurations and ASG#
###################################
resource "aws_launch_configuration" "ecs_lc" {
  name                 = "PM4-${var.pm4_client_name}-ECS-Web"
  image_id             = var.ecs_instance_ami
  instance_type        = var.ecs_instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2_role.name
  security_groups      = [aws_security_group.pm4_web_sg.id]
  key_name             = aws_key_pair.pm4_nat_key.id

  user_data = <<EOF

#!/bin/bash
mkdir /mnt/efs
echo ECS_CLUSTER=PM4-${var.pm4_client_name}-ECS >> /etc/ecs/ecs.config
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "PM4-${var.pm4_client_name}-ECS-WEB-ASG"
  launch_configuration = aws_launch_configuration.ecs_lc.name
  desired_capacity     = 2
  min_size             = 2
  max_size             = 4

  vpc_zone_identifier = [aws_subnet.pm4_web_a.id, aws_subnet.pm4_web_b.id]

  tags = [{
    key                 = "Name"
    value               = "PM4-${var.pm4_client_name}-ECS-WEB"
    propagate_at_launch = true
  }, ]

  lifecycle {
    create_before_destroy = true
  }
}
###############################
#WORKERS Launch Configurations# 
###############################

resource "aws_launch_configuration" "workers_lc" {
  name            = "PM4-${var.pm4_client_name}-Workers"
  image_id        = var.tasks_instance_ami
  instance_type   = var.tasks_instance_type
  security_groups = [aws_security_group.pm4_tasks_sg.id]
  key_name        = aws_key_pair.pm4_nat_key.id

  user_data = <<EOF

#!/bin/bash
mkdir /mnt/efs
echo "${aws_efs_file_system.fs_efs.id}:/ /mnt/efs efs _netdev 0 0" >> /etc/fstab
mount -a
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "workers_asg" {
  name                 = "PM4-${var.pm4_client_name}-Workers"
  launch_configuration = aws_launch_configuration.workers_lc.name
  desired_capacity     = 2
  min_size             = 2
  max_size             = 4

  vpc_zone_identifier = [aws_subnet.pm4_tasks_a.id, aws_subnet.pm4_tasks_b.id]

  tags = [{
    key                 = "Name"
    value               = "PM4-${var.pm4_client_name}-Worker"
    propagate_at_launch = true
  }, ]

  lifecycle {
    create_before_destroy = true
  }
}
