resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", null)

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = {
    for subnet in var.subnets :
    subnet.name => subnet if contains(keys(subnet), "network_security_group_id")
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

resource "azurerm_network_watcher" "nw" {
  count               = var.enable_network_watcher ? 1 : 0
  name                = "network-watcher-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

