# Contexto provider
variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group de APIM"
  type        = string
}

variable "apim_name" {
  description = "Nombre de la instancia APIM destino"
  type        = string
}

# Backend (tu ACA o mock público en DEV)
variable "backend_name" {
  description = "Nombre del backend en APIM (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.backend_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "backend_url" {
  description = "URL base del backend (http/https), por ejemplo el FQDN del ACA"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.backend_url))
    error_message = "backend_url debe iniciar con http:// o https://"
  }
}

# API
variable "api_name" {
  description = "Nombre lógico de la API (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.api_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "api_display_name" {
  description = "Nombre visible de la API"
  type        = string
}

variable "api_path" {
  description = "Ruta pública base (sin dominio). Ej: api/precredit"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-_/]{1,128}$", var.api_path))
    error_message = "api_path: usa solo a-z, 0-9, '-', '_' y '/'."
  }
}

variable "openapi_spec_url" {
  description = "URL del documento OpenAPI (opcional). Déjalo vacío para no importar."
  type        = string
  default     = ""
}

variable "api_subscription_required" {
  description = "¿Requiere suscripción para acceder a la API?"
  type        = bool
  default     = true
}

# Product (usaremos uno EXISTENTE por defecto)
variable "create_product" {
  description = "Crear el Product aquí (true) o usar uno existente (false)"
  type        = bool
  default     = false
}

variable "product_id" {
  description = "ID del Product (kebab-case). Si create_product=false, debe existir en APIM"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.product_id))
    error_message = "Product ID: usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "product_display_name" {
  description = "Nombre visible del Product (solo si create_product=true)"
  type        = string
  default     = ""
}

variable "product_subscription_required" {
  description = "¿Requiere suscripción el Product? (solo si create_product=true)"
  type        = bool
  default     = true
}

variable "product_approval_required" {
  description = "¿Aprobación manual de suscripciones? (solo si create_product=true)"
  type        = bool
  default     = false
}

# Wildcard operations & rewrite (feature flags)
variable "enable_wildcard_operations" {
  description = "Crear operaciones comodín /* para métodos comunes"
  type        = bool
  default     = true
}

variable "wildcard_methods" {
  description = "Métodos HTTP para operaciones comodín"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "HEAD"]
}

variable "enable_rewrite_uri" {
  description = "Reescribir el prefijo api_path antes de enviar al backend"
  type        = bool
  default     = true
}
