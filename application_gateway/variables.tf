variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

variable "name" {
  description = "Nombre del Application Gateway"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se desplegará el Application Gateway"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde se desplegará el Application Gateway"
  type        = string
}

variable "capacity" {
  description = "Capacidad (número de instancias del Application Gateway)"
  type        = number
  default     = 2
}

variable "web_domain" {
  description = "Dominio para la aplicación web (ej: www.miapp.com)"
  type        = string
}

variable "api_domain" {
  description = "Dominio para el API (ej: api.miapp.com)"
  type        = string
}

variable "swa_fqdn" {
  description = "FQDN de la Static WebApp"
  type        = string
}

variable "apim_fqdn" {
  description = "FQDN del API Management"
  type        = string
}

variable "ssl_cert" {
  description = "Certificado SSL en formato { data, password }. Null si se gestiona manual."
  type = object({
    data     = string
    password = string
  })
  default = null
}

variable "tags" {
  description = "Mapeo de tags obligatorios"
  type        = map(string)
}
