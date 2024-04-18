resource "aws_lb" "main" {
  name               = "${var.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  drop_invalid_header_fields = false
  desync_mitigation_mode     = "defensive"


  tags = {
    Name      = "${var.project}-lb"
  }
}
#################################
#################################


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    order            = 1
    target_group_arn = aws_lb_target_group.main.arn
  }
}

#################################
#################################


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"


  default_action {
    order = 1
    type  = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

################################
################################


resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = ["wp-rpa.titasaws.com"]
    }
  }
  condition {
    path_pattern {
      values = ["/api/whatsapp"]
    }
  }
}

#################################
#################################


resource "aws_lb_target_group" "main" {
  name                 = "${var.project}-TG"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 300
  vpc_id               = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = 200
    path                = "/"
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