module "vpc" {
  source              = "git::https://github.com/terraform-yc-modules/terraform-yc-vpc.git?ref=1.0.9"

  labels              = local.config.vpc.labels
  network_description = local.config.vpc.network_description
  network_name        = local.config.vpc.network_name
  create_vpc          = local.config.vpc.create_vpc

  public_subnets      = local.config.subnets.public_subnets
  private_subnets     = local.config.subnets.private_subnets
  create_sg           = local.config.subnets.create_sg
  create_nat_gw       = local.config.subnets.create_nat_gw
}