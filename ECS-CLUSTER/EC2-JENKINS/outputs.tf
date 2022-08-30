output "latest_jenkins_ami_id" {
  value       = data.aws_ami.latest_ubuntu.id
  description = "Latest Ubuntu AMI"
}

output "latest_jenkins_ami_name" {
  value       = data.aws_ami.latest_ubuntu.name
  description = "Latest Ubuntu Name"
}
