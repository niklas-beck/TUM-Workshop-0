##################################################################################
# GET RESOURCE GROUP
##################################################################################

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}


##################################################################################
# Function App
##################################################################################
resource "azurerm_application_insights" "logging" {
  name                = "${var.basename}-ai"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  application_type    = "web"
}

resource "azurerm_storage_account" "fxnstor" {
  name                     = "${var.basename}fx"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_service_plan" "fxnapp" {
  name                = "${var.basename}-plan"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_function_app" "fxn" {
  name                      = var.basename
  location                  = var.location
  resource_group_name       = var.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.fxnapp.id
  storage_account_name       = azurerm_storage_account.fxnstor.name
  storage_account_access_key = azurerm_storage_account.fxnstor.primary_access_key
  version                   = "~3"
  #https_only                = true # To remove to trigger trivy
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings
    ]
  }
}