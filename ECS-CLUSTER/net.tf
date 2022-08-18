resource "aws_vpc" "ecs-cluster-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "ecs-cluster-vpc"
  }
}


## Cluster Private Network ##

resource "aws_subnet" "ecs-cluster-subnet-1a" {
  vpc_id                  = aws_vpc.ecs-cluster-vpc.id
  availability_zone       = "eu-central-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-cluster-subnet-1a"
  }
}


resource "aws_subnet" "ecs-cluster-subnet-1b" {
  vpc_id                  = aws_vpc.ecs-cluster-vpc.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-cluster-subnet-1b"
  }
}


resource "aws_subnet" "ecs-cluster-subnet-1c" {
  vpc_id                  = aws_vpc.ecs-cluster-vpc.id
  availability_zone       = "eu-central-1c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-cluster-subnet-1c"
  }
}


resource "aws_internet_gateway" "ecs-cluster-igw" {
  vpc_id = aws_vpc.ecs-cluster-vpc.id

  tags = {
    Name = "ecs-cluster-igw"
  }
}


resource "aws_route_table" "ecs-cluster-rtb" {
  vpc_id = aws_vpc.ecs-cluster-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-cluster-igw.id
  }


  tags = {
    Name = "ecs-cluster-rtb"
  }
}


resource "aws_route_table_association" "ecs-cluster-rtb-association-1a" {
  subnet_id      = aws_subnet.ecs-cluster-subnet-1a.id
  route_table_id = aws_route_table.ecs-cluster-rtb.id
}

resource "aws_route_table_association" "ecs-cluster-rtb-association-1b" {
  subnet_id      = aws_subnet.ecs-cluster-subnet-1b.id
  route_table_id = aws_route_table.ecs-cluster-rtb.id
}

resource "aws_route_table_association" "ecs-cluster-rtb-association-1c" {
  subnet_id      = aws_subnet.ecs-cluster-subnet-1c.id
  route_table_id = aws_route_table.ecs-cluster-rtb.id
}
