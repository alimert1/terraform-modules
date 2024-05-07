resource "aws_ecs_service" "main" {
  name                               = "${var.project}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 1 //başlatılan görev sayısı
  deployment_maximum_percent         = 200 //Hizmet dağıtımı sırasında izin verilen çalışan görevlerin maksimum yüzdesi
  deployment_minimum_healthy_percent = 100 // Hizmet dağıtımı sırasında izin verilen çalışan görevlerin minimum yüzdesi
  health_check_grace_period_seconds  = 0 // Bu süre boyunca, ECS, konteynerlerin başlatılmasını bekler ve bu süre boyunca konteynerlerin sağlıklı olup olmadığını kontrol eder.
  platform_version                   = "LATEST"

  network_configuration {
    security_groups = ["${aws_security_group.ecs-sg.id}"]
    subnets         = var.ecs_service_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "${var.project}-container"
    container_port   = 3000
    /*
    Bu, uygulamanın dış dünyaya erişilebilir olması için bir Load Balancer aracılığıyla bu portun hedeflenmesi gerektiği anlamına gelir.
    Dolayısıyla, Load Balancer ayarlarınızda container_port değerini 3000 olarak belirtmişsiniz. Bu sayede gelen istekler bu port üzerinden uygulamanıza yönlendirilir.
    */
  }

  deployment_controller {
    type = "ECS"
  }

  /*
  deployment_controller: Bu özellik, ECS servisinizin nasıl dağıtılacağını belirtir. type parametresiyle belirlenen değer, ECS'nin hangi dağıtım kontrolcüsünü kullanacağını belirtir. Örneğin, burada type = "ECS" kullanılarak ECS'nin kendi dağıtım kontrolcüsünün kullanılacağı belirtilmiştir.
  Bu, ECS'nin dağıtım için kendi özel stratejilerini kullanacağı anlamına gelir.

  Bu blok, ECS servisinin nasıl dağıtılacağını belirlemek ve bağımlılıkları yönetmek için kullanılır,
  böylece altyapı kaynakları doğru sırayla oluşturulabilir ve hizmetin sağlıklı bir şekilde çalışması sağlanabilir.
  */

  depends_on = [aws_lb_listener.https]
}

resource "aws_appautoscaling_target" "ecs_service" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_out" {
  name               = "${var.project}-scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 75.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name               = "${var.project}-scale-in"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 25.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}


