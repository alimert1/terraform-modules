resource "random_password" "mq_master" {
  length           = 16
  upper            = true
  numeric          = true
  special          = true
  override_special = "_!%^"
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
}

resource "aws_secretsmanager_secret" "mq_password" {
  name = "${var.broker_name}-mq"
}

resource "aws_secretsmanager_secret_version" "mq_password" {
  secret_id = aws_secretsmanager_secret.mq_password.id
  secret_string = jsonencode({
    Master_Password = "${random_password.mq_master.result}"
    }
  )
}