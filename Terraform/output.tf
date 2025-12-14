output "ec2_public_ip" {
  description = "Public IP address of the Strapi EC2 instance"
  value       = aws_instance.strapi_ec2.public_ip
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.strapi_ec2.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.strapi_ec2.public_ip}"
}

output "strapi_url" {
  description = "URL to access Strapi application"
  value       = "http://${aws_instance.strapi_ec2.public_ip}:1337"
}

output "strapi_admin_url" {
  description = "URL to access Strapi Admin Panel"
  value       = "http://${aws_instance.strapi_ec2.public_ip}:1337/admin"
}