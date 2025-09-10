resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # RBAC en lugar de access policies
  rbac_authorization_enabled = var.rbac_authorization_enabled

  # Red (ajústalo cuando metas Private Endpoint / reglas de firewall)
  public_network_access_enabled = var.public_network_access_enabled
  # Opcional: establecer firewall estricto
  # network_acls {
  #   bypass         = "AzureServices"
  #   default_action = "Deny"
  #   ip_rules       = []      # Lista de IPs si necesitas
  #   virtual_network_subnet_ids = [] # No útil con PE; para PE crea el recurso Private Endpoint
  # }

  tags = var.tags
}
