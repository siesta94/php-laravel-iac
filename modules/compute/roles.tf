resource "aws_iam_role" "ecs_ec2_role" {
  name               = "PM4-${var.pm4_client_name}-ecsInstanceRole"
  assume_role_policy = file("${path.module}/policies/ecs-ec2-role.json")
  tags = {
    Name = "PM4-${var.pm4_client_name}-ecsInstanceRole"
  }
}
resource "aws_iam_instance_profile" "ecs_ec2_role" {
  name = "PM4-${var.pm4_client_name}-ecs-Role"
  role = aws_iam_role.ecs_ec2_role.name
}
resource "aws_iam_role_policy" "ecs_ec2_role_policy" {
  name   = "PM4-${var.pm4_client_name}-ecsInstanceRole-Policy"
  role   = aws_iam_role.ecs_ec2_role.id
  policy = file("${path.module}/policies/ecs-ec2-role-policy.json")
}
