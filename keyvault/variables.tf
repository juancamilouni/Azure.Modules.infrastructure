variable "name" {
  description = "Nombre del Key Vault"
  type        = string
}

variable "location" {
  description = "Ubicación del recurso"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure AD"
  type        = string
}

variable "object_id" {
  description = "Object ID de la identidad con acceso (UAMI o usuario)"
  type        = string
}

variable "tags" {
  description = "Etiquetas para cumplir política de tagging"
  type        = map(string)
}
