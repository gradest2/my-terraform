output "latest_ubuntu_ami_id" {
  value       = data.aws_ami.latest_ubuntu.id
  description = "Latest Ubuntu AMI"
}

output "latest_ubuntu_ami_name" {
  value       = data.aws_ami.latest_ubuntu.name
  description = "Latest Ubuntu Name"
}

output "web_loadbalancer_url" {
  value       = aws_elb.webserver.dns_name
  description = "Adress for WebServer"
}
