# Azure Container Registry (ACR)
# Registro de contenedores dondo subimos las imagenes
resource "azurerm_container_registry" "acr" {
  name                = "casopractico2acr2026"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true

  # Etiqueta para identificar el entorno
  tags = {
    environment = "casopractico2"
  }
}
