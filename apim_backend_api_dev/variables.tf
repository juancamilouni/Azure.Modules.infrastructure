##########################################
# Provider context
##########################################
variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group de APIM"
  type        = string
}

variable "apim_name" {
  description = "Nombre de la instancia de API Management"
  type        = string
}

##########################################
# Backend
##########################################
variable "backend_name" {
  description = "Nombre del backend en APIM (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.backend_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "backend_url" {
  description = "URL base del backend (http/https). Ejemplo: endpoint del Gateway"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.backend_url))
    error_message = "backend_url debe iniciar con http:// o https://"
  }
}

##########################################
# API
##########################################
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
  description = "Ruta base expuesta en APIM. Ej: api/precredit. Puede estar vacía para exponer en la raíz."
  type        = string

  validation {
    condition     = can(regex("^$|^[a-z0-9-_/]{1,128}$", var.api_path))
    error_message = "api_path debe estar vacío o usar solo a-z, 0-9, '-', '_' y '/'."
  }
}


variable "openapi_spec_url" {
  description = "URL de la especificación OpenAPI (opcional)"
  type        = string
  default     = ""
}

variable "api_subscription_required" {
  description = "¿Requiere suscripción para acceder a la API?"
  type        = bool
  default     = true
}

##########################################
# Product
##########################################
variable "create_product" {
  description = "¿Crear un Product en APIM? (true) o usar existente (false)"
  type        = bool
  default     = false
}

variable "product_id" {
  description = "ID del Product (kebab-case). Si create_product=false, debe existir."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.product_id))
    error_message = "Product ID debe ser kebab-case (a-z, 0-9, '-')."
  }
}

variable "product_display_name" {
  description = "Nombre visible del Product (si create_product=true)"
  type        = string
  default     = ""
}

variable "product_subscription_required" {
  description = "¿Requiere suscripción el Product?"
  type        = bool
  default     = true
}

variable "product_approval_required" {
  description = "¿Requiere aprobación manual el Product?"
  type        = bool
  default     = false
}

##########################################
# Wildcard & Rewrite
##########################################
variable "enable_wildcard_operations" {
  description = "Crear operaciones comodín /* para métodos HTTP"
  type        = bool
  default     = true
}

variable "wildcard_methods" {
  description = "Métodos HTTP para operaciones comodín"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "HEAD"]
}

variable "enable_rewrite_uri" {
  description = "Reescribir prefijo api_path para evitar 404 en backend"
  type        = bool
  default     = true
}

#deploy