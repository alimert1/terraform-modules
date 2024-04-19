resource "aws_db_subnet_group" "rds_db" {
  name       = "${lower(var.project)}-db-subnet-group"
  subnet_ids = var.data_subnets

} 