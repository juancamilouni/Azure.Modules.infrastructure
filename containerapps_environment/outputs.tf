output "container_app_id" {
  description = "ID de la Container App"
  value       = azurerm_container_app.app.id
}

output "container_app_fqdn" {
  description = "FQDN del ingress (si es externo) o null"
  value       = try(azurerm_container_app.app.ingress[0].fqdn, null)
}
