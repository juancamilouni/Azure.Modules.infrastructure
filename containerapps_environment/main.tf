resource "azurerm_container_app_environment" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Observabilidad: solo ID de Log Analytics en esta versión del provider
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Red (si es null => Environment público)
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled

  # Alta disponibilidad (opcional)
  zone_redundancy_enabled = var.zone_redundancy_enabled

  tags = var.tags
}
