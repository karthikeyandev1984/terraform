provider "aws" {
  profile = "terraform"
  region = "eu-west-1"
}

terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.73"
    }

  }
}
