output "aca_environment_id" {
  description = "ID del Azure Container Apps Environment"
  value       = azurerm_container_app_environment.this.id
}

output "aca_environment_default_domain" {
  description = "Dominio interno por defecto del Environment"
  value       = azurerm_container_app_environment.this.default_domain
}

output "aca_environment_static_ip" {
  description = "IP estática del Environment (si aplica)"
  value       = try(azurerm_container_app_environment.this.static_ip, null)
}
