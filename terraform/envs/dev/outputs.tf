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