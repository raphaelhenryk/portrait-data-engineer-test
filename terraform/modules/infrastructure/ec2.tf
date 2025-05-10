# EC2 Instance
resource "aws_instance" "main_ec2" {
  #count         = length(var.availability_zones)
  ami           = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS in us-east-1
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = var.key_pair_name
  security_groups = [aws_security_group.main_sg.id]

  #user_data = file("${path.module}/user_data.sh")

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    aws_access_key_id     = aws_iam_access_key.s3_user_key.id
    aws_secret_access_key = aws_iam_access_key.s3_user_key.secret
    bucket_name           = var.bucket_name
    environment           = var.environment
  })

  tags = {
    Name = "${var.project_name}-ec2"
  }
}