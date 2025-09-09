resource "azurerm_container_app" "app" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = var.revision_mode
  tags                         = var.tags

  # ---- Identidad (System/User Assigned) ----
  identity {
    type = (
      var.system_identity && length(var.user_assigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" :
      var.system_identity ? "SystemAssigned" :
      length(var.user_assigned_identity_ids) > 0 ? "UserAssigned" : "None"
    )
    identity_ids = var.user_assigned_identity_ids
  }

  # ---- Ingress (interno por defecto para usar detrás de APIM) ----
  ingress {
    external_enabled = var.ingress_external
    target_port      = var.target_port
    transport        = var.ingress_transport

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  # ---- Registro (si no usas MI + AcrPull) ----
  dynamic "registry" {
    for_each = var.registry_server == null ? [] : [1]
    content {
      server               = var.registry_server
      username             = var.registry_username
      password_secret_name = var.registry_password_secret
    }
  }

  # ---- Secretos: valores directos o referencias a Key Vault ----
  dynamic "secret" {
    for_each = var.secrets
    content {
      name                = secret.value.name
      value               = try(secret.value.value, null)
      key_vault_secret_id = try(secret.value.key_vault_secret_id, null)
    }
  }

  # ---- Plantilla de ejecución ----
  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "app"
      image  = var.image
      cpu    = var.container_cpu
      memory = var.container_memory

      # Env no secretas
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      # Env que referencian secretos declarados arriba
      dynamic "env" {
        for_each = var.secret_env_map
        content {
          name        = env.key
          secret_name = env.value
        }
      }
    }

    # Escalado por concurrencia HTTP (KEDA)
    http_scale_rule {
      name                = "http-concurrency"
      concurrent_requests = var.http_concurrency
    }
  }
}

# Si se pasó contraseña ACR, guardarla como secreto con el nombre indicado
resource "azurerm_container_app_secret" "acr_password" {
  count            = var.registry_password_value != null && var.registry_password_secret != null ? 1 : 0
  name             = var.registry_password_secret
  container_app_id = azurerm_container_app.app.id
  value            = var.registry_password_value
}
