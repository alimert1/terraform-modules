resource "aws_db_instance" "mysql" {
  allocated_storage               = var.allocated_storage
  auto_minor_version_upgrade      = true
  backup_retention_period         = 1
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["error"]
  monitoring_interval             = 0
  network_type                    = "IPV4"
  identifier                      = "limon-database"
  skip_final_snapshot             = false
  final_snapshot_identifier       = "limon-database"
  storage_encrypted               = true
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  db_name                         = var.db_name
  username                        = var.master_username
  password                        = aws_secretsmanager_secret_version.limon-password.secret_string
  storage_type                    = var.storage_type
  port                            = var.port
  multi_az                        = var.multi_az
  vpc_security_group_ids          = [aws_security_group.rds_db.id]
  db_subnet_group_name            = aws_db_subnet_group.rds_db.name

  performance_insights_enabled    = true 

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }

  depends_on = [aws_secretsmanager_secret_version.limon-password]

}