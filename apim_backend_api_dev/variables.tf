variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group"
  type        = string
}

variable "apim_name" {
  description = "Nombre de APIM"
  type        = string
}

# Backend (tu ACA o mock)
variable "backend_name" {
  description = "Nombre backend en APIM (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.backend_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "backend_url" {
  description = "URL base backend (http/https)"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.backend_url))
    error_message = "Debe iniciar con http:// o https://"
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
  description = "Ruta pública base"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-_/]{1,128}$", var.api_path))
    error_message = "Usa solo a-z, 0-9, '-', '_' y '/'."
  }
}

variable "openapi_spec_url" {
  description = "URL OpenAPI (opcional)"
  type        = string
  default     = ""
}

variable "api_subscription_required" {
  description = "¿Requiere suscripción?"
  type        = bool
  default     = true
}

# Product
variable "product_id" {
  description = "ID del Product (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.product_id))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "product_display_name" {
  description = "Nombre visible del Product"
  type        = string
}

variable "product_subscription_required" {
  description = "¿Requiere suscripción al Product?"
  type        = bool
  default     = true
}

variable "product_approval_required" {
  description = "¿Aprobación manual?"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Etiquetas obligatorias"
  type        = map(string)
  default     = {}
}
