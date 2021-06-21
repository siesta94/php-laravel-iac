resource "aws_efs_file_system" "fs_efs" {
  creation_token   = "efs-file-system"
  performance_mode = "generalPurpose"

  tags = {
    Name = "PM4-${var.pm4_client_name}-EFS"
  }
}

resource "aws_efs_mount_target" "fs_efs_mount_a" {
  file_system_id  = aws_efs_file_system.fs_efs.id
  subnet_id       = aws_subnet.pm4_efs_a.id
  security_groups = [aws_security_group.pm4_efs_sg.id]
}

resource "aws_efs_mount_target" "fs_efs_mount_b" {
  file_system_id  = aws_efs_file_system.fs_efs.id
  subnet_id       = aws_subnet.pm4_efs_b.id
  security_groups = [aws_security_group.pm4_efs_sg.id]
}
