output "pm4_ecs_cluster" {
  value       = aws_ecs_cluster.pm4_ecs_cluster
  description = "ECS Cluster Output for APP module"
}

output "pm4_alb" {
  value       = aws_lb.pm4_alb
  description = "ECS Cluster Output for APP module"
}

output "pm4_web_subnet_a" {
  value       = aws_subnet.pm4_web_a
  description = "Subnets for Services"
}

output "pm4_web_subnet_b" {
  value       = aws_subnet.pm4_web_b
  description = "Subnets for Services"
}

output "pm4_web_sg" {
  value       = aws_security_group.pm4_web_sg
  description = "Security Group for Services"
}

output "fs_efs" {
  value       = aws_efs_file_system.fs_efs
  description = "EFS Information for Service"
}

output "stm_tg" {
  value       = aws_lb_target_group.stm_tg
  description = "TG for STM service"
}

output "pm4_secure_listener" {
  value       = aws_lb_listener.pm4_secure_listener
  description = "ALB Listener for TG STM service"
}
