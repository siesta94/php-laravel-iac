#---launch configuration---

resource "aws_launch_configuration" "ecs_lc" {
  name            = "PM4-Client-ECS-Web"
  image_id        = var.ecs_instance_ami
  instance_type   = var.ecs_instance_type
  security_groups = [aws_security_group.pm4_web_sg.id]
  key_name        = aws_key_pair.pm4_nat_key.id
#  user_data       = file("userdata")

  lifecycle {
    create_before_destroy = true
  }
}
