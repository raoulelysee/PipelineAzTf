terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

#terraform cloud config
backend "remote" {
  organisation = "TerraTest-01"
  workspaces {
    name = "Pipeline_Azure_Terraform"
  }
}

#create MS Azure Provider
resource "azurerm" {
  skip_provider_registration = "true"
  features {}
}

#create azure container registry
resource "azurerm_container_registry" "acr" {
  name                = "1st ACR"
  resource_group_name = ""
  location            = ""
  sku                 = ""
  admin_enabled       = "false"
}
