output "acr_id" {
  description = "ID del Registro de Contenedores"
  value       = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  description = "Servidor de inicio de sesión del Registro de Contenedores"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Nombre de usuario administrador (si está habilitado)"
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_username : null
}


