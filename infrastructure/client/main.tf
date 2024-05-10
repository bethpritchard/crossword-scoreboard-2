provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      project = "crossword-scoreboard"
      app     = "frontend"
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
    key            = "frontend.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "crossword-scoreboard-state-lock"
    encrypt        = true
  }
}

