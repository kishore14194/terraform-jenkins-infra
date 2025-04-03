output "jenkins_public_ip" {
  description = "Public IP address of Jenkins"
  value       = aws_instance.jenkins.public_ip
}
