# resource "aws_rds_cluster" "rds_db" {
#   deletion_protection             = false
#   engine                          = var.engine
#   engine_mode                     = var.engine_mode
#   engine_version                  = var.engine_version
#   cluster_identifier              = lower(var.cluster_identifier)
#   database_name                   = replace(var.database_name, "-", "")
#   master_username                 = var.master_username
#   master_password                 = random_password.rds_master.result
#   backup_retention_period         = 7
#   preferred_backup_window         = var.preferred_backup_window
#   preferred_maintenance_window    = var.preferred_maintenance_window
#   allow_major_version_upgrade     = false
#   db_subnet_group_name            = aws_db_subnet_group.rds_db.name
#   vpc_security_group_ids          = [aws_security_group.rds_db.id]
#   enabled_cloudwatch_logs_exports = ["postgresql"]
#   skip_final_snapshot             = true
#   #final_snapshot_identifier       = "${var.cluster_identifier}-final-snapshot"

#   depends_on = [random_password.rds_master]
# }

# # serverlessv2_scaling_configuration {
# #     max_capacity = 2.0 
# #     min_capacity = 0.5
# #   }

# resource "aws_rds_cluster_instance" "rds_instance" {
#   count                = var.instance_count
#   identifier           = "${lower(var.cluster_identifier)}-${count.index}"
#   cluster_identifier   = aws_rds_cluster.rds_db.id
#   instance_class       = var.instance_class
#   engine               = aws_rds_cluster.rds_db.engine
#   engine_version       = aws_rds_cluster.rds_db.engine_version
#   publicly_accessible  = false
#   db_subnet_group_name = aws_db_subnet_group.rds_db.name
# }

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