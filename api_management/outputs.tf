output "apim_id" {
  description = "The ID of the API Management instance."
  value       = azurerm_api_management.this.id
}

output "apim_name" {
  description = "The name of the API Management instance."
  value       = azurerm_api_management.this.name
}

output "apim_api_ids" {
  description = "The IDs of the APIs created in the API Management."
  value       = azurerm_api_management_api.this[*].id
}
