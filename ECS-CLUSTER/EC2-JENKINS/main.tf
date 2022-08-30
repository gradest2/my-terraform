provider "aws" {
  region = var.region
}

resource "aws_security_group" "sg_jenkins" {
  name        = "Jenkins Security Group"
  description = "Jenkins Security Group"
  vpc_id      = data.terraform_remote_state.net.outputs.vpc_id

  dynamic "ingress" {             #dynamic for ingress
    for_each = ["8080", "22"]     #cycle
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

  tags = merge(
    var.tags,
    {
      Name = "sg-jenkins"
    }
  )
}


resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = "t2.micro" #"t2.small"
  security_groups = [aws_security_group.sg_jenkins.id]
  subnet_id       = data.terraform_remote_state.net.outputs.public_subnets[0]
  user_data       = file("./script.tpl")
  key_name        = "standart"

  root_block_device {
    volume_type = "gp2"
    volume_size = 15
    tags = merge(
      var.tags,
      {
        Name = "Jenkins"
      }
    )
  }

  tags = merge(
    var.tags,
    {
      Name = "Jenkins"
    }
  )
}
