resource "azurerm_api_management_backend" "this" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  protocol            = "http"
  url                 = var.backend_url
}


resource "azurerm_api_management_api" "this" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  display_name          = var.api_display_name
  path                  = var.api_path      # prefijo público
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

resource "azurerm_api_management_product_api" "attach" {
  count = var.create_product ? 1 : 0
  api_name            = azurerm_api_management_api.this.name
  product_id          = azurerm_api_management_product.plan[0].product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_subscription" "sub" {
  count               = var.create_subscription ? 1 : 0
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name

  display_name = var.subscription_name
  product_id   = var.create_product ? azurerm_api_management_product.plan[0].id : null
  user_id      = var.subscription_user_id
  state        = "active"
}


locals {
  api_path_regex = format("^/%s", replace(var.api_path, "/", "\\/"))
}

resource "azurerm_api_management_api_policy" "rewrite" {
  api_name            = azurerm_api_management_api.this.name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    ${var.enable_cors ? join("", [
      "<cors>",
        "<allowed-origins>",
          join("", [for o in var.cors_allowed_origins : "<origin>", o, "</origin>"]),
        "</allowed-origins>",
        "<allowed-methods preflight-result-max-age=\"300\"><method>*</method></allowed-methods>",
        "<allowed-headers><header>*</header></allowed-headers>",
        "<expose-headers><header>*</header></expose-headers>",
        "<allow-credentials>false</allow-credentials>",
      "</cors>"
    ]) : ""}

    <!-- quita el prefijo público (var.api_path) -->
    <rewrite-uri template="@(
      Regex.Replace(context.Request.OriginalUrl.Path, '${local.api_path_regex}', '')
    )" />

    <set-backend-service backend-id="${azurerm_api_management_backend.this.name}" />
  </inbound>
  <backend><base /></backend>
  <outbound><base /></outbound>
  <on-error><base /></on-error>
</policies>
XML
}
