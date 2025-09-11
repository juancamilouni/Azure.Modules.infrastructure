variable "subscription_id" {
  description = <<EOT
ID de la suscripción de Azure donde se desplegará el recurso.
Se inyecta desde Terragrunt.
EOT
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure (GUID)."
  type        = string
}

variable "name" {
  description = <<EOT
Nombre de la Static Web App. Debe ser único dentro de la suscripción.
Sigue tu convención: <app>-swa-<env>.
EOT
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se creará la SWA."
  type        = string
}

variable "location" {
  description = <<EOT
Región administrativa del recurso (ej.: 'East US', 'West Europe').
El portal mostrará 'Global' para SWA, pero aquí defines la región administrativa.
EOT
  type        = string
}

variable "sku_tier" {
  description = "Tier de la SWA. Valores soportados: 'Free' o 'Standard'."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier debe ser 'Free' o 'Standard'."
  }
}

variable "sku_size" {
  description = "Tamaño de la SWA (usar 'Free' o 'Standard' según el tier)."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Free", "Standard"], var.sku_size)
    error_message = "sku_size debe ser 'Free' o 'Standard'."
  }
}

variable "identity_enabled" {
  description = "Habilita identidad administrada (SystemAssigned) para integraciones (Key Vault, etc.)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapa de etiquetas corporativas (Environment, Owner, Project, CostCenter, etc.)."
  type        = map(string)
  default     = {}
}


variable "custom_domain" {
  description = <<EOT
Dominio personalizado a asociar (opcional). Ej.: 'app.midominio.com'.
Dejar null o cadena vacía para omitir la creación del recurso.
EOT
  type        = string
  default     = null
}

variable "custom_domain_validation_type" {
  description = "Método de validación del dominio personalizado."
  type        = string
  default     = "cname-delegation"
  validation {
    condition     = contains(["cname-delegation", "dns-txt-token"], var.custom_domain_validation_type)
    error_message = "custom_domain_validation_type debe ser 'cname-delegation' o 'dns-txt-token'."
  }
}


variable "connect_repo" {
  description = <<EOT
Si es true, se escriben repositoryUrl y branch en el recurso (visible en Deployment Center).
Esto NO despliega el código; el despliegue se hace con pipeline usando el deployment token.
EOT
  type        = bool
  default     = false
}

variable "repo_url" {
  description = <<EOT
URL del repositorio (Azure DevOps o GitHub).
Ej. Azure DevOps: https://dev.azure.com/ORG/PROY/_git/REPO
Ej. GitHub:       https://github.com/ORG/REPO.git
EOT
  type        = string
  default     = ""
}

variable "repo_branch" {
  description = "Rama a mostrar en Deployment Center (ej.: 'main', 'dev')."
  type        = string
  default     = "main"
}

/* Si algún día requieres token para GitHub:
variable "repo_token" {
  description = "PAT de GitHub para flujos nativos (no aplica para Azure DevOps)."
  type        = string
  default     = null
  sensitive   = true
}
*/
