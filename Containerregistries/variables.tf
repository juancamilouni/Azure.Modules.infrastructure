variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "acr_name" {
  description = "Nombre del Azure Container Registry"
  type        = string
}

variable "location" {
  description = "Ubicación del Azure Container Registry"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "sku" {
  description = "SKU del Azure Container Registry"
  type        = string
}

variable "admin_enabled" {
  description = "Habilitar el acceso de administrador"
  type        = bool
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
}

#deploy