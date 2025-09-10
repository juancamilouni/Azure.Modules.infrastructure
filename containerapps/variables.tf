variable "subscription_id" {
  description = "Azure Subscription ID."
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se crea la Container App."
  type        = string
}

variable "name" {
  description = "Nombre del recurso (kebab-case: project-componente-environment)."
  type        = string
}

variable "environment_id" {
  description = "ID del Azure Container Apps Environment."
  type        = string
}

variable "image" {
  description = "Imagen del contenedor (p. ej. acr.azurecr.io/repo:tag)."
  type        = string
}

variable "cpu" {
  description = "vCPU del contenedor (p. ej. 0.25, 0.5, 1, 2, 4)."
  type        = number
  default     = 0.5

  validation {
    condition     = contains([0.25, 0.5, 1, 2, 4], var.cpu)
    error_message = "cpu debe ser uno de: 0.25, 0.5, 1, 2, 4."
  }
}

variable "memory" {
  description = "Memoria del contenedor (formato: 0.5Gi, 1.0Gi, 2.0Gi...)."
  type        = string
  default     = "1.0Gi"

  validation {
    condition     = can(regex("^([0-9]+(\\.[0-9]+)?)Gi$", var.memory))
    error_message = "memory debe estar en formato '<n>Gi', por ejemplo '1.0Gi'."
  }
}

variable "revision_mode" {
  description = "Modo de revisiones: Single o Multiple."
  type        = string
  default     = "Single"

  validation {
    condition     = contains(["Single", "Multiple"], var.revision_mode)
    error_message = "revision_mode debe ser 'Single' o 'Multiple'."
  }
}


variable "ingress_enabled" {
  description = "Habilita ingress en la Container App."
  type        = bool
  default     = true
}

variable "ingress_external" {
  description = "Si true, ingress externo; false = interno."
  type        = bool
  default     = false
}

variable "target_port" {
  description = "Puerto de escucha de la aplicación."
  type        = number
  default     = 80
}

variable "ingress_transport" {
  description = "Transporte de ingress: auto | http | http2."
  type        = string
  default     = "auto"

  validation {
    condition     = contains(["auto", "http", "http2"], var.ingress_transport)
    error_message = "ingress_transport debe ser 'auto', 'http' o 'http2'."
  }
}

variable "allow_insecure_connections" {
  description = "Permite HTTP sin TLS (solo si es necesario)."
  type        = bool
  default     = false
}

variable "env_vars" {
  description = "Variables de entorno en claro (clave → valor)."
  type        = map(string)
  default     = {}
}

variable "secret_env_map" {
  description = "ENV_NAME → secret_name (de var.secrets). Si no hay secretos, puede quedar vacío."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = <<EOT
Secretos de la Container App. Opcionales.
- Si NO tienes Key Vault aún, deja esta lista vacía (default).
- Si luego agregas Key Vault: usa key_vault_secret_id y 'identity'='system' o client_id de UAMI.
EOT
  type = list(object({
    name : string
    value : optional(string)
    key_vault_secret_id : optional(string)
    identity : optional(string) # 'system' o client_id de UAMI
  }))
  default   = []
  sensitive = true
}


variable "registry" {
  description = "Configuración del registry si se requiere usuario/clave (evitar si usas MI + AcrPull)."
  type = object({
    server               = string
    username             = optional(string)
    password_secret_name = optional(string)
  })
  default = null
}


variable "identity_type" {
  description = "SystemAssigned | UserAssigned | SystemAssigned,UserAssigned."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned"], var.identity_type)
    error_message = "identity_type inválido. Usa SystemAssigned, UserAssigned o SystemAssigned,UserAssigned."
  }
}

variable "user_assigned_identity_ids" {
  description = "IDs de identidades de usuario (si aplica)."
  type        = list(string)
  default     = []
}

variable "min_replicas" {
  description = "Cantidad mínima de réplicas."
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Cantidad máxima de réplicas."
  type        = number
  default     = 3
}


variable "workload_profile_name" {
  description = "Nombre del Workload Profile (si tu ACA Environment v2 lo requiere)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Etiquetas del recurso (owner, project, environment, etc.)."
  type        = map(string)
  default     = {}
}
