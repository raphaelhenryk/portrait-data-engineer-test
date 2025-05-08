module "infrastructure" {
  source = "../../modules/infrastructure"
  project_name  = var.project_name
  key_pair_name = var.key_pair_name
  bucket_name   = var.bucket_name
  aws_region    = var.aws_region
  instance_type = var.instance_type
  environment   = var.environment
}