# 1. Ansible Control Node Public IP
output "control_node_public_ip" {
  description = "The public IP of the Ansible Control Node"
  value       = google_compute_instance.ansible_ubuntu.network_interface.0.access_config.0.nat_ip
}

# 2. Managed Ubuntu Nodes Public IPs
output "ubuntu_hosts_public_ips" {
  description = "The public IPs of the managed Ubuntu nodes"
  value       = google_compute_instance.ubuntu_hosts[*].network_interface.0.access_config.0.nat_ip
}

# 3. Managed RHEL Node Public IP
output "rhel_host_public_ip" {
  description = "The public IP of the managed RHEL node"
  value       = google_compute_instance.rhel_hosts.network_interface.0.access_config.0.nat_ip
}

# 4. Internal IPs (Useful for Ansible communication)
output "control_node_internal_ip" {
  description = "The internal IP of the Control Node"
  value       = google_compute_instance.ansible_ubuntu.network_interface.0.network_ip
}
