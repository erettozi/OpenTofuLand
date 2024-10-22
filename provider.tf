terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }

  backend "s3" {
    bucket         = "example-dev-state"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "example-dev-state-lock"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  region = "us-east-1"
  alias  = "aws-us-east-1"
}