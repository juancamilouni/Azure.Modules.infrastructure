output "resource_group_ids" {
  description = "Mapa nombre -> ID de cada Resource Group creado."
  value       = { for name, rg in azurerm_resource_group.this : name => rg.id }
}

output "resource_group_locations" {
  description = "Mapa nombre -> ubicación final de cada Resource Group."
  value       = { for name, rg in azurerm_resource_group.this : name => rg.location }
}

output "resource_group_names" {
  description = "Lista de nombres efectivamente creados."
  value       = keys(azurerm_resource_group.this)
}
