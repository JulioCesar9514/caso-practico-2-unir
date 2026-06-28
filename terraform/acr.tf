# Azure Container Registry (ACR)
# Registro de contenedores dondo subimos las imagenes dinamicamente
resource "random_string" "acr_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${random_string.acr_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  
  # Etiqueta para identificar el entorno
  tags = {
    environment = "casopractico2"
  }
}
