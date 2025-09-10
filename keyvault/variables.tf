variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure AD"
  type        = string
}

variable "name" {
  description = "Nombre del Key Vault"
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24
    error_message = "El nombre del Key Vault debe tener entre 3 y 24 caracteres."
  }
}

variable "location" {
  description = "Ubicación del recurso"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "sku_name" {
  description = "SKU del Key Vault (standard/premium)"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Días de retención de soft-delete (7-90)"
  type        = number
  default     = 30
}

variable "purge_protection_enabled" {
  description = "Habilitar protección de purga (no se puede deshabilitar luego)"
  type        = bool
  default     = true
}

variable "rbac_authorization_enabled" {
  description = "Usar RBAC en lugar de access policies"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Permitir acceso público al KV (true/false). Si usarás Private Endpoint, déjalo true y bloquea por firewall."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Etiquetas para cumplir política de tagging"
  type        = map(string)
  default     = {}
}
