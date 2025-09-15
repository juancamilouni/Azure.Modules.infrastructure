output "apim_id" {
  description = "ID de la instancia de API Management"
  value       = azurerm_api_management.this.id
}

output "apim_name" {
  description = "Nombre de la instancia de API Management"
  value       = azurerm_api_management.this.name
}

output "apim_gateway_url" {
  description = "Gateway público (URL base)"
  value       = azurerm_api_management.this.gateway_url
}

output "product_id" {
  description = "Product ID (creado o referenciado)"
  value       = var.product_id
}

output "subscription_primary_key" {
  description = "Primary key de la suscripción (si se creó)"
  value       = var.create_subscription ? azurerm_api_management_subscription.sub[0].primary_key : null
  sensitive   = true
}

output "subscription_secondary_key" {
  description = "Secondary key de la suscripción (si se creó)"
  value       = var.create_subscription ? azurerm_api_management_subscription.sub[0].secondary_key : null
  sensitive   = true
}
