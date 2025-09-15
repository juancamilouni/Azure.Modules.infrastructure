output "apim_id" {
  description = "ID de la instancia de API Management"
  value       = azurerm_api_management.this.id
}

output "apim_name" {
  description = "Nombre de la instancia de API Management"
  value       = azurerm_api_management.this.name
}
