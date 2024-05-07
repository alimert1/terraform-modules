# resource "random_password" "rds_master" {
#   length           = 16
#   upper            = true
#   numeric          = true
#   special          = true
#   override_special = "_!%^"
#   min_upper        = 1
#   min_lower        = 1
#   min_special      = 1 
#   min_numeric      = 1
# }

# resource "aws_secretsmanager_secret" "rds_password" {
#   name                    = "${lower(var.cluster_identifier)}-password"
#   recovery_window_in_days = 0
# }

# resource "aws_secretsmanager_secret_version" "rds_password" {
#   secret_id = aws_secretsmanager_secret.rds_password.id
#   secret_string = jsonencode({
#     Master_Username = "${var.master_username}"
#     Master_Password = "${random_password.rds_master.result}"
#     }
#   )
# }

resource "random_password" "limon-master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "limon-password" {
  name = "limon-prod-db"

  tags = {
    Terraform   = "true"
    environment = "prod"
  }
}

resource "aws_secretsmanager_secret_version" "limon-password" {
  secret_id     = aws_secretsmanager_secret.limon-password.id
  secret_string = random_password.limon-master.result
}