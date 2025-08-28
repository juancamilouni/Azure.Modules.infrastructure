# Crea múltiples Resource Groups. La lista viene por variable.
resource "azurerm_resource_group" "this" {
  for_each = toset(var.resource_group_names)

  name     = each.value
  location = var.location
  tags     = var.tags
}
