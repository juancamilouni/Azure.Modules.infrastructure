resource "azurerm_role_assignment" "this" {
  scope                            = var.scope
  role_definition_id               = var.role_definition_id
  principal_id                     = var.principal_id
  skip_service_principal_aad_check = true
}
