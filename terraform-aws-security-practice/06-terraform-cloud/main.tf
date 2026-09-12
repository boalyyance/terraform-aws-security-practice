terraform {
  required_version = ">= 1.5.7"

  cloud {
    organization = "your-organization-name"

    workspaces {
      name = "aws-security-practice"
    }
  }

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

resource "aws_iam_role" "ec2_s3_read_role" {
  name = "ec2-s3-read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_read_policy" {
  name = "s3-read-only-inline-policy"
  role = aws_iam_role.ec2_s3_read_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.practice_bucket.bucket_arn,
          "${module.practice_bucket.bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-read-profile"
  role = aws_iam_role.ec2_s3_read_role.name
}
