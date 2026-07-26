terraform {
  backend "s3" {
    bucket       = "kkk-terraform-state-bucket-2026"
    key          = "devops-project/terraform.tfstate"
    region       = "ap-south-1b"
    dynamodb_table = "kkk-terraform-state-bucket-2026"

  }
}
provider "aws" {
  region = var.aws_region
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = "ami-0e38835daf6b8a2b9" # Amazon Linux 2 - ap-south-1b
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Deployed via Terraform by KKK</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "DevOps-Practice-Server"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "project_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "DevOps-Practice-Bucket1"
  }
}
