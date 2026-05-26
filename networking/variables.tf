variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "vnet_name" {
  description = "Nombre de la VNet"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos"
  type        = string
}

variable "address_space" {
  description = "Espacio de direcciones de la red"
  type        = list(string)
}

variable "subnets" {
  description = "Subredes a crear"
  type = list(object({
    name                      = string
    address_prefixes          = list(string)
    service_endpoints         = optional(list(string))
    network_security_group_id = optional(string)
  }))
}


variable "enable_network_watcher" {
  description = "Indica si se debe crear un Network Watcher en la región"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Etiquetas aplicadas"
  type        = map(string)
}

#deploy