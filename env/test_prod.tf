
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }

  backend "s3" {
    bucket         = "<<project>>-tfstate-<<environment>>"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-central-1"
    
    access_key     = ""
    secret_key     = ""
  }
}

provider "aws" {
  region     = "eu-central-1"
  access_key = ""
  secret_key = ""

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

  project_name  = "terraform-modules"
  environment     = "Test"
  region  = "frankfurt"
}