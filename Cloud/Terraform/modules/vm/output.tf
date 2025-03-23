# Output the VM IP addresses
output "vm_internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "vm_external_ip" {
  value = var.allow_public_ip ? google_compute_instance.vm.network_interface[0].access_config[0].nat_ip : "No external IP"
}