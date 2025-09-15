resource "azurerm_api_management_backend" "this" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  protocol            = "http"
  url                 = var.backend_url
  # Si necesitas auth hacia el backend en dev, agrega credentials/tls via variables.
}

resource "azurerm_api_management_api" "this" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  display_name          = var.api_display_name
  path                  = var.api_path
  protocols             = ["https"]
  api_type              = "http"
  revision              = "1"
  subscription_required = var.api_subscription_required

  dynamic "import" {
    for_each = (var.openapi_spec_url != null && var.openapi_spec_url != "") ? [1] : []
    content {
      content_format = "openapi-link"
      content_value  = var.openapi_spec_url
    }
  }

  tags = var.tags
}

resource "azurerm_api_management_product" "plan" {
  product_id          = var.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name

  display_name          = var.product_display_name
  subscription_required = var.product_subscription_required
  approval_required     = var.product_approval_required
  published             = true

  tags = var.tags
}

resource "azurerm_api_management_product_api" "attach" {
  api_name            = azurerm_api_management_api.this.name
  product_id          = azurerm_api_management_product.plan.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_api_policy" "base" {
  api_name            = azurerm_api_management_api.this.name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service backend-id="${azurerm_api_management_backend.this.name}" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}
