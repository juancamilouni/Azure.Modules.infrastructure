##############################
# Contexto / Provider        #
##############################
variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}
variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

##############################
# Instancia APIM             #
##############################
variable "resource_group_name" {
  description = "Resource Group donde existe APIM"
  type        = string
}
variable "apim_name" {
  description = "Nombre de la instancia APIM"
  type        = string
}

##############################
# Backend (ACA / HTTP(S))    #
##############################
variable "backend_name" {
  description = "Nombre del backend en APIM (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.backend_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}
variable "backend_url" {
  description = "URL base del backend (http/https) — FQDN de Container Apps"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.backend_url))
    error_message = "backend_url debe iniciar con http:// o https://"
  }
}

##############################
# API (definición pública)   #
##############################
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
  description = "Base-path público único (ej: 'sonarqube', 'api/ms1'). Vacío para raíz."
  type        = string
  validation {
    condition     = can(regex("^$|^[a-z0-9-_/]{1,128}$", var.api_path))
    error_message = "api_path permite vacío (raíz) o a-z, 0-9, '-', '_' y '/'."
  }
}

variable "openapi_spec_url" {
  description = "URL del OpenAPI (opcional). Déjalo vacío para no importar"
  type        = string
  default     = ""
}
variable "api_subscription_required" {
  description = "¿Requiere suscripción para acceder?"
  type        = bool
  default     = true
}

##############################
# Product (referencia)       #
##############################
variable "product_id" {
  description = "productId existente al que se adjuntará la API (kebab-case)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.product_id))
    error_message = "product_id debe ser kebab-case (3..64)."
  }
}

##############################
# CORS (opcional)            #
##############################
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
