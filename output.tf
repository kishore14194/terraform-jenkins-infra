# Fetch module outputs
output "jenkins_ip" {
  value = module.jenkins.jenkins_public_ip
}

output "build_node_ip" {
  value = module.build_node.build_node_worker_ip
}

output "ansible_node_ip" {
  value = module.ansible.ansible_node_worker_ip
}