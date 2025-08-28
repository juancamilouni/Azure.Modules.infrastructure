output "vnet_id" {
  description = "ID de la VNet"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Mapeo nombre => ID de subredes"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

