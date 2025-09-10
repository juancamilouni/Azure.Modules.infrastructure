output "container_app_id" {
  description = "ID de la Container App."
  value       = azurerm_container_app.this.id
}

output "container_app_fqdn" {
  description = "FQDN (si ingress está habilitado)."
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
}

output "principal_id" {
  description = "Principal ID de la identidad de la App."
  value       = try(azurerm_container_app.this.identity[0].principal_id, null)
}
