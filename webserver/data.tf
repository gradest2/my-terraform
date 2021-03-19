data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"] #public account for ubuntu AMI
  most_recent = true             #always latest version
  filter {
    name   = "name" #filter by Ubuntu name
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_availability_zones" "available" {}
