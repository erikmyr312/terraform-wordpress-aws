############################################
# Outputs
# Helpful values to verify the deployment.
############################################
output "wordpress_public_ip" {
  description = "Public IP address of the WordPress EC2 instance"
  value       = aws_instance.wordpress_ec2.public_ip
}

output "wordpress_blog_url" {
  description = "URL to WordPress installer page"
  value       = "http://${aws_instance.wordpress_ec2.public_ip}/blog"
}
