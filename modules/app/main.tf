resource "aws_ecs_task_definition" "pm4_task_definition" {
  family             = "pm4-app"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = data.template_file.pm4_td.rendered
  volume {
	name = "EFS"
  	efs_volume_configuration {
  	    file_system_id          = var.fs_efs.id
            root_directory          = "/"
            transit_encryption      = "ENABLED"
        }
  }
  tags = {
    Environment = "prod"
    Application = "${var.pm4_client_name}-pm4-app"
  }
}

resource "aws_ecs_service" "pm4_service" {
  name            = "${var.pm4_client_name}-pm4-app"
  cluster         = var.pm4_ecs_cluster.id
  task_definition = aws_ecs_task_definition.pm4_task_definition.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.pm4_tg.arn
    container_name   = "pm4-app"
    container_port   = 80
  }
}

data "template_file" "pm4_td" {
  template = file("./modules/app/task-def/task_definition.json")

  vars = {
    service_name = "${var.pm4_client_name}"
    container_image = "${var.pm4_container_image}"
  }
}
