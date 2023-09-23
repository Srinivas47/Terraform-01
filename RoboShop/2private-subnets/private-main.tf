
# Create EC2 instances in the private subnet (App-tier)
resource "aws_instance" "private_app_instances" {
  count         = 6
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_tier_subnet.id

  # Tags for instances
  tags = {
    Name = element(["USER", "CATALOG", "SHIPPING", "RATING", "PAYMENTS", "CART"], count.index)
  }

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}

# Create a private subnet route table
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.roobshop_vpc.id
  tags = {
    Name = "Private Subnet Route Table"
  }
}

# Associate the private subnet (App-tier) with the route table
resource "aws_route_table_association" "app_subnet_association" {
  subnet_id      = aws_subnet.app_tier_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

# Create a second private subnet (db_tier)
resource "aws_subnet" "db_tier_subnet" {
  vpc_id                  = aws_vpc.roobshop_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false
  tags = {
    Name = "db_tier"
  }
}

# Create EC2 instances in the db_tier subnet
resource "aws_instance" "db_instances" {
  count         = 4
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.db_tier_subnet.id

  # Tags for instances
  tags = {
    Name = element(["MONGODB", "MYSQL", "REDIS", "RABBITMQ"], count.index)
  }

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}

# Associate the private subnet (Db-tier) with the route table
resource "aws_route_table_association" "Db_subnet_association" {
  subnet_id      = aws_subnet.db_tier_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

