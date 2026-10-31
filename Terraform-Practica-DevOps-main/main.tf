terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# SIN Service Principal ni App Registration.
# El provider usa la sesión que ya abriste con "az login" en tu terminal.
# Si tienes más de una suscripción, exporta ARM_SUBSCRIPTION_ID (opcional).
provider "azurerm" {
  features {}
}

# Sufijo aleatorio para que los nombres (que deben ser únicos en Azure)
# no choquen con los de nadie más, sin que tengas que inventarlos.
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-rg"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "st${var.project_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1" # Plan de consumo (serverless, pago por uso)
}

resource "azurerm_linux_function_app" "func" {
  name                = "${var.project_name}-func-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "node"
  }
}
