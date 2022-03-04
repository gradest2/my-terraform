#ec2 with jenkins
resource "aws_instance" "jenkins" {
  user_data     = "jenkins.tpl"
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.sg_jenkins.id]

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
  user_data     = "mysql.tpl"
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name  = "MySQL"
    Owner = "Mikhail Gerasimov"
  }
}
