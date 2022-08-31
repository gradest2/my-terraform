data "terraform_remote_state" "net" {
  backend = "s3"
  config = {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-CLUSTER/net"
    region = "eu-central-1"
  }
}
