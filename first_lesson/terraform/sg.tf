resource "aws_security_group" "sg_jenkins" {
  name        = "JenkinsSG"
  description = "JenkinsSG"

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


resource "aws_security_group" "mysql_sg" {
  name        = "MySQLSG"
  description = "MySQLSG"

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
