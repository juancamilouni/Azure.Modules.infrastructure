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

variable "tags" {
  description = "Etiquetas para la IP pública"
  type        = map(string)
  default     = {}
}

#deploy