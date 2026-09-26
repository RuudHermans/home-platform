output "vm_ip_address" {
  description = "IP-adres van de k3s-VM"
  value       = var.vm_ip_address
}

output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.k3s_server.vm_id
}
