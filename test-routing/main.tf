# Resource Group 1

resource "azurerm_resource_group" "rg1" {
  name     = "${var.prefix}-rg1"
  location = var.location
}


# Virtual Network 1

resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-vnet1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.1.0/16"]
}

resource "azurerm_subnet" "vnet1subnet1" {
  name                 = "${var.prefix}-vnet1subnet1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Virtual Network 2

# resource "azurerm_virtual_network" "vnet2" {
#   name                = "${var.prefix}-vnet2"
#   location            = azurerm_resource_group.rg1.location
#   resource_group_name = azurerm_resource_group.rg1.name
#   address_space       = ["10.0.2.0/16"]
# }

# resource "azurerm_subnet" "vnet2subnet1" {
#   name                 = "${var.prefix}-vnet2subnet1"
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.vnet2.name
#   address_prefixes     = ["10.0.2.0/24"]
# }



# Virtual Machine 1

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "${var.prefix}-vm1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.vm1-nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "vm1-nic1" {
  name                = "${var.prefix}-vm1-nic1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet1subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip1.ip_address
  }
}

resource "azurerm_public_ip" "pip1" {
  name                = "${var.prefix}-pip1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}


# Virtual Machine 2

resource "azurerm_windows_virtual_machine" "vm2" {
  name                = "${var.prefix}-vm2"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.vm2-nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "vm2-nic1" {
  name                = "${var.prefix}-vm2-nic1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet2subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip2.ip_address
  }
}

resource "azurerm_public_ip" "pip2" {
  name                = "${var.prefix}-pip2"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# Network Security

resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-nsg1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_network_security_rule" "allow_specific_ip_inbound" {
  name                        = "allow-inbound-from-my-ip"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${data.external.current_ip.result.ip}/32" # Replace with your specific IP address
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg1.name
  resource_group_name         = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet_network_security_group_association" "vnet1subnet1-nsg1" {
  subnet_id                 = azurerm_subnet.vnet1subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
resource "azurerm_subnet_network_security_group_association" "vnet2subnet1-nsg1" {
  subnet_id                 = azurerm_subnet.vnet2subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
