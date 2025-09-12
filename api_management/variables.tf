# variables.tf

variable "apim_name" {
  description = "The name of the API Management instance."
  type        = string
}

variable "location" {
  description = "The Azure region where the API Management instance should be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the API Management instance (e.g., 'Basic', 'Standard')."
  type        = string
}

variable "sku_capacity" {
  description = "The capacity for the SKU (1 for 'Basic', 2 for 'Standard')."
  type        = number
}

variable "publisher_name" {
  description = "The name of the API Management publisher."
  type        = string
}

variable "publisher_email" {
  description = "The email of the API Management publisher."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the API Management instance."
  type        = map(string)
  default     = {}
}

variable "api_names" {
  description = "A list of API names to be created in the API Management."
  type        = list(string)
}

variable "api_display_names" {
  description = "A list of display names for the APIs."
  type        = list(string)
}

variable "api_paths" {
  description = "A list of paths for the APIs."
  type        = list(string)
}

variable "api_service_urls" {
  description = "A list of service URLs for the APIs."
  type        = list(string)
}

variable "api_operations" {
  description = "A list of operations for each API."
  type        = list(string)
}

variable "api_operation_display_names" {
  description = "A list of display names for each API operation."
  type        = list(string)
}

variable "api_operation_methods" {
  description = "A list of HTTP methods (e.g., GET, POST) for each API operation."
  type        = list(string)
}

variable "api_operation_url_templates" {
  description = "A list of URL templates for each API operation."
  type        = list(string)
}
