resource "aws_alb" "test_alb" {
  name            = "test-alb"
  internal        = false
  subnets         = var.public_subnet_list
  security_groups = [var.alb_sg_id]
  enable_deletion_protection = true

  access_logs {
    bucket  = var.bucket_alblog
    enabled = true
  }
}

resource "aws_lb_target_group" "test_alb_tg" {
  name     = var.alb_tg_id
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  deregistration_delay = 60

  health_check {
    interval             =  15
    path                 =  "/"
    port                 =  "traffic-port"
    protocol             =  "HTTP"
    timeout              =  10
    healthy_threshold    =  2
    unhealthy_threshold  =  3
    matcher              =  200
  }
}

/**
 * HTTP Lister for ALB
 */
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.test_alb.arn
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

/**
 * HTTPS Lister for ALB
*/
resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = "arn:aws:acm:us-west-2:123456789:certificate/000000-000-000-000-000000"

  default_action {
    target_group_arn = aws_lb_target_group.test_alb_tg.arn
    type             = "forward"
  }
}

