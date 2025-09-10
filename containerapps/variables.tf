# --- Contexto del provider ---
variable "subscription_id" {
  description = "Azure Subscription ID."
  type        = string
}
variable "tenant_id" {
  description = "Azure Tenant ID."
  type        = string
}

# --- Identificación y relaciones ---
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

# --- Contenedor / runtime ---
variable "image" {
  description = "Imagen del contenedor (p. ej. acr.azurecr.io/repo:tag)."
  type        = string
}
variable "cpu" {
  description = "vCPU del contenedor (0.25, 0.5, 1, 2...)."
  type        = number
  default     = 0.5
}
variable "memory" {
  description = "Memoria del contenedor (formato: 1.0Gi, 2.0Gi...)."
  type        = string
  default     = "1.0Gi"
}
variable "revision_mode" {
  description = "Modo de revisiones: Single o Multiple."
  type        = string
  default     = "Single"
}

# --- Ingress (interno por defecto; APIM al frente) ---
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
  description = "Transporte de ingress: auto | http."
  type        = string
  default     = "auto"
}
variable "allow_insecure" {
  description = "Permite HTTP sin TLS (solo si es necesario)."
  type        = bool
  default     = false
}

# --- Variables de entorno / secretos ---
variable "env_vars" {
  description = "Variables de entorno en claro (clave → valor)."
  type        = map(string)
  default     = {}
}
variable "secret_env_map" {
  description = "ENV_NAME → secret_name (definidos en var.secrets)."
  type        = map(string)
  default     = {}
}
variable "secrets" {
  description = <<EOT
Secretos de la Container App. Preferir Key Vault:
- name: nombre del secreto en la App
- value: valor literal (evitar en producción)
- key_vault_secret_id: ID del secreto en Key Vault
- identity: 'system' o client_id de UAMI para traer desde KV
EOT
  type = list(object({
    name                : string
    value               : optional(string)
    key_vault_secret_id : optional(string)
    identity            : optional(string)
  }))
  default = []
}

# --- Registry (opcional; si usas MI + AcrPull, dejar null) ---
variable "registry" {
  description = "Configuración del registry si se requiere usuario/clave."
  type = object({
    server               = string
    username             = optional(string)
    password_secret_name = optional(string)
  })
  default = null
}

# --- Identidades ---
variable "identity_type" {
  description = "SystemAssigned | UserAssigned | SystemAssigned,UserAssigned."
  type        = string
  default     = "SystemAssigned"
}
variable "user_assigned_identity_ids" {
  description = "IDs de identidades de usuario (si aplica)."
  type        = list(string)
  default     = []
}

# --- Escalado HTTP básico ---
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
variable "http_concurrency" {
  description = "Concurrencia HTTP por réplica."
  type        = number
  default     = 80
}

# --- Tags obligatorias ---
variable "tags" {
  description = "Etiquetas del recurso (owner, project, environment, etc.)."
  type        = map(string)
  default     = {}
}
