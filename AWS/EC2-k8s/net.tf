resource "aws_vpc" "k8s-cluster-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name                               = "k8s-cluster-vpc"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}


resource "aws_subnet" "k8s-cluster-subnet" {
  vpc_id                  = aws_vpc.k8s-cluster-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name                               = "k8s-cluster-subnet"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}


resource "aws_internet_gateway" "k8s-cluster-igw" {
  vpc_id = aws_vpc.k8s-cluster-vpc.id

  tags = {
    Name                               = "k8s-cluster-igw"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}


resource "aws_route_table" "k8s-cluster-rtb" {
  vpc_id = aws_vpc.k8s-cluster-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s-cluster-igw.id
  }


  tags = {
    Name                               = "k8s-cluster-rtb"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}


resource "aws_route_table_association" "k8s-cluster-rtb-association" {
  subnet_id      = aws_subnet.k8s-cluster-subnet.id
  route_table_id = aws_route_table.k8s-cluster-rtb.id
}
