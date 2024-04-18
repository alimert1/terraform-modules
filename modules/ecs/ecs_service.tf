resource "aws_ecs_service" "main" {
  name                               = "${var.project}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 0
  platform_version                   = "LATEST"

  network_configuration {
    security_groups = ["${aws_security_group.ecs-sg.id}"]
    subnets         = var.ecs_service_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "${var.project}-container"
    container_port   = 3978
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_lb_listener.https]
}


