terraform {
  backend "s3" {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-CLUSTER/net"
    region = "eu-central-1"
  }
}
