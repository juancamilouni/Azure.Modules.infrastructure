variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}
variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}
variable "resource_group_name" {
  description = "Resource Group donde existe APIM"
  type        = string
}
variable "apim_name" {
  description = "Nombre de la instancia de APIM"
  type        = string
}

variable "backend_name" {
  description = "Nombre del backend en APIM (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.backend_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}
variable "backend_url" {
  description = "URL base del backend (http/https) ej: FQDN de Container Apps"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.backend_url))
    error_message = "backend_url debe iniciar con http:// o https://"
  }
}

variable "api_name" {
  description = "Nombre lógico de la API (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.api_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}
variable "api_display_name" {
  description = "Nombre visible de la API en APIM"
  type        = string
}
variable "api_path" {
  description = "Base-path público único (p.ej. 'sonarqube' o 'api/precredit')"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-_/]{1,128}$", var.api_path))
    error_message = "api_path permite a-z, 0-9, '-', '_' y '/'."
  }
}
variable "openapi_spec_url" {
  description = "URL del OpenAPI (opcional); vacío para no importar"
  type        = string
  default     = ""
}
variable "api_subscription_required" {
  description = "¿Requiere suscripción para acceder?"
  type        = bool
  default     = true
}

variable "create_product" {
  description = "Crear/gestionar un Product y asociar la API"
  type        = bool
  default     = true
}
variable "product_id" {
  description = "ID del Product (kebab-case) si create_product = true"
  type        = string
  default     = "plan-default"
  validation {
    condition     = var.create_product ? can(regex("^[a-z0-9-]{3,64}$", var.product_id)) : true
    error_message = "product_id debe ser kebab-case 3..64."
  }
}
variable "product_display_name" {
  description = "Nombre visible del Product"
  type        = string
  default     = "Default plan"
}
variable "product_subscription_required" {
  description = "¿El Product requiere suscripción?"
  type        = bool
  default     = true
}
variable "product_approval_required" {
  description = "¿Aprobación manual de suscripciones?"
  type        = bool
  default     = false
}

variable "create_subscription" {
  description = "Crear suscripción al Product y exponer la key como output"
  type        = bool
  default     = false
}
variable "subscription_name" {
  description = "Nombre de la suscripción a crear"
  type        = string
  default     = "dev-subscription"
}
variable "subscription_user_id" {
  description = "User ID en APIM (ej: '1' = Administrators)"
  type        = string
  default     = "1"
}

variable "enable_cors" {
  description = "Habilitar CORS en la API"
  type        = bool
  default     = false
}
variable "cors_allowed_origins" {
  description = "Orígenes permitidos si CORS está habilitado"
  type        = list(string)
  default     = ["http://localhost:3000"]
}
