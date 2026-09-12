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

# 1. S3 bucket
resource "aws_s3_bucket" "practice_bucket" {
  bucket = "your-unique-bucket-name-here"

  tags = {
    Name        = "Practice Bucket"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# 2. IAM Role: defines WHO can assume it (only EC2)
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

  tags = {
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# 3. Inline policy: defines WHAT the role can do (read-only, this bucket only)
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
          aws_s3_bucket.practice_bucket.arn,
          "${aws_s3_bucket.practice_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 4. Instance Profile: the bridge that lets EC2 use the Role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-read-profile"
  role = aws_iam_role.ec2_s3_read_role.name
}

# 5. Key pair
resource "aws_key_pair" "practice_key" {
  key_name   = "terraform-practice-key"
  public_key = "ssh-ed25519 AAAA...your-public-key-here"
}

# 6. Security Group
resource "aws_security_group" "practice_sg" {
  name        = "terraform-practice-sg"
  description = "Allow SSH only from my IP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR.IP.HERE/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "practice-sg"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# 7. EC2 instance — uses the Instance Profile, NO access keys anywhere
resource "aws_instance" "practice_server" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.practice_key.key_name
  vpc_security_group_ids = [aws_security_group.practice_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name        = "practice-server"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
