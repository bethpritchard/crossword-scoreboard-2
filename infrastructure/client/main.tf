provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      project     = "crossword-scoreboard"
      app         = "frontend"
      environment = "dev"
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
    bucket         = "crossword-scoreboard-state"
    key            = "client.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "crossword-scoreboard-state-lock"
    encrypt        = true
  }
}

