# Define variables
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

# Create a public subnet (web-Tier)
resource "aws_subnet" "web_tier_subnet" {
  vpc_id                  = aws_vpc.roobshop_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "web-Tier"
  }
}

# Create a private subnet (App-tier)
resource "aws_subnet" "app_tier_subnet" {
  vpc_id                  = aws_vpc.roobshop_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false
  tags = {
    Name = "App-tier"
  }
}


# # Create EC2 instances in the private subnet (App-tier)
# resource "aws_instance" "private_app_instances" {
#   count         = 6
#   ami           = var.ami_id
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.app_tier_subnet.id

#   # Tags for instances
#   tags = {
#     Name = element(["USER", "CATALOG", "SHIPPING", "RATING", "PAYMENTS", "CART"], count.index)
#   }

#   # Attach the security group
#   vpc_security_group_ids = [aws_security_group.instance_sg.id]
# }

# # # Create a private subnet route table
# # resource "aws_route_table" "private_subnet_route_table" {
# #   vpc_id = aws_vpc.roobshop_vpc.id
# #   tags = {
# #     Name = "Private Subnet Route Table"
# #   }
# # }

# # # Associate the private subnet (App-tier) with the route table
# # resource "aws_route_table_association" "app_subnet_association" {
# #   subnet_id      = aws_subnet.app_tier_subnet.id
# #   route_table_id = aws_route_table.private_subnet_route_table.id
# # }

# # Create a second private subnet (db_tier)
# resource "aws_subnet" "db_tier_subnet" {
#   vpc_id                  = aws_vpc.roobshop_vpc.id
#   cidr_block              = "10.0.3.0/24"
#   availability_zone       = "${var.aws_region}c"
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "db_tier"
#   }
# }

# # Create EC2 instances in the db_tier subnet
# resource "aws_instance" "db_instances" {
#   count         = 4
#   ami           = var.ami_id
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.db_tier_subnet.id

#   # Tags for instances
#   tags = {
#     Name = element(["MONGODB", "MYSQL", "REDIS", "RABBITMQ"], count.index)
#   }

#   # Attach the security group
#   vpc_security_group_ids = [aws_security_group.instance_sg.id]
# }

# Create a public subnet route table
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.roobshop_vpc.id
  tags = {
    Name = "Public Subnet Route Table"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "roobshop_igw" {
  vpc_id = aws_vpc.roobshop_vpc.id
  tags = {
    Name = "Roboshop-igw"
  }
}

# Create a NAT gateway in the public subnet (web-Tier)
resource "aws_nat_gateway" "roobshop_natgateway" {
  allocation_id = aws_eip.roobshop_eip.id
  subnet_id     = aws_subnet.web_tier_subnet.id
  tags = {
    Name = "Roboshop-natgateway"
  }
}

# Create an Elastic IP for the NAT gateway
resource "aws_eip" "roobshop_eip" {}


  
  
  

  