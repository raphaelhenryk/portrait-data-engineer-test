output "environment" {
  description = "Project environment"
  value       = var.environment
}


output "aws_access_key_id" {
  value     = module.infrastructure.aws_access_key_id
  sensitive = true
}

output "aws_secret_access_key" {
  value     = module.infrastructure.aws_secret_access_key
  sensitive = true
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.infrastructure.ec2_public_ip
}