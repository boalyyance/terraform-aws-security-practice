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

resource "aws_s3_bucket" "practice_bucket" {
  bucket = "your-unique-bucket-name-here"

  tags = {
    Name        = "Practice Bucket"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
