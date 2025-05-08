variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the existing EC2 Key Pair to SSH into instance"
  type        = string
}

variable "bucket_name" {
  description = "Name for S3 bucket"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}