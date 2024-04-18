resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "${var.project}-container"
      image     = "${var.ecr_image}"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/${var.project}-task-definition"
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          containerPort = 3978
          hostPort      = 3978
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}
