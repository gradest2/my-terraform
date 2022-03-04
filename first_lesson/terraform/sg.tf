resource "aws_security_group" "jenkins" {
  name        = "Jenkins SG"
  description = "Jenkins SG"

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    Name = "jenkins_sg"
  }
}


resource "aws_security_group" "mysql" {
  name        = "MySQL SG"
  description = "MySQL SG"

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    Name = "mysql_sg"
  }
}
