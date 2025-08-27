output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
output "storage_container_name" {
  description = "El nombre del contenedor de almacenamiento"
  value       = azurerm_storage_container.terraform_state.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "storage_container_id" {
  value = azurerm_storage_container.terraform_state.id
}