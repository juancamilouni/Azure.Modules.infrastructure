# -------- Contexto / Provider --------
variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

# (NO location: ya no se configura en azurerm_container_app)

# -------- App / Environment --------
variable "name" {
  description = "Nombre de la Azure Container App"
  type        = string
}

variable "environment_id" {
  description = "ID del Azure Container Apps Environment"
  type        = string
}

# -------- Runtime / Imagen --------
variable "image" {
  description = "Imagen del contenedor (p.ej. myacr.azurecr.io/api:1.0.0)"
  type        = string
}

variable "container_cpu" {
  description = "vCPU asignadas al contenedor"
  type        = number
  default     = 0.5
}

variable "container_memory" {
  description = "Memoria asignada al contenedor (GiB). Ej: 1Gi, 2Gi"
  type        = string
  default     = "1Gi"
}

# -------- Ingress --------
variable "target_port" {
  description = "Puerto expuesto por el contenedor"
  type        = number
  default     = 8080
}

variable "ingress_external" {
  description = "Exponer públicamente (true) o solo interno (false)"
  type        = bool
  default     = false
}

variable "ingress_transport" {
  description = "Transporte del ingress: auto | http | http2"
  type        = string
  default     = "auto"
}

# -------- Revisiones y Escalado --------
variable "revision_mode" {
  description = "Modo de revisiones: single | multiple"
  type        = string
  default     = "single"
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
  description = "Requests concurrentes por réplica para escalado HTTP"
  type        = number
  default     = 60
}

# -------- Variables de entorno --------
variable "env_vars" {
  description = "Variables de entorno no secretas (clave/valor)"
  type        = map(string)
  default     = {}
}

variable "secret_env_map" {
  description = "Mapa ENV_NAME -> secret_name definido en 'secrets'"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Lista de secretos: value directo o referencia a Key Vault"
  type = list(object({
    name                = string
    value               = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

# -------- Registro de contenedores (opcional si usas MI con AcrPull) --------
variable "registry_server" {
  description = "Servidor del ACR (p.ej. myacr.azurecr.io) [opcional]"
  type        = string
  default     = null
}

variable "registry_username" {
  description = "Usuario del ACR (si no usas Managed Identity) [opcional]"
  type        = string
  default     = null
}

variable "registry_password_secret" {
  description = "Nombre del secreto interno que almacenará la contraseña del ACR"
  type        = string
  default     = null
}

variable "registry_password_value" {
  description = "Contraseña del ACR (sensible) [opcional]"
  type        = string
  sensitive   = true
  default     = null
}

# -------- Identidad --------
variable "system_identity" {
  description = "Habilitar System Assigned Identity"
  type        = bool
  default     = true
}

variable "user_assigned_identity_ids" {
  description = "Lista de IDs de User Assigned Identity"
  type        = list(string)
  default     = []
}

# -------- Tags --------
variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}
