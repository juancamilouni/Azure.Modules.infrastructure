output "application_gateway_id" {
  description = "ID del Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "application_gateway_frontend_ip" {
  description = "IP pública del Application Gateway"
  value       = azurerm_public_ip.this.ip_address
}
