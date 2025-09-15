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

resource "azurerm_api_management_product" "plan" {
  count               = var.create_product ? 1 : 0
  product_id          = var.product_id
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name

  display_name          = var.product_display_name
  subscription_required = var.product_subscription_required
  approval_required     = var.product_approval_required
  published             = true
}

data "azurerm_api_management_product" "existing" {
  count               = var.create_product ? 0 : 1
  product_id          = var.product_id
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
}

# ✅ CORREGIDO: ternario en una sola línea
locals {
  product_id_full = var.create_product ? azurerm_api_management_product.plan[0].id : data.azurerm_api_management_product.existing[0].id
}

resource "azurerm_api_management_subscription" "sub" {
  count               = var.create_subscription ? 1 : 0
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name

  display_name = var.subscription_display_name
  product_id   = local.product_id_full
  user_id      = var.subscription_user_id
  state        = "active"
}
