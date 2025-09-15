resource "azurerm_api_management" "this" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email
  sku_name        = var.sku_name # Developer (dev/uat) | Standard (prod sin VNet)

  identity { type = "SystemAssigned" }

  dynamic "hostname_configuration" {
    for_each = var.custom_domain_enabled ? [1] : []
    content {
      proxy {
        host_name                    = var.custom_domain
        key_vault_id                 = var.kv_certificate_secret_id
        negotiate_client_certificate = false
      }
    }
  }

  tags = var.tags
}
