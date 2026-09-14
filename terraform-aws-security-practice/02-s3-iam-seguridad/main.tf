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

# 1. The S3 bucket
resource "aws_s3_bucket" "practice_bucket" {
  bucket = "your-unique-bucket-name-here"

  tags = {
    Name        = "Practice Bucket"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# 2. Block all public access
resource "aws_s3_bucket_public_access_block" "practice_bucket_block" {
  bucket = aws_s3_bucket.practice_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Server-side encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "practice_bucket_encryption" {
  bucket = aws_s3_bucket.practice_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Versioning (protects against accidental deletion / ransomware)
resource "aws_s3_bucket_versioning" "practice_bucket_versioning" {
  bucket = aws_s3_bucket.practice_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 5. IAM user (test identity)
resource "aws_iam_user" "test_user" {
  name = "terraform-test-user"

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# 6. Least-privilege policy: read-only access to THIS bucket only
resource "aws_iam_policy" "s3_read_only_policy" {
  name        = "s3-read-only-practice-bucket"
  description = "Allows read-only access to the practice bucket only"

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
          aws_s3_bucket.practice_bucket.arn,
          "${aws_s3_bucket.practice_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 7. Attach the policy to the user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.test_user.name
  policy_arn = aws_iam_policy.s3_read_only_policy.arn
}
