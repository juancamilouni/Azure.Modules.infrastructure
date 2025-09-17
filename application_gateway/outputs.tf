output "application_gateway_id" {
  description = "ID del Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "application_gateway_public_ip" {
  description = "Dirección IP pública del Application Gateway"
  value       = azurerm_public_ip.this.ip_address
}
