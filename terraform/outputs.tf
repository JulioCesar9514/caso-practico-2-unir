# Valores de salida que mostrara terraform al finalizar 
# la aplicacion de la infraestructura
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}
output "vm_public_ip" {
  description = "IP pública de la VM"
  value       = azurerm_public_ip.vm_pip.ip_address
}

# Crea automaticament el archivo hosts.ini de ansible con la ip publica de la vm
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/hosts.ini"
  content  = <<-EOT
    # Generado automaticamente por Terraform - NO editar a mano.
    [podman_vm]
    cp2-vm ansible_host=${azurerm_public_ip.vm_pip.ip_address}

    [podman_vm:vars]
    ansible_user=${var.vm_admin_username}
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
}

# Crea automaticamente group_vars/all.yml con credenciales del ACR
resource "local_file" "ansible_group_vars" {
  filename = "${path.module}/../ansible/group_vars/all.yml"
  content  = <<-EOT
    # Archivo generado automaticamente por Terraform - NO editar a mano.
    acr_login_server: "${azurerm_container_registry.acr.login_server}"
    acr_username: "${azurerm_container_registry.acr.admin_username}"
    acr_password: "${azurerm_container_registry.acr.admin_password}"
    image_tag: "casopractico2"
  EOT
}
