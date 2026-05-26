variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

variable "scope" {
  description = "Scope del rol (ej: ID del ACR)"
  type        = string
}

variable "role_definition_id" {
  description = "ID ARM del rol en la suscripción (ej: AcrPull GUID global)"
  type        = string
}

variable "principal_id" {
  description = "Object ID (principal) de la identidad"
  type        = string
}

#deploy