resource "azurerm_container_app_environment" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Sin Log Analytics (lo podrás agregar más adelante si lo decides)
  # log_analytics_workspace_id = ...

  # Red (si es null => Environment público)
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  zone_redundancy_enabled        = var.zone_redundancy_enabled

  tags = var.tags

  # 🛑 CORRECCIÓN CLAVE: Bloque Workload Profiles
  # Este bloque activa el modo Premium Ingress en el entorno.
  dynamic "workload_profile" {
    for_each = var.workload_profiles
    content {
      name = workload_profile.value.name
      # CORRECCIÓN: Se usa el SKU específico del nodo ("D4") en lugar del genérico "Dedicated".
      workload_profile_type = "D4"
      minimum_count         = workload_profile.value.min_nodes
      maximum_count         = workload_profile.value.max_nodes
    }
  }
}

# NOTA: El siguiente bloque 'null_resource' con el 'local-exec' no es necesario
# para activar la funcionalidad Premium, solo para automatizar el timeout.
# Lo mantengo comentado aquí.
/*
resource "null_resource" "configure_premium_ingress_timeout" {
  triggers = {
    env_id = azurerm_container_app_environment.this.id
    timeout_minutes = var.request_idle_timeout_minutes
  }

  provisioner "local-exec" {
    command = <<-EOT
      az containerapp env premium-ingress update \
        --resource-group ${azurerm_container_app_environment.this.resource_group_name} \
        --name ${azurerm_container_app_environment.this.name} \
        --request-idle-timeout ${var.request_idle_timeout_minutes} \
        --workload-profile-name "${var.workload_profiles[0].name}" 
    EOT
  }
  depends_on = [azurerm_container_app_environment.this]
}
*/