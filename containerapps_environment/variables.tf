variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "name" {
  description = "Nombre del Azure Container Apps Environment"
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 60
    error_message = "El nombre del Environment debe tener entre 3 y 60 caracteres."
  }
}

variable "location" {
  description = "Región de Azure (ej. East US 2)"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos donde se crea el Environment"
  type        = string
}

variable "infrastructure_subnet_id" {
  description = "ID de la Subnet para un Environment privado (null para público)"
  type        = string
  default     = null
}

variable "internal_load_balancer_enabled" {
  description = "Habilitar ILB interno del servicio ACA (déjalo en false si APIM es el front)"
  type        = bool
  default     = false
}

variable "zone_redundancy_enabled" {
  description = "Habilitar redundancia por zonas en el Environment"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}
