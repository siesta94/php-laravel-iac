vpc_cidr = "10.0.0.0/16"
cidrs = {
  pm4_dmz_a      = "10.0.1.0/24"
  pm4_dmz_b      = "10.0.2.0/24"
  pm4_frontend_a = "10.0.3.0/24"
  pm4_frontend_b = "10.0.4.0/24"
  pm4_efs_a      = "10.0.5.0/24"
  pm4_efs_b      = "10.0.6.0/24"
  pm4_redis_a    = "10.0.7.0/24"
  pm4_redis_b    = "10.0.8.0/24"
  pm4_tasks_a    = "10.0.9.0/24"
  pm4_tasks_b    = "10.0.10.0/24"
  pm4_web_a      = "10.0.11.0/24"
  pm4_web_b      = "10.0.12.0/24"
  pm4_alb_a      = "10.0.13.0/24"
  pm4_alb_b      = "10.0.14.0/24"
  pm4_backend_a  = "10.0.15.0/24"
  pm4_backend_b  = "10.0.16.0/24"
}

nat_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDemnr2xX04pALMOb+8j8f2nUOmZR6RFsvIGQk0H1AFaGWZap8LDfS5Quwvr0+I8JcAct1JYddLO9QOqD+XiI1Lvyf0v0O8ft/4eb8a7wk6B2IXLXE+JY32YwCDdDlmHDOsIU3kSUgtnXWbKCR8QQgINao1uwsjkdzGllVaEtQdlcKVUwRIpzV8XEdHgwu30s+PFf8kQK368GVG+QGDlwHKOm9bHWafSQlta3mYbZIHPbEAzNXj5c3YlCAFmghr8BvGtbi+IRd6B5ced7xHhSkueZNbA4b1G5gsKHjsa0bh6uTXxkzTnVH/nkotCCoJ94WeEwHy/4M4Y7r55HtHPw0D root@ip-172-16-51-6.ec2.internal"

nat_instance_type = "t3.medium"
nat_ami           = "ami-00a9d4a05375b2763"

#tasks_instance_type = "t3.medium"
#task_instance_ami = ""

ecs_instance_type = "t3.medium"
ecs_instance_ami  = "ami-00a9d4a05375b2763"
ecs_cluster_name  = "PM4-Client-ECS-Cluster"

