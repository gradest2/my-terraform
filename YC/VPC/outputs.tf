output "vpc_id" {
  description = "ID of the created network for internal communications from VPC module"
  value       = module.vpc.vpc_id
}

output "vpc_public_v4_cidr_blocks" {
  description = "List of `v4_cidr_blocks` used in the VPC network from the VPC module"
  value       = module.vpc.public_v4_cidr_blocks
}

output "vpc_public_subnets" {
  description = "Public subnets from the VPC module"
  value       = module.vpc.public_subnets
}

output "vpc_private_v4_cidr_blocks" {
  description = "List of `v4_cidr_blocks` used in the VPC network from the VPC module"
  value       = module.vpc.private_v4_cidr_blocks
}

output "vpc_private_subnets" {
  description = "Private subnets from the VPC module"
  value       = module.vpc.private_subnets
}

output "vpc_s3_private_endpoint_id" {
  description = "S3 Private Endpoint ID from the VPC module"
  value       = module.vpc.s3_private_endpoint_id
}

output "vpc_s3_private_endpoint_ip" {
  description = "S3 Private Endpoint IP address from the VPC module"
  value       = module.vpc.s3_private_endpoint_ip
}

output "sg_ids" {
  description = "SG IDs"
  value = {
    for key, sg in yandex_vpc_security_group.dynamic-sg : key => sg.id
  }
}
