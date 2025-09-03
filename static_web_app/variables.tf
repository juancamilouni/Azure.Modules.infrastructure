variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "name" {
  description = "Nombre de la Static Web App"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se despliega la SWA"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "sku_tier" {
  description = "Tier de la SWA (Standard)"
  type        = string
  default     = "Standard"
}

variable "sku_size" {
  description = "Size de la SWA (Standard)"
  type        = string
  default     = "Standard"
}

variable "identity_enabled" {
  description = "Habilitar identidad administrada (SystemAssigned)"
  type        = bool
  default     = false
}

variable "custom_domain" {
  description = "Dominio personalizado (opcional). Déjalo null para no crear el recurso."
  type        = string
  default     = null
}

variable "tags" {
  description = "Etiquetas"
  type        = map(string)
  default     = {}
}
