output "public_ip_id" {
  description = "ID de la IP pública"
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "Dirección IP pública"
  value       = azurerm_public_ip.this.ip_address
}
