###########################################################
#Creating S3 Buckets for application and terraform backend#
###########################################################

resource "aws_s3_bucket" "pm4_bucket" {
  bucket = "pm4-${var.pm4_client_name}-app-bucket"
  acl    = "private"

  tags = {
    Name        = "pm4-${var.pm4_client_name}-app-bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket" "pm4_terraform_backend_bucket" {
  bucket = "pm4-${var.pm4_client_name}-bucket-terraform"
  acl    = "private"

  tags = {
    Name        = "pm4-${var.pm4_client_name}-bucket-terraform"
    Environment = "Prod"
  }
}
