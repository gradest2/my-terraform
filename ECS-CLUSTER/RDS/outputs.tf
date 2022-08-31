output "instance_id" {
  value       = module.rds.instance_id
  description = "ID of the instance"
}

output "instance_address" {
  value       = module.rds.instance_address
  description = "Address of the instance"
}

output "instance_endpoint" {
  value       = module.rds.instance_endpoint
  description = "DNS Endpoint of the instance"
}

output "subnet_group_id" {
  value       = module.rds.subnet_group_id
  description = "ID of the Subnet Group"
}

output "security_group_id" {
  value       = module.rds.security_group_id
  description = "ID of the Security Group"
}

output "parameter_group_id" {
  value       = module.rds.parameter_group_id
  description = "ID of the Parameter Group"
}

output "option_group_id" {
  value       = module.rds.option_group_id
  description = "ID of the Option Group"
}

output "hostname" {
  value       = module.rds.hostname
  description = "DNS host name of the instance"
}
