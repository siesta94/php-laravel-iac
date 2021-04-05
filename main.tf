module "compute" {
  source = "./modules/compute"

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
}
