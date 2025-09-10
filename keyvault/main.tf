resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  # ← Usa las variables declaradas
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # Nombre correcto del atributo en el provider azurerm 3.x
  enable_rbac_authorization = var.rbac_authorization_enabled

  public_network_access_enabled = var.public_network_access_enabled

  # No mezclar RBAC con access_policy
  # access_policy { ... }  # ← eliminar si usas RBAC

  tags = var.tags
}
