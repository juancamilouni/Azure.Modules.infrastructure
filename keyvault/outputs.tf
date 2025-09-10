output "key_vault_id" {
  description = "Resource ID del Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "key_vault_uri" {
  description = "URI del Key Vault (https://<name>.vault.azure.net/)"
  value       = azurerm_key_vault.kv.vault_uri
}
