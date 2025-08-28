variable "subscription_id" {
  description = "ID de la suscripción de Azure."
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure Active Directory."
  type        = string
}

variable "location" {
  description = "Región para crear los Resource Groups (p. ej. eastus2)."
  type        = string
}

variable "resource_group_names" {
  description = "Lista de nombres de Resource Groups a crear."
  type        = list(string)
}

variable "tags" {
  description = "Etiquetas a aplicar a todos los Resource Groups."
  type        = map(string)
  default     = {}
}
