variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "name" {
  description = "Nombre de la Managed Identity (kebab-case)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}

variable "location" {
  description = "Ubicación del recurso"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "tags" {
  description = "Etiquetas obligatorias"
  type        = map(string)
}

#deploy