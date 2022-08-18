provider "aws" {
  region = var.region
}

locals {
  user_data = <<-EOT
    #!/bin/bash
    cat <<'EOF' >> /etc/ecs/ecs.config
    ECS_CLUSTER=${var.cluster_name}
    ECS_LOGLEVEL=debug
    EOF
  EOT
}

module "ecs" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs?ref=v4.1.1"

  cluster_name = var.cluster_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  autoscaling_capacity_providers = {
    light_one = {
      auto_scaling_group_arn         = aws_autoscaling_group.bar.arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "EcsEc2"
  }
}


# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}


resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = "t2.micro"
  key_name      = "standart"
  user_data     = base64encode(local.user_data)
}

resource "aws_autoscaling_group" "bar" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.ecs-cluster-subnet-1a.id,
    aws_subnet.ecs-cluster-subnet-1b.id,
    aws_subnet.ecs-cluster-subnet-1c.id
  ]

  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}
