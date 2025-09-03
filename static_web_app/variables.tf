# Provider
variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

# Recurso
variable "name" {
  description = "Nombre del Static Web App"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group destino"
  type        = string
}

variable "location" {
  description = "Región del recurso"
  type        = string
}

variable "sku_tier" {
  description = "SKU Tier del Static Web App (Free | Standard)"
  type        = string
  default     = "Standard"
}

variable "sku_size" {
  description = "SKU Size del Static Web App (Free | Standard)"
  type        = string
  default     = "Standard"
}

variable "identity_enabled" {
  description = "Habilitar identidad administrada (SystemAssigned)"
  type        = bool
  default     = true
}

variable "custom_domain" {
  description = "Dominio personalizado (opcional, usar con azurerm_static_site_custom_domain)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
}
