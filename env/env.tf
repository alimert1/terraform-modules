
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "limon-project-tfstate"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-central-1"
    profile        = "limon-project"
  }
}

provider "aws" {
  region     = "eu-central-1"
  profile    = "limon-project"

  default_tags {
    tags = {
      Environment = ""
      Region = ""
      Terraform = "true"
    }
  }
}

module "main" {
  source = "../main"

  project = "limon-project"
  env     = "prod"
  region  = "eu-central-1"
}