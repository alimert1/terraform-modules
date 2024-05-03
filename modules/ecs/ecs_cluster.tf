resource "aws_ecs_cluster" "main" {
  name = var.project

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  /*
  CloudWatch automatically collects metrics for many resources, such as CPU, memory, disk, and network.
  Container Insights also provides diagnostic information, such as container restart failures, that you use to isolate issues and resolve them quickly.
  You can also set CloudWatch alarms on metrics that Container Insights collects.
  */

  tags = {
    Name      = var.project
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE"
  }
}
