# Set the Azure Provider source and version being used
terraform {
  required_version = ">= 0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1.0"
    }
  }
}

# Configure the Microsoft Azure provider
provider "azurerm" {
  features {}
}

# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "prod-cms" {
  name     = "my-terraform-rg"
  location = "West Europe"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "prod-cms" {
  name                = "my-terraform-vnet"
  location            = azurerm_resource_group.prod-cms.location
  resource_group_name = azurerm_resource_group.prod-cms.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "prod-cms" {
  name                 = "my-terraform-subnet"
  resource_group_name  = azurerm_resource_group.prod-cms.name
  virtual_network_name = azurerm_virtual_network.prod-cms.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "prod-cms" {
  name                = "my-terraform-public-ip"
  location            = azurerm_resource_group.prod-cms.location
  resource_group_name = azurerm_resource_group.prod-cms.name
  allocation_method   = "Static"

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "prod-cms" {
  name                = "my-terraform-nsg"
  location            = azurerm_resource_group.prod-cms.location
  resource_group_name = azurerm_resource_group.prod-cms.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.server_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Network Interface
resource "azurerm_network_interface" "prod-cms" {
  name                = "my-terraform-nic"
  location            = azurerm_resource_group.prod-cms.location
  resource_group_name = azurerm_resource_group.prod-cms.name

  ip_configuration {
    name                          = "my-terraform-nic-ip"
    subnet_id                     = azurerm_subnet.prod-cms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.prod-cms.id
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "prod-cms" {
  network_interface_id      = azurerm_network_interface.prod-cms.id
  network_security_group_id = azurerm_network_security_group.prod-cms.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "prod-cms" {
  name                            = "my-terraform-vm"
  location                        = azurerm_resource_group.prod-cms.location
  resource_group_name             = azurerm_resource_group.prod-cms.name
  network_interface_ids           = [azurerm_network_interface.prod-cms.id]
  size                            = "Standard_DS1_v2"
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "my-terraform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment = "my-terraform-env"
  }
}

# Configurate to run automated tasks in the VM start-up
resource "azurerm_virtual_machine_extension" "prod-cms" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.prod-cms.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "commandToExecute": "echo 'prod-cms' > index.html ; nohup busybox httpd -f -p ${var.server_port} &"
    }
  SETTINGS

  tags = {
    environment = "my-terraform-env"
  }
}
