locals {
  # Agrega (si corresponde) el password del ACR como secreto interno
  merged_secrets = concat(
    var.secrets,
    (
      var.registry_password_value != null && var.registry_password_secret != null
      ) ? [{
        name                = var.registry_password_secret
        value               = var.registry_password_value
        key_vault_secret_id = null
    }] : []
  )

  # Mapa estable para iterar en dynamic "secret"
  secrets_by_name = {
    for s in local.merged_secrets : s.name => s
  }
}

resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id

  # Normaliza a "Single" / "Multiple" por si llega "single" / "multiple"
  revision_mode = title(var.revision_mode)

  tags = var.tags

  # -------------------- Identidad --------------------
  identity {
    type = (
      var.system_identity && length(var.user_assigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" :
      var.system_identity ? "SystemAssigned" :
      length(var.user_assigned_identity_ids) > 0 ? "UserAssigned" : "None"
    )
    identity_ids = var.user_assigned_identity_ids
  }

  # -------------------- Ingress --------------------
  ingress {
    external_enabled = var.ingress_external
    target_port      = var.target_port
    transport        = var.ingress_transport

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  # -------------------- Registro (ACR con UAMI o con credenciales) --------------------
  dynamic "registry" {
    for_each = var.registry_server == null ? [] : [1]
    content {
      server               = var.registry_server
      username             = var.registry_username
      password_secret_name = var.registry_password_secret

      # Si usas UAMI (AcrPull), indica explícitamente la identidad.
      # El proveedor ignora null, así que no hay problema si no aplica.
      identity = (
        length(var.user_assigned_identity_ids) > 0 && var.registry_username == null
        ? var.user_assigned_identity_ids[0]
        : null
      )
    }
  }

  # -------------------- Secretos (inline o Key Vault) --------------------
  dynamic "secret" {
    for_each = local.secrets_by_name
    content {
      name                = secret.value.name
      value               = try(secret.value.value, null)
      key_vault_secret_id = try(secret.value.key_vault_secret_id, null)
    }
  }

  # -------------------- Plantilla / Contenedor --------------------
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

      # Env secretas (ENV_NAME -> secret_name)
      dynamic "env" {
        for_each = var.secret_env_map
        content {
          name        = env.key
          secret_name = env.value
        }
      }
    }

    # Regla de escalado HTTP básica
    http_scale_rule {
      name                = "http-concurrency"
      concurrent_requests = var.http_concurrency
    }
  }
}
