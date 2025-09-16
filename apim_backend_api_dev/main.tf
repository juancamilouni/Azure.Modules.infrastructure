########################################
# Backend: APIM → tu Container App     #
########################################
resource "azurerm_api_management_backend" "this" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  protocol            = "http"
  url                 = var.backend_url
}

############################
# API (base-path público)  #
############################
resource "azurerm_api_management_api" "this" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  display_name          = var.api_display_name
  path                  = var.api_path           # prefijo público (único en APIM)
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

#########################
# Adjuntar al Product   #
#########################
resource "azurerm_api_management_product_api" "attach" {
  api_name            = azurerm_api_management_api.this.name
  product_id          = var.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}

##########################################################
# POLICY: reescritura para evitar 404                    #
# Quita el base-path público antes de ir al backend.     #
# Si el resultado queda vacío, usa "/".                  #
##########################################################
# Nota: context.Api.Path = base-path público (ej. "/sonarqube")
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

    <!-- Quita el prefijo público (Api.Path) del path original -->
    <set-variable name="cleanPath" value="@{
      var prefix = \"/\" + context.Api.Path.Trim('/');             // ej: '/sonarqube'
      var full   = context.Request.OriginalUrl.Path ?? \"/\";
      if (full.StartsWith(prefix))
      {
          var trimmed = full.Substring(prefix.Length);
          if (string.IsNullOrEmpty(trimmed)) return \"/\";
          return trimmed.StartsWith(\"/\") ? trimmed : \"/\" + trimmed;
      }
      return full;  // fallback si no hace match
    }" />

    <rewrite-uri template="@{ (string)context.Variables.GetValueOrDefault(\"cleanPath\", \"/\") }" />
    <set-backend-service backend-id="${azurerm_api_management_backend.this.name}" />
  </inbound>
  <backend><base /></backend>
  <outbound><base /></outbound>
  <on-error><base /></on-error>
</policies>
XML
}
