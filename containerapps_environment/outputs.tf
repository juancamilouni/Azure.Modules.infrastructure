output "container_app_id" {
  description = "ID de la Container App"
  value       = azurerm_container_app.app.id
}

output "container_app_fqdn" {
  description = "FQDN público si el ingreso es externo"
  value       = try(azurerm_container_app.app.latest_revision_fqdn, null)
}
