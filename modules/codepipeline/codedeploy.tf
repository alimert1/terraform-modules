resource "aws_codedeploy_app" "limon_api" {
  compute_platform = "ECS"
  name             = "limon_api"
}

resource "aws_codedeploy_app" "limon_frontend" {
  compute_platform = "ECS"
  name             = "limon_frontend"
}

resource "aws_codedeploy_deployment_group" "limon_api" {
  app_name               = aws_codedeploy_app.limon_api.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "example"
  service_role_arn       = aws_iam_role.codedeploy.arn


  ecs_service {
    cluster_name = "nodejs-app-cluster"
    service_name = "limon-project-service"
  }

}