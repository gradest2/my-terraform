provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "sg_webserver" {
  name        = "Webserver Security Group"
  description = "Webserver Security Group"

  dynamic "ingress" {             #dynamic for ingress
    for_each = ["80", "443"]      #cycle
    content {                     #content for ingress
      from_port   = ingress.value #parameters from cycle
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer"
    Owner = "Mikhail Gerasimov"
  }
}

resource "aws_eip" "webserver_static_ip" {
  instance = aws_instance.webserver.id

  tags = {
    Name  = "WebServer Static IP"
    Owner = "Mikhail Gerasimov"
  }
}

resource "aws_instance" "webserver" {
  #count                  = 1
  ami                    = "ami-0767046d1677be5a0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_webserver.id] # Attachment SG
  #user_data              = file("script") #copy paste file
  user_data = templatefile("script.tpl", {
    f_name = "Mikhail",
    l_name = "Gerasimov",
    names  = ["Vasya", "Olya", "Petya", "Alyona"]
  })

  tags = {
    Name    = "WebServer"
    Owner   = "Mikhail Gerasimov"
    Project = "Terraform Lessons"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }

  lifecycle {
    #prevent_destroy = true #instance can't be destroyed
    #ignore_changes = ["ami", "instnce_type"]
    create_before_destroy = true
  }

}
