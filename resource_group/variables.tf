variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tags" {
  description = "Etiquetas para resource group"
  type        = map(string)
  default     = {}
}

variable "tenant_id" {
  description = "ID del tenant de Azure Active Directory"
  type        = string
}

