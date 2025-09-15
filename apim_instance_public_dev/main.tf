locals {
  sku_map = {
    "Developer"     = "Developer_1"
    "Developer_1"   = "Developer_1"
    "Standard"      = "Standard_1"
    "Standard_1"    = "Standard_1"
    "Basic"         = "Basic_1"
    "Basic_1"       = "Basic_1"
    "Premium"       = "Premium_1"
    "Premium_1"     = "Premium_1"
    "Consumption"   = "Consumption_0"
    "Consumption_0" = "Consumption_0"
  }
  sku_normalized = lookup(local.sku_map, var.sku_name, var.sku_name)
}

resource "azurerm_api_management" "this" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email
  sku_name        = local.sku_normalized

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
