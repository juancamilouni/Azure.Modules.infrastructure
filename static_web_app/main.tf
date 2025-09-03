############################################################
# Azure Static Web App (SKU Standard) - main.tf
# - Despliegue básico listo para Dev/QA
# - Comentarios y bloques opcionales para Prod (dominio/HTTPS)
# - 'custom_domain' se usa de forma condicional => TFLint OK
############################################################

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

  # 📝 Según tu estrategia DNS, podrías necesitar especificar
  # el tipo de validación. Déjalo por defecto o descomenta:
  # validation_type = "cname-delegation"  # Alternativa: "dns-txt-token"
}

############################################################
# 🧩 (Notas para PROD – no requieren cambios aquí)
#
# • CI/CD (Azure DevOps):
#   - Usa el Deployment Token de la SWA y el task 'AzureStaticWebApp@0'.
#   - No es necesario acoplar CI/CD a Terraform.
#
# • Application Gateway:
#   - Puedes apuntar temporalmente el backend al 'swa_default_host'
#     (output del módulo) en HTTP 80.
#   - Cuando tengas dominio/HTTPS en AGW, ajustas listeners/SSL allí.
#
# • WAF/Seguridad:
#   - Esto lo gestionas desde el módulo del App Gateway.
#
# • Variables/structure:
#   - Este main.tf sigue tu patrón: provider con versión en provider.tf,
#     variables cargadas vía Terragrunt/common_vars.yaml.
############################################################
