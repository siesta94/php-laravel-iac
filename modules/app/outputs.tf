output "stm_service" {
  value = aws_ecs_service.stm_service 
  description = "ECS Service for TG attachment"
}
