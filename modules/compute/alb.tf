resource "aws_lb" "pm4_alb" {
  name               = "PM4-${var.pm4_client_name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pm4_alb_sg.id]
  subnets            = [aws_subnet.pm4_alb_a.id, aws_subnet.pm4_alb_b.id]

  enable_deletion_protection = true

  #access_logs {
  #  bucket  = aws_s3_bucket.lb_logs.bucket
  #  prefix  = "pm4-client-lb"
  #  enabled = true
  #}

  tags = {
    Name = "PM4-${var.pm4_client_name}-ALB"
  }
}

resource "aws_lb_target_group" "stm_tg" {
  name     = "PM4-${var.pm4_client_name}-STM-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.pm4_client_vpc.id
}

resource "aws_lb_listener" "pm4_unsecure_listener" {
  load_balancer_arn = aws_lb.pm4_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "pm4_secure_listener" {
  load_balancer_arn = aws_lb.pm4_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.pm4_cert.arn 

  default_action {
    type             = "redirect"
    redirect {
	host = "google.com"
	status_code = "HTTP_301"
    }
  }
}
