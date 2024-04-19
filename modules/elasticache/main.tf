resource "aws_elasticache_cluster" "main" {
  cluster_id           = var.cluster_id
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.elasticache-sg.id]
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.data_subnets
}

## REPLICATION SCRIPT

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = var.cluster_id
  description                = var.cluster_id
  node_type                  = var.node_type
  engine                     = var.engine
  engine_version             = var.engine_version
  port                       = var.port
  parameter_group_name       = var.parameter_group_name
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [aws_security_group.elasticache-sg.id]
  automatic_failover_enabled = true

  num_node_groups         = var.num_cache_nodes
  replicas_per_node_group = 1

  tags = {
    Name       = "${var.cluster_id}-subg"
  }
}

