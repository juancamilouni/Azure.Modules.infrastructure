resource "azurerm_static_web_app" "swa" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # SKU Standard (calidad/precio)
  sku_tier = var.sku_tier   # "Standard"
  sku_size = var.sku_size   # "Standard"

  # Identidad administrada opcional (útil para KV, etc.)
  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = var.tags
}

# Dominio personalizado (opcional, solo si lo pasas)
resource "azurerm_static_web_app_custom_domain" "custom" {
  for_each = (
    var.custom_domain != null && var.custom_domain != ""
  ) ? { domain = var.custom_domain } : {}

  static_web_app_id = azurerm_static_web_app.swa.id
  domain_name       = each.value.domain

  # validation_type = "cname-delegation"  # o "dns-txt-token"
}
