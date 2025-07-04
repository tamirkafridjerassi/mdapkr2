output "frontend_bucket" {
  value = aws_s3_bucket.frontend.bucket
}

output "logs_bucket" {
  value = aws_s3_bucket.logs.bucket
}
