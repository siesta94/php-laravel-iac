####################
#CREATE ECS CLUSTER#
####################

resource "aws_ecs_cluster" "pm4_ecs_cluster" {
  name = "PM4-${var.pm4_client_name}-ECS"

}
