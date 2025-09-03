resource "azurerm_static_site" "swa" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # SKU Standard (calidad/precio)
  sku_tier = var.sku_tier
  sku_size = var.sku_size

  # Identidad administrada opcional (recomendada)
  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = var.tags
}

/*
# 🧩 (Opcional, cuando tengas dominio)
resource "azurerm_static_site_custom_domain" "custom" {
  static_site_id = azurerm_static_site.swa.id
  domain_name    = var.custom_domain
}
*/
