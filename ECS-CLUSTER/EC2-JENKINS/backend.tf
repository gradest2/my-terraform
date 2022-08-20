terraform {
  backend "s3" {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-CLUSTER/EC2-JENKINS"
    region = "eu-central-1"
  }
}
