########################################
# Locals: índice por nombre para secretos
########################################
locals {
  # Mapa nombre → objeto secreto (si var.secrets=[], queda {})
  secrets_by_name = { for s in var.secrets : s.name => s }
  # Conjunto de nombres (set(string)) — estable para for_each
  secret_names = toset(keys(local.secrets_by_name))
}

resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = var.revision_mode

  # Identidad administrada
  dynamic "identity" {
    for_each = [1]
    content {
      type         = var.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned,UserAssigned"], var.identity_type) ? var.user_assigned_identity_ids : null
    }
  }

  # Ingress
  dynamic "ingress" {
    for_each = var.ingress_enabled ? [1] : []
    content {
      external_enabled           = var.ingress_external
      target_port                = var.target_port
      transport                  = var.ingress_transport
      allow_insecure_connections = var.allow_insecure_connections

      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  # (Opcional) Workload profile (ACA Env v2)
  workload_profile_name = var.workload_profile_name

  # Secretos — for_each con set(string) + lookup en mapa
  dynamic "secret" {
    for_each = local.secret_names
    content {
      name                = secret.value
      value               = try(local.secrets_by_name[secret.value].value, null)
      key_vault_secret_id = try(local.secrets_by_name[secret.value].key_vault_secret_id, null)
      identity            = try(local.secrets_by_name[secret.value].identity, null) # 'system' o client_id de UAMI
    }
  }

  # Registry opcional
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

      # Env en claro
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      # Env desde secretos (ENV_NAME → secret_name)
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
