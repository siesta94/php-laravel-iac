module "compute" {
  source = "./modules/compute"

  pm4_client_name = "example"
  vpc_cidr = "10.0.0.0/16"
  cidrs = {
    pm4_dmz_a      = "10.0.1.0/24"
    pm4_dmz_b      = "10.0.2.0/24"
    pm4_frontend_a = "10.0.3.0/24"
    pm4_frontend_b = "10.0.4.0/24"
    pm4_efs_a      = "10.0.5.0/24"
    pm4_efs_b      = "10.0.6.0/24"
    pm4_redis_a    = "10.0.7.0/24"
    pm4_redis_b    = "10.0.8.0/24"
    pm4_tasks_a    = "10.0.9.0/24"
    pm4_tasks_b    = "10.0.10.0/24"
    pm4_web_a      = "10.0.11.0/24"
    pm4_web_b      = "10.0.12.0/24"
    pm4_alb_a      = "10.0.13.0/24"
    pm4_alb_b      = "10.0.14.0/24"
    pm4_backend_a  = "10.0.15.0/24"
    pm4_backend_b  = "10.0.16.0/24"
  }
  nat_ami             = "ami-00a9d4a05375b2763"
  nat_instance_type   = "t3.medium"
  nat_key             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJ43kXcr+Wn9IbUoIAJgmgIDCC+xb69nM4w/Zz4PkRDFlBwGRzS5ZnOdvh1JznqVAGrwGsGQ4ydMpvsmvnuot2G6qRSvK3mz7KSGyEkomXI3lz8AKlmSS8U5GOgP0DYHKtfOVfqGYRUSW5hrWogBY+aJb1d8SGtJOe8Qpaw2rAGT4ZjqZKZqSY3dCa/nwxN6C2ymwbHj5ieSTRGD9PUHsD3gGRHDV7Dgwxyh/AlQZFgcBg/FQf8l/gj1QqiPRC3k+kWNmcKwiM48fuSwj7v2bUNCo5nSE5maQuNymqEl02BauPLFlY3OE24QWoFyxI4ehzdgNmzWJRvs/UwoXUJlxzjLX7UVw6YuH3QKQv7ksSAXHxabpen+NU61JIQVfptFIuaH17xuHuSXkdPuxvCNwDvrzosIONK3VtTwzJe2f4A28W8GaYlIxweV919mgK1U3/0StdYystKUbuVoRkisSSPNuVz9NWjMlQYQdwjEdPFYXzahGmOw6pF86mNvkaM/E= root@linuxws"
  ecs_instance_ami    = "ami-0ae3143bc8c29507d"
  ecs_instance_type   = "t3.medium"
  tasks_instance_ami  = "ami-0742b4e673072066f"
  tasks_instance_type = "t3.medium"
  rds_instance_type = "db.t3.small"
}
