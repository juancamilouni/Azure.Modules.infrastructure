resource "azurerm_api_management" "this" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
  }

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  tags = var.tags

  # Integración con el Key Vault para acceder a secretos
  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_api_management_api" "this" {
  count = length(var.api_names)

  name                = var.api_names[count.index]
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  revision            = "1"
  display_name        = var.api_display_names[count.index]
  path                = var.api_paths[count.index]
  protocols           = ["https"]
  service_url         = var.api_service_urls[count.index]

  depends_on = [azurerm_api_management.this]
}

resource "azurerm_api_management_api_operation" "this" {
  count = length(var.api_operations)

  operation_id        = var.api_operations[count.index]
  api_name            = azurerm_api_management_api.this[count.index].name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  display_name        = var.api_operation_display_names[count.index]
  method              = var.api_operation_methods[count.index]
  url_template        = var.api_operation_url_templates[count.index]
  response {
    status      = 200
    description = "Successful Response"
  }

  depends_on = [azurerm_api_management_api.this]
}
