output "sonar_nexus_ip" {
  description = "Public IP address of sonar-nexus Node"
  value       = aws_instance.sonar_nexus_node.public_ip
}
