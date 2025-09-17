output "api_id" {
  description = "ID de la API creada en APIM"
  value       = azurerm_api_management_api.this.id
}

output "backend_id" {
  description = "ID del backend creado en APIM"
  value       = azurerm_api_management_backend.this.id
}

output "product_id" {
  description = "ID del product usado o creado"
  value       = local.product_id_effective
}

output "wildcard_operations_ids" {
  description = "Lista de operaciones comodín creadas"
  value       = [for o in azurerm_api_management_api_operation.wildcard : o.operation_id]
}
