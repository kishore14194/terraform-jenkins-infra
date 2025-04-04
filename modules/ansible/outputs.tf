output "ansible_node_worker_ip" {
  description = "Public IP address of Build Node"
  value       = aws_instance.ansible_node.public_ip
}
