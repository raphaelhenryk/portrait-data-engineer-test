variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "key_pair_name" {
  description = "Key Pair name for SSH"
  type        = string
}

variable "bucket_name" {
  description = "S3 Bucket name"
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

variable "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  type        = string
}