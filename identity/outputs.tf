output "uami_id" {
  description = "ID completo de la identidad (para adjuntar a la App)"
  value       = azurerm_user_assigned_identity.uami.id
}

output "uami_principal_id" {
  description = "Object ID (para asignaciones de rol RBAC)"
  value       = azurerm_user_assigned_identity.uami.principal_id
}
