output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main_ec2.public_ip
}

output "bucket_name" {
  description = "Name of the S3 Bucket"
  value       = aws_s3_bucket.main_bucket.id
}