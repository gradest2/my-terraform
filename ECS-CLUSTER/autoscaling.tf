module "autoscaling" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-autoscaling?ref=v6.5.2"

  for_each = {
    light_one = {
      instance_type = "t2.micro"
    }
  }

  name = "${var.cluster_name}-${each.key}"

  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = each.value.instance_type

  security_groups                 = [aws_security_group.ecs-cluster-sg.id]
  user_data                       = base64encode(local.user_data)
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true
  iam_role_name               = "${var.cluster_name}-role"
  iam_role_description        = "ECS role for ${var.cluster_name}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type   = "EC2"
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = merge(
    var.tags,
    {
      AmazonECSManaged = true
    }
  )

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = true

  tags = merge(
    var.tags
  )
}
