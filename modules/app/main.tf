resource "aws_ecs_task_definition" "stm_task_definition" {
  family             = "stm-app"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = data.template_file.stm_td.rendered
  tags = {
    Environment = "prod"
    Application = "${var.pm4_client_name}-stm-app"
  }
}

resource "aws_ecs_service" "stm_service" {
  name            = "${var.pm4_client_name}-stm-app"
  cluster         = var.pm4_ecs_cluster.id
  task_definition = aws_ecs_task_definition.stm_task_definition.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.stm_tg.arn
    container_name   = "stm-app"
    container_port   = 80
  }
}

data "template_file" "stm_td" {
  template = file("./modules/app/task-def/task_definition.json")
}
