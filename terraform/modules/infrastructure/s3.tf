# S3 Bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.project_name}-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}