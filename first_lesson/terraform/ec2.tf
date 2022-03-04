#ec2 with jenkins
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  security_groups = [aws_security_group.jenkins.id]

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name  = "Jenkins"
    Owner = "Mikhail Gerasimov"
  }
}

#ec2 with mysql
resource "aws_instance" "mysql" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  security_groups = [aws_security_group.mysql.id]

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name  = "MySQL"
    Owner = "Mikhail Gerasimov"
  }
}
