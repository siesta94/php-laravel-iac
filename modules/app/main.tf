resource "aws_ecs_task_definition" "task_definition" {
  container_definitions    = "${data.template_file.task_definition_json.rendered}"
  #execution_role_arn       = "EcsTaskExecutionRole"
  family                   = "openapi-task-defination"                                                                     
  network_mode             = "awsvpc"                                                                                     
  memory                   = "2048"
  cpu                      = "1024"
  requires_compatibilities = ["EC2"]                                  
  #task_role_arn            = "EcsTaskExecutionRole"                                                                  
} 

data "template_file" "task_definition_json" {
  template = file("${path.module}/task-def/task_definition_json")
}

resource "aws_ecs_service" "service" {
  cluster                = var.pm4_ecs_cluster.id
  desired_count          = 1                                                       
  launch_type            = "EC2"                                                     
  name                   = "nginx-service"
  task_definition        = aws_ecs_task_definition.task_definition.arn
  load_balancer {
    container_name       = "nginx"
    container_port       = "8080"
    target_group_arn     = var.stm_tg.arn
  }
  network_configuration {
    security_groups       = [var.pm4_web_sg.id]
    subnets               = [var.pm4_web_subnet_a.id, var.pm4_web_subnet_b.id]
    assign_public_ip      = "false"
  }
  #depends_on              = var.pm4_secure_listener
}
