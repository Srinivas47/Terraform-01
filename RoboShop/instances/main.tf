# Create EC2 instances in the private subnet
resource "aws_instance" "private_instances" {
  count         = 6
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.db_subnet.id

  # Tags for instances
  tags = {
    Name = element(["USER", "CATALOG", "SHIPPING", "RATING", "PAYMENTS", "CART"], count.index)
  }

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}
