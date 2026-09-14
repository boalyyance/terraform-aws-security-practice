terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "practice_bucket" {
  source      = "./modules/secure-s3-bucket"
  bucket_name = "your-unique-bucket-name-here"
  environment = "Learning"
}
