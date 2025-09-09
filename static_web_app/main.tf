resource "azurerm_static_web_app" "swa" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_tier = var.sku_tier
  sku_size = var.sku_size

  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = var.tags
}

# Mostrar repo/branch en “Deployment Center” como metadata
# Esto NO realiza despliegues; el despliegue se hace por pipeline con el token.
resource "azapi_update_resource" "swa_repo" {
  count       = var.connect_repo ? 1 : 0
  type        = "Microsoft.Web/staticSites@2024-11-01"
  resource_id = azurerm_static_web_app.swa.id

  body = jsonencode({
    properties = {
      repositoryUrl = var.repo_url
      branch        = var.repo_branch
      # Nota: repositoryToken se usa para GitHub (no para Azure DevOps).
      # Si algún día lo necesitas, añade var.repo_token y envíalo aquí.
    }
  })

  depends_on = [azurerm_static_web_app.swa]
}

# Dominio personalizado (opcional)
resource "azurerm_static_web_app_custom_domain" "custom" {
  for_each = (
    var.custom_domain != null && var.custom_domain != ""
  ) ? { domain = var.custom_domain } : {}

  static_web_app_id = azurerm_static_web_app.swa.id
  domain_name       = each.value.domain
  validation_type   = var.custom_domain_validation_type
}
