resource "aws_elasticache_subnet_group" "pm4_redis_subnet_group" {
  name       = "PM4-${var.pm4_client_name}-Subnet-Group"
  subnet_ids = [aws_subnet.pm4_redis_a.id, aws_subnet.pm4_redis_b.id]
}

resource "aws_elasticache_cluster" "pm4_redis" {
  cluster_id           = "pm4-${var.pm4_client_name}-redis-cluster"
  subnet_group_name    = aws_elasticache_subnet_group.pm4_redis_subnet_group.name
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  security_group_ids   = [aws_security_group.pm4_redis_sg.id]
  port                 = 6379
}
