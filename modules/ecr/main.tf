resource "aws_ecr_repository" "limon-api" {
  name = "limon-api"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform = "true"
  }
}

resource "aws_ecr_repository" "limon-frontend" {
  name = "limon-frontend"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform = "true"
  }
}