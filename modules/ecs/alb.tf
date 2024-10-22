#### Application Load Balancer

resource "aws_lb" "api_alb" {
  name               = "${var.organization}-api-${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_listener" "api_alb_http_listener" {
  load_balancer_arn = aws_lb.api_alb.arn
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

resource "aws_lb_listener" "api_alb_listener" {
  load_balancer_arn = aws_lb.api_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_alb_tg.arn
  }
}

resource "aws_lb_target_group" "api_alb_tg" {
  name     = "${var.organization}-api-${var.env}-tg"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 60
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200"
  }

  tags = {
    Environment = var.env
  }
}
