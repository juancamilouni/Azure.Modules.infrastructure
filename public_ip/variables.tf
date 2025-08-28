variable "name" {
  description = "Nombre de la IP pública"
  type        = string
}

variable "location" {
  description = "Ubicación de la IP"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "zones" {
  description = "Zonas de disponibilidad (por ejemplo [\"1\", \"2\", \"3\"])"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Etiquetas para la IP pública"
  type        = map(string)
  default     = {}
}

variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}


variable "tenant_id" {
  description = "ID del tenant de Azure Active Directory"
  type        = string
}
