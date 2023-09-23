# Create a public subnet
resource "aws_subnet" "app_tier_subnet" {
  vpc_id                  = aws_vpc.roobshop_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "App-Tier"
  }
}


#Create a public subnet route table
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.roobshop_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.roobshop_igw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}

# Create a NAT gateway in the public subnet
resource "aws_nat_gateway" "roobshop_natgateway" {
  allocation_id = aws_eip.roobshop_eip.id
  subnet_id     = aws_subnet.app_tier_subnet.id
  tags = {
    Name = "Roboshop-natgateway"
  }
}

# Create an Elastic IP for the NAT gateway
resource "aws_eip" "roobshop_eip" {}


