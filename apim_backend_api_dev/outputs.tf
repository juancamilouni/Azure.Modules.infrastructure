output "api_id" {
  description = "ID de la API"
  value       = azurerm_api_management_api.this.id
}

output "backend_id" {
  description = "ID del backend"
  value       = azurerm_api_management_backend.this.id
}
