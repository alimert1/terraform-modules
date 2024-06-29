resource "aws_ecr_repository" "limon_api" {
  name = "limon_api"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform = "true"
  }
}

resource "aws_ecr_repository" "limon_frontend" {
  name = "limon_frontend"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform = "true"
  }
}