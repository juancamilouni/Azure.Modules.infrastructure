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

#########################
# Adjuntar al Product   #
#########################
resource "azurerm_api_management_product_api" "attach" {
  api_name            = azurerm_api_management_api.this.name
  product_id          = var.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}

############################
# Locals para CORS (XML)   #
############################
locals {
  cors_origins_xml = join("", [for o in var.cors_allowed_origins : "<origin>${o}</origin>"])

  # Construimos el bloque CORS por separado (HCL no permite heredoc dentro del ternario directamente)
  cors_block_xml_value = <<EOT
<cors>
  <allowed-origins>
    ${local.cors_origins_xml}
  </allowed-origins>
  <allowed-methods preflight-result-max-age="300"><method>*</method></allowed-methods>
  <allowed-headers><header>*</header></allowed-headers>
  <expose-headers><header>*</header></expose-headers>
  <allow-credentials>false</allow-credentials>
</cors>
EOT

  cors_block_xml = var.enable_cors ? local.cors_block_xml_value : ""
}

##########################################################
# POLICY: reescritura para evitar 404                    #
# Quita el base-path público antes de ir al backend.     #
# Si el resultado queda vacío, usa "/".                  #
##########################################################
# NOTA: se usan &quot; dentro de atributos XML para que el validador de APIM
# no rechace las expresiones @{ ... } con comillas.
resource "azurerm_api_management_api_policy" "rewrite" {
  api_name            = azurerm_api_management_api.this.name
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    ${local.cors_block_xml}

    <!-- Calcula el prefijo público de la API y el path completo solicitado -->
    <set-variable name="prefix" value="@{ &quot;/&quot; + context.Api.Path.Trim('/') }" />
    <set-variable name="full"   value="@{ context.Request.OriginalUrl.Path ?? &quot;/&quot; }" />

    <!-- Quita el prefijo público (Api.Path) del path original -->
    <set-variable name="cleanPath" value="@{
      var pre  = (string)context.Variables[&quot;prefix&quot;];
      var full = (string)context.Variables[&quot;full&quot;];

      // API en raíz: no quitar nada
      if (string.IsNullOrEmpty(pre) || pre == &quot;/&quot;)
      {
          return string.IsNullOrEmpty(full) ? &quot;/&quot; : full;
      }

      if (full.StartsWith(pre))
      {
          var trimmed = full.Substring(pre.Length);
          if (string.IsNullOrEmpty(trimmed)) return &quot;/&quot;;
          return trimmed.StartsWith(&quot;/&quot;) ? trimmed : &quot;/&quot; + trimmed;
      }
      return full;  // fallback si no hace match
    }" />

    <!-- Usa el path limpio, con fallback a "/" -->
    <rewrite-uri template="@{ (string)context.Variables.GetValueOrDefault(&quot;cleanPath&quot;, &quot;/&quot;) }" />

    <!-- Enruta al backend configurado -->
    <set-backend-service backend-id="${azurerm_api_management_backend.this.name}" />
  </inbound>
  <backend><base /></backend>
  <outbound><base /></outbound>
  <on-error><base /></on-error>
</policies>
XML
}
