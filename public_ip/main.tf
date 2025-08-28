resource "azurerm_public_ip" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard" # ✅ Recomendado para alta disponibilidad
  zones               = var.zones
  tags                = var.tags
}
