resource "aws_vpc" "backend" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "backend-vpc"
  }
}

resource "aws_subnet" "public_backend1" {
  vpc_id     = aws_vpc.backend.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-backend1"
  }
}

resource "aws_subnet" "public_backend2" {
  vpc_id     = aws_vpc.backend.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_backend2"
  }
}

// TODO gateway 作る
resource "aws_internet_gateway" "backend" {
  vpc_id = aws_vpc.backend.id

  tags = {
    Name = "backend"
  }
}

resource "aws_route_table" "backend" {
  vpc_id = aws_vpc.backend.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.backend.id
  }

  tags = {
    Name = "backend"
  }
}

resource "aws_route_table_association" "backend1" {
  subnet_id      = aws_subnet.public_backend1.id
  route_table_id = aws_route_table.backend.id
}

resource "aws_route_table_association" "backend2" {
  subnet_id      = aws_subnet.public_backend2.id
  route_table_id = aws_route_table.backend.id
}

