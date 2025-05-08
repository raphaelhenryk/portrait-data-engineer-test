output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main_ec2.public_ip
}

output "bucket_name" {
  description = "Name of the S3 Bucket"
  value       = aws_s3_bucket.main_bucket.id
}

output "environment" {
  description = "Project environment"
  value       = var.environment
}

output "aws_access_key_id" {
  value     = aws_iam_access_key.s3_user_key.id
  sensitive = true
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.s3_user_key.secret
  sensitive = true
}
