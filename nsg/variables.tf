# 🔧 Variables faltantes que causaban error
variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}
variable "location" {
  description = "Región de Azure donde se desplegará el NSG"
  type        = string
}

variable "prefix" {
  description = "Prefijo para nombrar los NSGs"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}
variable "allowed_ssh_cidr" {
  description = "Rango CIDR permitido para tráfico SSH (puerto 22)"
  type        = string
  default     = "10.0.0.0/24"
}

variable "allowed_sql_cidr" {
  description = "Rango CIDR permitido para tráfico SQL (puerto 1433)"
  type        = string
  default     = "10.0.1.0/24"
}


variable "subnet1_name" {
  description = "Nombre de la subred 1"
  type        = string
}

variable "subnet2_name" {
  description = "Nombre de la subred 2"
  type        = string
}

variable "subnet3_name" {
  description = "Nombre de la subred 3"
  type        = string
}

variable "subnet4_name" {
  description = "Nombre de la subred 4"
  type        = string
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
}

