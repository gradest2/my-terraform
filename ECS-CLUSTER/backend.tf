terraform {
  backend "s3" {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-CLUSTER-BEST"
    region = "eu-central-1"
  }
}
