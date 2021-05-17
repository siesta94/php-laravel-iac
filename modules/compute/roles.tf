resource "aws_iam_role" "ecs-ec2-role" {
  name               = "ecsInstanceRole"
  assume_role_policy = file("${path.module}/policies/ecs-ec2-role.json")
  tags = {
    Name = "ecsInstanceRole"
  }
}
resource "aws_iam_instance_profile" "ecs_ec2_role" {
  name = "ecs-role"
  role = aws_iam_role.ecs-ec2-role.name
}
resource "aws_iam_role_policy" "ecs-ec2-role-policy" {
  name   = "ecsInstanceRole-Policy"
  role   = aws_iam_role.ecs-ec2-role.id
  policy = file("${path.module}/policies/ecs-ec2-role-policy.json")
}
