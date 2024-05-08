resource "aws_s3_bucket" "limon_api" {
  bucket = "limon_apicodepipeline"

  tags = {
    Name        = "limon_apicodepipeline"
    Terraform   = "true"
    Environment = ""
  }
}

resource "aws_s3_bucket_acl" "limon_api_acl" {
  bucket = aws_s3_bucket.limon_api.id
  acl    = "private"
}

resource "aws_s3_bucket" "limon_frontend" {
  bucket = "limon-frontend-codepipeline"

  tags = {
    Name        = "limon-frontend-codepipeline"
    Terraform   = "true"
    Environment = ""
  }
}

resource "aws_s3_bucket_acl" "limon_frontend_acl" {
  bucket = aws_s3_bucket.limon_frontend.id
  acl    = "private"
}


##############################################################


resource "aws_codepipeline" "limon_api" {
  name     = "limon_api-pipeline"
  role_arn = aws_iam_role.limon_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.limon_api.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build"]
      output_artifacts = ["deploy"]
      configuration = {
        ClusterName = "nodejs-app-cluster"
        ServiceName = "nodejs-test-svc"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = ""
  }
}

##############################################################
##############################################################


resource "aws_codepipeline" "limon_frontend" {
  name     = "limon-frontend-pipeline"
  role_arn = aws_iam_role.limon_frontend_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.limon_frontend.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]
      configuration = {
        FullRepositoryId = "limondev/limon-frontend"
        BranchName       = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      configuration = {
        ProjectName = aws_codebuild_project.limon_frontend.name
      }
    }
  }

stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build"]
      output_artifacts = ["deploy"]
      configuration = {
        ClusterName = "nodejs-app-cluster"
        ServiceName = "nodejs-test-svc"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = ""
  }
}





