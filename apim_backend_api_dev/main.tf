# Backend que apunta a tu Container App (público en DEV)
resource "azurerm_api_management_backend" "this" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  protocol = "http"
  url      = var.backend_url

  # Si tu backend requiere auth/tls ajusta estos bloques:
  # credentials { header = { "x-api-key" = ["<token>"] } }
  # tls { validate_certificate_chain = false, validate_certificate_name = false }
}

# API (opcionalmente importada desde OpenAPI por URL)
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
}

# Product básico (plan) y enlace API↔Product
resource "azurerm_api_management_product" "plan" {
  product_id          = var.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name

  display_name          = var.product_display_name
  subscription_required = var.product_subscription_required
  approval_required     = var.product_approval_required
  published             = true
}

resource "azurerm_api_management_product_api" "attach" {
  api_name            = azurerm_api_management_api.this.name
  product_id          = azurerm_api_management_product.plan.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}

# Política mínima: enruta la API al backend
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
