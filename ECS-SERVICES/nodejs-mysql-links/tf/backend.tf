terraform {
  backend "s3" {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-SERVICES/nodejs-mysql-links"
    region = "eu-central-1"
  }
}
