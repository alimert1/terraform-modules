resource "aws_mq_broker" "my_mq" {
  broker_name        = var.broker_name
  engine_type        = var.engine_type
  engine_version     = var.engine_version
  host_instance_type = var.host_instance_type
  security_groups    = [aws_security_group.mq_sg.id]
  deployment_mode    = "SINGLE_INSTANCE"
  subnet_ids         = [var.data_subnets[0]]


  user {
    username       = var.username
    password       = aws_secretsmanager_secret_version.mq_password.secret_string
    console_access = true
  }

  depends_on = [random_password.mq_master]
}
