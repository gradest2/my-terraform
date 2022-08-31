data "terraform_remote_state" "ecs-cluster" {
  backend = "s3"
  config = {
    bucket               = "mgerasimov.terraform.backend"
    workspace_key_prefix = "terraform/infra/ECS-CLUSTER/ECS-CLUSTER-BEST"
    key                  = "terraform.tfstate"
    region               = "eu-central-1"
    profile              = "aws_profile"
  }
}
