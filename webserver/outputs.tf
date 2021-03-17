output "webserver_public_ip" {
  value       = aws_eip.webserver_static_ip.public_ip
  description = "IP adress for WebServer"
}

output "webserver_instance_type" {
  value       = aws_instance.webserver.instance_type
  description = "WebServer Instance Type"
}

output "latest_ubuntu_ami_id" {
  value       = data.aws_ami.latest_ubuntu.id
  description = "Latest Ubuntu AMI"
}

output "latest_ubuntu_ami_name" {
  value       = data.aws_ami.latest_ubuntu.name
  description = "Latest Ubuntu Name"
}
