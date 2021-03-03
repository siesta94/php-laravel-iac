variable "profile" {
  type    = string
  default = "default"
}

variable "vpc_cidr" {}
variable "cidrs" {
  type = map(string)
}

variable "nat_key" {}

variable "nat_instance_type" {}
variable "nat_ami" {}

variable "ecs_instance_type" {}
variable "ecs_instance_ami" {}
variable "ecs_cluster_name" {}

variable "tasks_instance_ami" {}
variable "tasks_instance_type" {}
