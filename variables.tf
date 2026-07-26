variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1b"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  default     = "kkk-devops-project-bucket-2026"
}