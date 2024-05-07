# resource "aws_security_group" "rds_db" {
#   name        = "${var.project}-RDS-SG"
#   description = "${var.project}-RDS-SG"
#   vpc_id      = var.vpc_id

#   ingress {
#     protocol    = "tcp"
#     from_port   = var.port
#     to_port     = var.port
#     cidr_blocks = [var.vpc_cidr]
#   } 

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.project}-RDS-SG"

#   }
# }

resource "aws_security_group" "rds_db" {
  name        = "${var.project}-RDS-SG"
  description = "Port Number to Allow Traffic"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.port
    to_port     = var.port
    cidr_blocks = ["${var.sg_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.egress_cidr]
  }

  tags = {
    Name      = "${var.project}-RDS-SG"
    Terraform = "true"
  }
}