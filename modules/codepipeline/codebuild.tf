resource "aws_security_group" "limon_codebuild" {
  name        = "codebuild-security-group"
  description = "Security group for AWS CodeBuild"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_codebuild_project" "limon_api" {
  name           = "limon-api"
  description    = "limon-api build and ship project"
  build_timeout  = "30"
  queued_timeout = "480"
  service_role   = aws_iam_role.limon_codebuild_role.arn
  source_version = "refs/heads/master"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  vpc_config {
    security_group_ids = [aws_security_group.limon_codebuild.id]
    subnets            = var.private_subnets
    vpc_id             = var.vpc_id
  }

  source {
    type                = "CODECOMMIT"
    location            = "https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/nodejs-project-terraform"
    git_clone_depth     = 1
    report_build_status = false

    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = {
    Name        = "limon-api"
    Terraform   = "true"
    Environment = "prod"
  }
}

resource "aws_codebuild_project" "limon_frontend" {
  name           = "limon-frontend"
  description    = "limon-frontend build and ship project"
  build_timeout  = "30"
  queued_timeout = "480"
  service_role   = aws_iam_role.limon_codebuild_role.arn
  source_version = "refs/heads/master"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  vpc_config {
    security_group_ids = [aws_security_group.limon_codebuild.id]
    subnets            = var.private_subnets
    vpc_id             = var.vpc_id
  }

  source {
    type                = "GITHUB"
    location            = "https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/nodejs-project-frontend-terraform"
    git_clone_depth     = 1
    report_build_status = false

    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = {
    Name        = "limon-frontend"
    Terraform   = "true"
    Environment = "prod"
  }
}



