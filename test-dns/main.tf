resource "azurerm_resource_group" "asdt-audit" {
  name     = "asdt-audit"
  location = "UK South"
}

resource "azurerm_resource_group" "example" {
  name     = var.prefix
  location = "UK South"
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet4"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "Production"
  }
}

# DNS Zone

resource "azurerm_private_dns_zone" "privatednszone" {
  name                = "iace.mod.gov.uk"
  resource_group_name = azurerm_resource_group.asdt-audit.name
}

# DNS Entries

resource "azurerm_private_dns_a_record" "asdt" {
  for_each = var.dns_records

  name                = each.key
  zone_name           = azurerm_private_dns_zone.privatednszone.name
  resource_group_name = azurerm_resource_group.asdt-audit.name
  ttl                 = 300
  records             = [each.value]
}

# Virtual network link test

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "${var.prefix}-link"
  resource_group_name   = azurerm_resource_group.asdt-audit.name
  private_dns_zone_name = azurerm_private_dns_zone.privatednszone.name
  virtual_network_id    = azurerm_virtual_network.example.id
}
