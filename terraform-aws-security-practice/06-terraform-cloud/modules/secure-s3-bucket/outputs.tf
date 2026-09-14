output "bucket_arn" {
  description = "ARN of the created bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "ID (name) of the created bucket"
  value       = aws_s3_bucket.this.id
}
