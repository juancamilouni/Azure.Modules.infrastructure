resource "azurerm_api_management_backend" "this" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  protocol = "http"
  url      = var.backend_url
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
}


resource "azurerm_api_management_product" "plan" {
  count               = var.create_product ? 1 : 0
  product_id          = var.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name

  display_name          = var.product_display_name
  subscription_required = var.product_subscription_required
  approval_required     = var.product_approval_required
  published             = true
}

locals {
  product_id_effective = var.create_product ? azurerm_api_management_product.plan[0].product_id : var.product_id
}

resource "azurerm_api_management_product_api" "attach" {
  api_name            = azurerm_api_management_api.this.name
  product_id          = local.product_id_effective
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}


locals {
  wildcard_map = var.enable_wildcard_operations ? { for m in var.wildcard_methods : m => m } : {}
}

resource "azurerm_api_management_api_operation" "wildcard" {
  for_each            = local.wildcard_map
  api_name            = azurerm_api_management_api.this.name
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name

  operation_id = "passthrough-${lower(each.value)}"
  display_name = "${each.value} passthrough"
  method       = each.value
  url_template = "/*"
}


resource "azurerm_api_management_api_policy" "with_rewrite" {
  count               = var.enable_rewrite_uri ? 1 : 0
  api_name            = azurerm_api_management_api.this.name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <!-- 🔑 Reescribe eliminando el prefijo api_path para evitar 404 -->
    <rewrite-uri template="@(Regex.Replace(context.Request.OriginalUrl.Path, @"^/${var.api_path}", ""))" />
    <set-backend-service backend-id="${azurerm_api_management_backend.this.name}" />
  </inbound>
  <backend><base /></backend>
  <outbound><base /></outbound>
  <on-error><base /></on-error>
</policies>
XML
}

resource "azurerm_api_management_api_policy" "no_rewrite" {
  count               = var.enable_rewrite_uri ? 0 : 1
  api_name            = azurerm_api_management_api.this.name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service backend-id="${azurerm_api_management_backend.this.name}" />
  </inbound>
  <backend><base /></backend>
  <outbound><base /></outbound>
  <on-error><base /></on-error>
</policies>
XML
}
