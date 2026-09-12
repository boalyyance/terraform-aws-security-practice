variable "bucket_name" {
  description = "Unique S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment tag (Learning, Dev, Prod, etc.)"
  type        = string
  default     = "Learning"
}
