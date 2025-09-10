resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 30
  purge_protection_enabled   = true

  #  Nombre correcto en azurerm 3.x
  enable_rbac_authorization = true

  # (Opcional y soportado en 3.x+)
  public_network_access_enabled = true

  # 🔕 Quita los access_policy si usas RBAC
  # access_policy { ... }  # <-- eliminar

  tags = var.tags

  # (Opcional) algunos habilitan esto porque Azure a veces “toca” el flag:
  # lifecycle {
  #   ignore_changes = [ enable_rbac_authorization ]
  # }
}
