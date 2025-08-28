variable "name" {
  description = "Nombre del Application Gateway"
  type        = string
}

variable "location" {
  description = "Ubicación de Azure"
  type        = string
}

variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde se instala el AGW"
  type        = string
}

variable "public_ip_id" {
  description = "ID de la IP pública"
  type        = string
}

variable "backend_ip" {
  description = "IP del backend (por ejemplo Container App, API Management, etc.)"
  type        = string
}

variable "capacity" {
  description = "Número de instancias del AGW"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Etiquetas comunes"
  type        = map(string)
}
