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

  # 🛑 NUEVO: Bloque Workload Profiles
  dynamic "workload_profile" {
    for_each = var.workload_profiles
    content {
      name                  = workload_profile.value.name
      workload_profile_type = "Dedicated"
      minimum_count         = workload_profile.value.min_nodes
      maximum_count         = workload_profile.value.max_nodes
    }
  }
}

# 🛑 NUEVO: Recurso auxiliar para configurar el Ingress Premium
# NOTA: En la versión 3.x del provider azurerm, el timeout debe ser configurado a través de 'azurerm_container_app_environment_workload_profile' o 'azurerm_container_app_environment_workload_profile_scale', o usando un 'local-exec' para la CLI si no hay un recurso directo para el timeout. 
# Usaremos un recurso auxiliar si existe o la sintaxis de 'azurerm_resource_group_deployment' si el recurso no existe. Por simplicidad, se recomienda usar el recurso 'azurerm_resource_group_deployment' con una plantilla ARM o la CLI como último recurso.

# Para simplificar, le indico cómo se haría si existiera la propiedad directa (aunque es más complejo en la práctica)
# Si no puede usar un recurso directo, DEBE usar un local-exec con la CLI de Azure para configurar el timeout.
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