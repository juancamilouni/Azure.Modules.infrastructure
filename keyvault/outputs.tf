output "key_vault_id" {
  description = "Resource ID del Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "URI del Key Vault (https://<name>.vault.azure.net/)"
  value       = azurerm_key_vault.this.vault_uri
}

output "certificate_id" {
  description = "ID del certificado dentro del Key Vault"
  value       = try(azurerm_key_vault_certificate.ssl[0].id, null)
}
