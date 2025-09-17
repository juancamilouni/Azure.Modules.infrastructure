##########################################
# Key Vault
##########################################
resource "azurerm_key_vault" "this" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id

  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  enable_rbac_authorization   = var.rbac_authorization_enabled
  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    default_action             = var.network_acls_default_action
    bypass                     = var.network_acls_bypass
    ip_rules                   = var.network_acls_ip_rules
    virtual_network_subnet_ids = var.network_acls_vnet_subnet_ids
  }

  tags = var.tags
}

##########################################
# Certificado SSL/TLS (opcional)
##########################################
resource "azurerm_key_vault_certificate" "ssl" {
  count        = var.certificate_pfx_path != null ? 1 : 0
  name         = var.certificate_name
  key_vault_id = azurerm_key_vault.this.id

  certificate {
    contents = base64encode(file(var.certificate_pfx_path))
    password = var.certificate_password
  }
}

##########################################
# Permisos para Application Gateway
##########################################
resource "azurerm_role_assignment" "agw_cert" {
  count                = var.application_gateway_identity_principal_id != null ? 1 : 0
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.application_gateway_identity_principal_id
}
