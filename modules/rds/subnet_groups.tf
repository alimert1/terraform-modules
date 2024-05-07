# resource "aws_db_subnet_group" "rds_db" {
#   name       = "${lower(var.project)}-db-subnet-group"
#   subnet_ids = var.data_subnets

# } 

resource "aws_db_subnet_group" "rds_db" {
  name = "${lower(replace(var.project, "/[^a-z0-9-_/g]", ""))}_db_subnetgroup"
  subnet_ids = var.data_subnets
}