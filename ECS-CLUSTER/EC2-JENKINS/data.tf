data "aws_ami" "latest_jenkins" {
  owners      = ["901576725721"] #my account for jenkins AMI
  most_recent = true             #always latest version
  filter {
    name   = "name" #filter by Ubuntu name
    values = ["Jenkins*"]
  }
}

data "terraform_remote_state" "net" {
  backend = "s3"
  config = {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-CLUSTER/net"
    region = "eu-central-1"
  }
}
