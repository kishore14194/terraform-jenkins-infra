output "build_node_worker_ip" {
  description = "Public IP address of Build Node"
  value       = aws_instance.build_node.public_ip
}
