provider "aws" {
  region = var.region
}

module "alb" {
  source = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=1.4.0"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace = "alb"
  stage     = "dev"
  name      = "ecs-cluster-best"
  #  attributes = var.attributes
  #  delimiter  = var.delimiter

  vpc_id              = data.terraform_remote_state.net.outputs.vpc_id
  security_group_ids  = [aws_security_group.alb-sg.id]
  subnet_ids          = data.terraform_remote_state.net.outputs.public_subnets
  access_logs_enabled = false
  #  internal                          = var.internal
  #  http_enabled                      = var.http_enabled
  #  http_redirect                     = var.http_redirect
  #  cross_zone_load_balancing_enabled = var.cross_zone_load_balancing_enabled
  #  http2_enabled                    = var.http2_enabled
  #  idle_timeout                     = var.idle_timeout
  #  ip_address_type                  = var.ip_address_type
  #  deletion_protection_enabled      = var.deletion_protection_enabled
  #  deregistration_delay             = var.deregistration_delay
  # health_check_path                = var.health_check_path
  # health_check_timeout             = var.health_check_timeout
  # health_check_healthy_threshold   = var.health_check_healthy_threshold
  # health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  # health_check_interval            = var.health_check_interval
  # health_check_matcher             = var.health_check_matcher
  # target_group_port                = var.target_group_port
  # target_group_target_type         = var.target_group_target_type
  # stickiness                       = var.stickiness

  # alb_access_logs_s3_bucket_force_destroy         = var.alb_access_logs_s3_bucket_force_destroy
  # alb_access_logs_s3_bucket_force_destroy_enabled = var.alb_access_logs_s3_bucket_force_destroy_enabled

  tags = var.tags
}
