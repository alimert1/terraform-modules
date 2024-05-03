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

      /*
      essential = true: Bu parametre, konteynerin hizmetin çalışması için zorunlu olup olmadığını belirtir.
      true olarak ayarlandığında, hizmetin çalışması için bu konteynerin başlatılması gerekir.
      */

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/${var.project}-task-definition"
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
        /*
        awslogs-group = "/ecs/${var.project}-task-definition": 
        Bu parametre, günlüklerin hangi CloudWatch Logs grubuna kaydedileceğini belirtir. Bu örnekte, her görev tanımı için benzersiz bir CloudWatch Logs grubu oluşturmak için proje adı kullanılır.

        awslogs-stream-prefix = "ecs": Bu parametre, günlük akışlarının ön adını belirtir. 
        Bu, genellikle konteynerin adı veya başka bir tanımlayıcı olabilir. Bu örnekte, ecs ön adı kullanılmıştır.
        */
      }

      portMappings = [
        {
          containerPort = 3000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}
