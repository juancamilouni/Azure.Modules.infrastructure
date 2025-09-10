resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # RBAC-first (no mezclar con access_policies)
  enable_rbac_authorization = var.rbac_authorization_enabled

  # Público por ahora (cuando tengas PE ponlo en false)
  public_network_access_enabled = var.public_network_access_enabled

  # ACLs de red (tfsec exige default_action definido)
  network_acls {
    default_action             = var.network_acls_default_action
    bypass                     = var.network_acls_bypass
    ip_rules                   = var.network_acls_ip_rules
    virtual_network_subnet_ids = var.network_acls_vnet_subnet_ids
  }

  tags = var.tags
}
