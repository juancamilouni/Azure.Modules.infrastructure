output "swa_id" {
  description = "ID de la Static Web App"
  value       = azurerm_static_web_app.swa.id
}

output "swa_default_host" {
  description = "Hostname público por defecto"
  value       = azurerm_static_web_app.swa.default_host_name
}

output "swa_principal_id" {
  description = "Principal ID si la identidad administrada está habilitada"
  value       = try(azurerm_static_web_app.swa.identity[0].principal_id, null)
}
