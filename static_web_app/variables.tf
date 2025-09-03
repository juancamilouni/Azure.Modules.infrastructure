variable "custom_domain_validation_type" {
  description = "Método de validación del dominio personalizado"
  type        = string
  default     = "cname-delegation" # alternativas: "dns-txt-token"
  validation {
    condition     = contains(["cname-delegation", "dns-txt-token"], var.custom_domain_validation_type)
    error_message = "custom_domain_validation_type debe ser 'cname-delegation' o 'dns-txt-token'."
  }
}
