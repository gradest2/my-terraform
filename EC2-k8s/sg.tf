resource "aws_security_group" "k8s-master-sg" {
  name        = "k8s-master-sg"
  description = "k8s-master-sg"
  vpc_id      = "vpc-0a389fcc3c576fe9a"

  ingress {
    description = "ALL access"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                               = "k8s-master-sg"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}


resource "aws_security_group" "k8s-worker-sg" {
  name        = "k8s-worker-sg"
  description = "k8s-worker-sg"
  vpc_id      = "vpc-0a389fcc3c576fe9a"

  ingress {
    description = "ALL access"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                               = "k8s-worker-sg"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
