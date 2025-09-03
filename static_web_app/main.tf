resource "azurerm_static_site" "swa" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # 📦 SKU "calidad-precio"
  sku_tier = var.sku_tier # "Standard"
  sku_size = var.sku_size # "Standard"

  # 🔐 Identidad administrada (útil si luego necesitas permisos/Key Vault)
  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = var.tags
}

############################################################
# 🔗 Dominio personalizado (PROD)
# - Este recurso SOLO se crea si defines 'custom_domain'
#   (p.ej. "app.midominio.com") en tus inputs.
# - Así evitamos errores y a la vez TFLint ya no marca la
#   variable como "unused".
#
# Pasos recomendados en PROD:
#  1) Crea el registro CNAME/TXT según el tipo de validación.
#  2) Aplica de nuevo este módulo (o ajusta validation_type).
############################################################
resource "azurerm_static_site_custom_domain" "custom" {
  for_each = (
    var.custom_domain != null && var.custom_domain != ""
  ) ? { domain = var.custom_domain } : {}

  static_site_id = azurerm_static_site.swa.id
  domain_name    = each.value.domain
}
