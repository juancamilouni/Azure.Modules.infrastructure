output "public_ip_id" {
  description = "ID de la IP pública creada"
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "Dirección IP pública asignada"
  value       = azurerm_public_ip.this.ip_address
}
