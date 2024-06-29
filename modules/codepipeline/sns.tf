resource "aws_sns_topic" "pipeline_notifications" {
  name = "pipeline_notifications_topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.pipeline_notifications.arn
  protocol  = "email"
  endpoint  = "mert.yilmaz@limoncloud.com" 
}

resource "aws_codestarnotifications_notification_rule" "limon_api_notification_rule" {
  name                = "limon-api-notification-rule"
  detail_type         = "BASIC"
  event_type_ids      = ["codepipeline-pipeline-execution-state-change"]
  resource            = aws_codepipeline.limon_api.arn
  target {
    type              = "SNS"
    address           = aws_sns_topic.pipeline_notifications.arn
  }
}

resource "aws_codestarnotifications_notification_rule" "limon_frontend_notification_rule" {
  name                = "limon-frontend-notification-rule"
  detail_type         = "BASIC"
  event_type_ids      = ["codepipeline-pipeline-execution-state-change"]
  resource            = aws_codepipeline.limon_frontend.arn
  target {
    type              = "SNS"
    address           = aws_sns_topic.pipeline_notifications.arn
  }
}
