####################
#CREATE ECS CLUSTER#
####################

resource "aws_ecs_capacity_provider" "pm4-ecs-cap" {
  name = "Default-Capacity"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}

resource "aws_ecs_cluster" "pm4-client-ecs-cluster" {
  name = "PM4-Client-ECS-Cluster"

}
