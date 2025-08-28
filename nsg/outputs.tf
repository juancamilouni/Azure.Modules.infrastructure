output "nsg_subnet1_id" {
  description = "ID del NSG asociado a la Subnet 1"
  value       = azurerm_network_security_group.subnet1.id
}

output "nsg_subnet2_id" {
  description = "ID del NSG asociado a la Subnet 2"
  value       = azurerm_network_security_group.subnet2.id
}

output "nsg_subnet3_id" {
  description = "ID del NSG asociado a la Subnet 3"
  value       = azurerm_network_security_group.subnet3.id
}

output "nsg_subnet4_id" {
  description = "ID del NSG asociado a la Subnet 4"
  value       = azurerm_network_security_group.subnet4.id
}
