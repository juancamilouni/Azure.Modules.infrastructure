variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}


variable "apim_name" {
  description = "Nombre de la instancia APIM (kebab-case)"
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
  description = "SKU de APIM. Acepta corto (Developer|Standard|Basic|Premium|Consumption) o completo (Developer_1|Standard_1|Basic_1|Premium_1|Consumption_0)."
  type        = string
  validation {
    condition = contains([
      "Developer", "Developer_1",
      "Standard", "Standard_1",
      "Basic", "Basic_1",
      "Premium", "Premium_1",
      "Consumption", "Consumption_0"
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

variable "tags" {
  description = "Etiquetas obligatorias"
  type        = map(string)
  default     = {}
}

variable "create_product" {
  description = "¿Crear un Product y publicarlo?"
  type        = bool
  default     = true
}

variable "product_id" {
  description = "productId del Product (kebab-case) si create_product = true o para referenciar uno existente"
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
  description = "¿El Product requiere suscripción (subscription key)?"
  type        = bool
  default     = true
}

variable "product_approval_required" {
  description = "¿Requiere aprobación manual de suscripciones?"
  type        = bool
  default     = false
}

variable "create_subscription" {
  description = "¿Crear una suscripción asociada al Product?"
  type        = bool
  default     = true
}

variable "subscription_name" {
  description = "Nombre único de la suscripción a crear"
  type        = string
  default     = "dev-subscription"
}

variable "subscription_display_name" {
  description = "Nombre visible de la suscripción"
  type        = string
  default     = "Dev subscription"
}

variable "subscription_user_id" {
  description = "User ID en APIM (p.ej. '1' = Administrators)"
  type        = string
  default     = "1"
}


#deploy