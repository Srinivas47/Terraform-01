
# Create security group for instances
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.roobshop_vpc.id

  # Define ingress rules as needed
  # Example: Allow SSH and HTTP from anywhere
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

  # Add more rules as needed for your specific services
}

