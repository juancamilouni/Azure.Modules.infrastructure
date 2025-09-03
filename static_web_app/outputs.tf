output "swa_id" {
  description = "ID del Static Web App"
  value       = azurerm_static_site.swa.id
}

output "swa_default_host" {
  description = "Hostname público por defecto (para usar como backend del AGW)"
  value       = azurerm_static_site.swa.default_host_name
}

output "swa_principal_id" {
  description = "Principal ID de la identidad administrada (si está habilitada)"
  value       = try(azurerm_static_site.swa.identity[0].principal_id, null)
}
