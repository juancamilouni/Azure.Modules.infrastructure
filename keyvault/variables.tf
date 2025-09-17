variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure AD"
  type        = string
}

variable "name" {
  description = "Nombre del Key Vault (3-24 caracteres alfanuméricos y guiones)"
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24 && can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "El nombre debe tener 3-24 caracteres alfanuméricos (y guiones)."
  }
}

variable "location" {
  description = "Región donde se desplegará el Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos destino"
  type        = string
}

variable "sku_name" {
  description = "SKU del Key Vault (standard/premium)"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Días de retención soft-delete (7-90)"
  type        = number
  default     = 30
}

variable "purge_protection_enabled" {
  description = "Habilitar protección de purga (irrevocable)"
  type        = bool
  default     = true
}

variable "rbac_authorization_enabled" {
  description = "Usar RBAC en lugar de access policies"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Permitir acceso público (true) o forzar solo Private Endpoint (false)"
  type        = bool
  default     = true
}

variable "network_acls_default_action" {
  description = "Acción por defecto del firewall: Allow o Deny"
  type        = string
  default     = "Deny"
}

variable "network_acls_bypass" {
  description = "Servicios que pueden saltarse el firewall: AzureServices o None"
  type        = string
  default     = "AzureServices"
}

variable "network_acls_ip_rules" {
  description = "Lista de rangos IP permitidos (CIDRs)"
  type        = list(string)
  default     = []
}

variable "network_acls_vnet_subnet_ids" {
  description = "Lista de subnets (IDs) con acceso al KV"
  type        = list(string)
  default     = []
}

variable "certificate_name" {
  description = "Nombre del certificado dentro del Key Vault"
  type        = string
  default     = "ssl-cert"
}

variable "certificate_pfx_path" {
  description = "Ruta local al archivo .pfx del certificado (opcional)"
  type        = string
  default     = null
}

variable "certificate_password" {
  description = "Password del archivo .pfx (opcional)"
  type        = string
  default     = null
  sensitive   = true
}

variable "application_gateway_identity_principal_id" {
  description = "Object ID de la identidad administrada del Application Gateway"
  type        = string
  default     = null
}

variable "tags" {
  description = "Etiquetas"
  type        = map(string)
  default     = {}
}

#deployqa