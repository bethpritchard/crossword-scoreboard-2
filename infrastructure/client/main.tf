provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      project     = "crossword-scoreboard"
      app         = "frontend"
      environment = "${var.environment}"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.48.0"
    }
  }

  backend "s3" {
  }
}

