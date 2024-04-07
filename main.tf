variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = "eastus"  # Ubicación del grupo de recursos
  resource_group_name = "cloud-shell-storage-eastus"  # Nombre del grupo de recursos existente
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-appservice-carlosramos-app"
  location            = "eastus"  # Ubicación del grupo de recursos
  resource_group_name = "cloud-shell-storage-eastus"  # Nombre del grupo de recursos existente
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"

    # Configuración del contenedor Docker
    app_command_line = ""
    linux_fx_version = "DOCKER|devcarlosramos/auth-api:latest"  # Aquí se especifica la imagen Docker y la etiqueta
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}
