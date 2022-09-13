data "terraform_remote_state" "ecs-cluster" {
  backend = "s3"
  config = {
    bucket = "mgerasimov.terraform.backend"
    key    = "terraform/infra/ECS-CLUSTER/ECS-CLUSTER-BEST"
    region = "eu-central-1"
  }
}
