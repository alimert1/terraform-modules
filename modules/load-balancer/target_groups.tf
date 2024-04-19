resource "aws_lb_target_group" "main" {
  name                 = "${var.project}-TG"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 300
  vpc_id               = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/health-check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = ""
  port             = 80
}