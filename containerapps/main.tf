resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = var.revision_mode

  dynamic "identity" {
    for_each = [1]
    content {
      type         = var.identity_type
      identity_ids = contains(["UserAssigned", "SystemAssigned,UserAssigned"], var.identity_type) ? var.user_assigned_identity_ids : null
    }
  }

  dynamic "ingress" {
    for_each = var.ingress_enabled ? [1] : []
    content {
      external_enabled = var.ingress_external
      target_port      = var.target_port
      traffic_weight   = 100
      transport        = var.ingress_transport
      allow_insecure   = var.allow_insecure
    }
  }

  # Secretos: valor directo o Key Vault
  dynamic "secret" {
    for_each = var.secrets
    content {
      name                = secret.value.name
      value               = try(secret.value.value, null)
      key_vault_secret_id = try(secret.value.key_vault_secret_id, null)
      identity            = try(secret.value.identity, null)
    }
  }

  # Registry opcional (si usas usuario/clave). Con MI + AcrPull, deja var.registry=null.
  dynamic "registry" {
    for_each = var.registry == null ? [] : [var.registry]
    content {
      server               = registry.value.server
      username             = try(registry.value.username, null)
      password_secret_name = try(registry.value.password_secret_name, null)
    }
  }

  template {
    container {
      name   = var.name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      # ENV en claro
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      # ENV desde secretos (ENV_NAME → secret_name)
      dynamic "env" {
        for_each = var.secret_env_map
        content {
          name        = env.key
          secret_name = env.value
        }
      }
    }

    # Escalado HTTP básico (KEDA adicional puede ir en otra versión/módulo)
    scale {
      min_replicas     = var.min_replicas
      max_replicas     = var.max_replicas
      http_concurrency = var.http_concurrency
    }
  }

  tags = var.tags
}
