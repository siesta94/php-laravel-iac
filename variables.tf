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
