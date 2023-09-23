
# Configure the AWS provider
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create a VPC
resource "aws_vpc" "roobshop_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Roobshop-vpc"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "roobshop_igw" {
  vpc_id = aws_vpc.roobshop_vpc.id
  tags = {
    Name = "Roboshop-igw"
  }
}


