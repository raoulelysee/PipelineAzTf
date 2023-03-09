terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

#terraform cloud config
terraform {
backend "remote" {
  organization = "TerraTest-01"
  workspaces {
    name = "Pipeline_Azure_Terraform"
  }
}
}

provider "azurerm" {
  subscription_id = "99d2d43f-2a4d-4cd7-aacc-039dcbc8df01"
  client_id       = "4746ad2a-2a4c-49e2-9d6c-b08ebee2e551"
  client_secret   = "Yug8Q~iDAVUgruMPub0~Wfgo2xQ3qu1AHvsqObE-"
  tenant_id       = "ac4b9d42-9162-43af-aa5f-8e34aaccf703"
  features {}
}
 
/* #create MS Azure Provider
resource "azurerm" {
  skip_provider_registration = "true"
  features {}
} */


#create azure resource group
resource "azurerm_resource_group" "rgp1" {
  name     = "resource_gp_1"
  location = "eastus"
}

resource "azurerm_availability_set" "availability" {
  name                = "available"
  location            = azurerm_resource_group.rgp1.location
  resource_group_name = azurerm_resource_group.rgp1.name
}

resource "azurerm_virtual_network" "virtualnet" {
  name                = "virtual-net"
  location            = azurerm_resource_group.rgp1.location
  resource_group_name = azurerm_resource_group.rgp1.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                     = "subnet"
  resource_group_name = azurerm_resource_group.rgp1.name
  address_prefixes         = ["10.0.2.0/24"]
  virtual_network_name     = azurerm_virtual_network.virtualnet.name
}

resource "azurerm_network_interface" "interface" {
  name                     = "network-interface"
  location                 = azurerm_resource_group.rgp1.location
  resource_group_name = azurerm_resource_group.rgp1.name

  ip_configuration {
    name                          = "subnet"
    subnet_id                     = azurerm_subnet.subnet
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "windows-vm"
  resource_group_name = azurerm_resource_group.rgp1.name
  location            = azurerm_resource_group.rgp1.location
  size                = "Standard_F2"
  admin_username      = "owner$of$the$world"
  admin_password      = "Adm$-12%34"
  availability_set_id = azurerm_availability_set.availability
  network_interface_ids = [
    azurerm_network_interface.interface.id
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

