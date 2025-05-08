resource "aws_iam_user" "s3_uploader" {
  name = "${var.project_name}-airflow-s3-uploader"
}

resource "aws_iam_user_policy" "s3_policy" {
  name = "${var.project_name}-s3-access"
  user = aws_iam_user.s3_uploader.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:*"],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_uploader.name
}

