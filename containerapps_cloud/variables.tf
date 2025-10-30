# -------------------- Contexto --------------------
variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group de destino"
  type        = string
}


variable "name" {
  description = "Nombre de la Azure Container App (minúsculas, <=32, sin '--')"
  type        = string
}

variable "environment_id" {
  description = "ID del Azure Container Apps Environment"
  type        = string
}

variable "tags" {
  description = "Etiquetas"
  type        = map(string)
  default     = {}
}

# -------------------- Imagen / Runtime --------------------
variable "image" {
  description = "Imagen (por ejemplo: acr.azurecr.io/servicio:tag)"
  type        = string
}

variable "container_cpu" {
  description = "vCPU para el contenedor (0.25, 0.5, 1, ...)"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "Memoria (Gi), por ejemplo: 1Gi, 2Gi"
  type        = string
  default     = "1Gi"
}

# -------------------- Ingress --------------------
variable "target_port" {
  description = "Puerto del contenedor a exponer"
  type        = number
  default     = 8080
}

variable "ingress_external" {
  description = "Exponer externamente (true) o solo interno (false)"
  type        = bool
  default     = false
}

variable "ingress_transport" {
  description = "Transporte del ingress: auto | http | http2"
  type        = string
  default     = "auto"
}

# -------------------- Revisiones / Escalado --------------------
variable "revision_mode" {
  description = "Modo de revisión: Single | Multiple"
  type        = string
  default     = "Single"
}

variable "min_replicas" {
  description = "Réplicas mínimas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Réplicas máximas"
  type        = number
  default     = 3
}

variable "http_concurrency" {
  description = "Requests concurrentes por réplica para regla HTTP"
  type        = number
  default     = 60
}

# -------------------- Env vars --------------------
variable "env_vars" {
  description = "Variables de entorno no secretas"
  type        = map(string)
  default     = {}
}

variable "secret_env_map" {
  description = "Mapa ENV_NAME -> secret_name definidos en 'secrets'"
  type        = map(string)
  default     = {}
}


variable "secrets" {
  description = "Secretos (inline o referenciados por Key Vault)"
  type = list(object({
    name                = string
    value               = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "registry_server" {
  description = "Servidor del ACR (opcional si usas AcrPull via MI)"
  type        = string
  default     = null
}

variable "registry_username" {
  description = "Usuario del ACR (opcional)"
  type        = string
  default     = null
}

variable "registry_password_secret" {
  description = "Nombre del secreto para guardar el password del ACR (opcional)"
  type        = string
  default     = null
}

variable "registry_password_value" {
  description = "Password del ACR (opcional, sensible)"
  type        = string
  sensitive   = true
  default     = null
}

variable "system_identity" {
  description = "Habilitar System Assigned Managed Identity"
  type        = bool
  default     = true
}

variable "user_assigned_identity_ids" {
  description = "Lista de IDs de identidades administradas por el usuario (opcional)"
  type        = list(string)
  default     = []
}

#deploy