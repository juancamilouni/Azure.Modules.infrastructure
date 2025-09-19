output "container_app_id" {
  description = "ID de la Container App"
  value       = azurerm_container_app.this.id
}

output "container_app_fqdn" {
  description = "FQDN (si ingress externo) o null"
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
}

output "principal_id" {
  description = "Object ID de la identidad (System Assigned) de la App"
  value       = try(azurerm_container_app.this.identity[0].principal_id, null)
}
