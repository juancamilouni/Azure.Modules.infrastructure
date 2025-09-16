output "api_id" {
  description = "ID de la API creada"
  value       = azurerm_api_management_api.this.id
}

output "backend_id" {
  description = "ID del backend"
  value       = azurerm_api_management_backend.this.id
}

output "product_id" {
  description = "ID del product"
  value       = azurerm_api_management_product.plan.product_id
}

output "wildcard_operations_ids" {
  description = "IDs de operaciones comodín creadas"
  value       = [for o in azurerm_api_management_api_operation.wildcard : o.operation_id]
}
