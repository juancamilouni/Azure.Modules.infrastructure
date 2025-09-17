variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del Tenant de Azure"
  type        = string
}

variable "name" {
  description = "Nombre del Application Gateway"
  type        = string
}

variable "location" {
  description = "Región de despliegue"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred dedicada para Application Gateway"
  type        = string
}

variable "capacity" {
  description = "Número de instancias mínimas"
  type        = number
  default     = 2
}

variable "web_domain" {
  description = "Dominio para Static WebApp (ej: www.midominio.com)"
  type        = string
}

variable "api_domain" {
  description = "Dominio para API Management (ej: api.midominio.com)"
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
  description = <<EOT
Información del certificado SSL cargado manualmente.
Ejemplo:
{
  data     = filebase64("certificado.pfx")
  password = "tu_password"
}
Si se deja null, se configura manualmente en el portal.
EOT
  type = object({
    data     = string
    password = string
  })
  default = null
}

variable "tags" {
  description = "Etiquetas comunes"
  type        = map(string)
  default     = {}
}
