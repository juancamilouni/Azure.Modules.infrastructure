variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}
variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "apim_name" {
  description = "Nombre de la instancia APIM (kebab-case 3..64)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.apim_name))
    error_message = "Usa kebab-case (a-z, 0-9, '-') entre 3 y 64 caracteres."
  }
}
variable "location" {
  description = "Región"
  type        = string
}
variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}
variable "sku_name" {
  description = "SKU de APIM: Developer(_1) | Standard(_1) | Basic(_1) | Premium(_1) | Consumption(_0)"
  type        = string
  validation {
    condition = contains([
      "Developer","Developer_1",
      "Standard","Standard_1",
      "Basic","Basic_1",
      "Premium","Premium_1",
      "Consumption","Consumption_0"
    ], var.sku_name)
    error_message = "Usa uno de: Developer(_1), Standard(_1), Basic(_1), Premium(_1), Consumption(_0)."
  }
}
variable "publisher_name" {
  description = "Nombre del publicador"
  type        = string
}
variable "publisher_email" {
  description = "Email del publicador"
  type        = string
  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.publisher_email))
    error_message = "Ingresa un email válido."
  }
}
variable "tags" {
  description = "Etiquetas"
  type        = map(string)
  default     = {}
}

variable "custom_domain_enabled" {
  description = "Habilitar dominio personalizado (Key Vault)"
  type        = bool
  default     = false
}
variable "custom_domain" {
  description = "FQDN público para el proxy"
  type        = string
  default     = ""
}
variable "kv_certificate_secret_id" {
  description = "Secret ID del certificado en Key Vault"
  type        = string
  default     = ""
}

variable "create_product" {
  description = "¿Crear un Product y publicarlo?"
  type        = bool
  default     = true
}
variable "product_id" {
  description = "productId del Product (kebab-case 3..64). Si create_product=false, debe existir"
  type        = string
  default     = "plan-default"
  validation {
    condition     = can(regex("^[a-z0-9-]{3,64}$", var.product_id))
    error_message = "product_id debe ser kebab-case (3..64)."
  }
}
variable "product_display_name" {
  description = "Nombre visible del Product"
  type        = string
  default     = "Default plan"
}
variable "product_subscription_required" {
  description = "¿El Product requiere key de suscripción?"
  type        = bool
  default     = true
}
variable "product_approval_required" {
  description = "¿Aprobación manual para suscribirse?"
  type        = bool
  default     = false
}

variable "create_subscription" {
  description = "¿Crear una suscripción asociada al Product?"
  type        = bool
  default     = true
}
variable "subscription_display_name" {
  description = "Nombre visible de la suscripción"
  type        = string
  default     = "Dev subscription"
}
variable "subscription_user_id" {
  description = "User ID en APIM. Acepta '1' (Administrators) o el Resource ID completo '/subscriptions/.../users/<id>'"
  type        = string
  default     = "1"
}
