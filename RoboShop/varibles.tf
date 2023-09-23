# Define varibles 

variable "aws_region" {
  default = "us-east-1" # Specify your desired AWS region
}


variable "ami_id" {
  description = "The ID of the desired AMI"
  # You can set a default value here or pass it when running Terraform
}

variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}