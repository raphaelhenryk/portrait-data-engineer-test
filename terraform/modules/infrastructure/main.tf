# VPC
variable "availability_zones" {
  default = ["us-east-1a"]
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subnet
resource "aws_subnet" "main_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Route Table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "main_route_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# Security Group
resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "${var.project_name}-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Airflow UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

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


# EC2 Instance
resource "aws_instance" "main_ec2" {
  count         = length(var.availability_zones)
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