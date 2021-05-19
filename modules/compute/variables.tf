variable "vpc_cidr" {}
variable "cidrs" {
  type = map(string)
}
variable "pm4_client_name" {}
variable "nat_ami" {}
variable "nat_instance_type" {}
variable "nat_key" {}
variable "ecs_instance_ami" {}
variable "ecs_instance_type" {}
variable "tasks_instance_ami" {}
variable "tasks_instance_type" {}
variable "rds_instance_type" {}
