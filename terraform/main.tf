terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Configuracion del proveedor de Azure
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Grupo de recursos donde se desplegara todo
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  # Etiqueta para identificar el entorno
  tags = {
    environment = "casopractico2"
  }
}
