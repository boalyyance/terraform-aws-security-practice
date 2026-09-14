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

# 1. Register the public SSH key with AWS
resource "aws_key_pair" "practice_key" {
  key_name   = "terraform-practice-key"
  public_key = "ssh-ed25519 AAAA...your-public-key-here"
}

# 2. Security Group — SSH allowed ONLY from a single whitelisted IP
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

# 3. EC2 instance
resource "aws_instance" "practice_server" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.practice_key.key_name
  vpc_security_group_ids = [aws_security_group.practice_sg.id]

  tags = {
    Name        = "practice-server"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
