output "k8s_master_ip" {
  description = "Public IP address of Build Node"
  value       = aws_instance.k8s_master.public_ip
}
