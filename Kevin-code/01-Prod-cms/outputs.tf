# Data source to access the properties of an existing Azure Public IP Address
data "azurerm_public_ip" "prod-cms" {
  name                = azurerm_public_ip.prod-cms.name
  resource_group_name = azurerm_linux_virtual_machine.prod-cms.resource_group_name
}

# Output variable: Public IP address
output "public_ip" {
  value = data.azurerm_public_ip.prod-cms.ip_address
}
