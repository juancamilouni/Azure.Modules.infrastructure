resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = var.revision_mode

  # Identidad administrada (para RBAC posterior: AcrPull/KV)
  dynamic "identity" {
    for_each = [1]
    content {
      type         = var.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned,UserAssigned"], var.identity_type) ? var.user_assigned_identity_ids : null
    }
  }

  # Ingress (interno por defecto). Si no lo quieres, pon ingress_enabled=false.
  dynamic "ingress" {
    for_each = var.ingress_enabled ? [1] : []
    content {
      external_enabled           = var.ingress_external
      target_port                = var.target_port
      transport                  = var.ingress_transport
      allow_insecure_connections = var.allow_insecure_connections

      # Requerido por el provider: peso 100% a la última revisión
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  # (Opcional) Workload profile (ACA Env v2)
  workload_profile_name = var.workload_profile_name

  # Secretos (puede quedar vacío sin romper) — FIX con tomap()
  dynamic "secret" {
    for_each = tomap({ for s in var.secrets : s.name => s })
    content {
      name                = secret.value.name
      value               = try(secret.value.value, null)
      key_vault_secret_id = try(secret.value.key_vault_secret_id, null)
      identity            = try(secret.value.identity, null) # 'system' o client_id de UAMI
    }
  }

  # Registry opcional: si usas MI + AcrPull, dejar var.registry = null
  dynamic "registry" {
    for_each = var.registry == null ? [] : [var.registry]
    content {
      server               = registry.value.server
      username             = try(registry.value.username, null)
      password_secret_name = try(registry.value.password_secret_name, null)
    }
  }

  template {
    # En azurerm ~> 3.104, min/max_replicas van aquí
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      # Env en claro (puede estar vacío)
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      # Env desde secretos (puede estar vacío si aún no hay secretos)
      dynamic "env" {
        for_each = var.secret_env_map
        content {
          name        = env.key
          secret_name = env.value
        }
      }
    }
  }

  tags = var.tags
}
