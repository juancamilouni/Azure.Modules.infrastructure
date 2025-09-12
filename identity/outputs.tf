output "uami_resource_id" {
  description = "Resource ID de la UAMI (para asociar en Container Apps, VM, etc.)"
  value       = azurerm_user_assigned_identity.uami.id
}

output "uami_principal_id" {
  description = "Object ID de la UAMI (para usar en asignaciones de rol)"
  value       = azurerm_user_assigned_identity.uami.principal_id
}
