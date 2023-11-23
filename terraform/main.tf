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

  tags = {
    "CostCenter" = "SpikeReply"
  }
}

resource "azurerm_storage_account" "fxnstor" {
  name                     = "${var.basename}fx"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    "CostCenter" = "SpikeReply"
  }
}

resource "azurerm_service_plan" "fxnapp" {
  name                = "${var.basename}-plan"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = {
    "CostCenter" = "SpikeReply"
  }
}

resource "azurerm_linux_function_app" "fxn" {
  name                      = "funcApp-${var.basename}"
  location                  = var.location
  resource_group_name       = data.azurerm_resource_group.rg.name
  service_plan_id           = azurerm_service_plan.fxnapp.id
  storage_account_name       = azurerm_storage_account.fxnstor.name
  storage_account_access_key = azurerm_storage_account.fxnstor.primary_access_key

  site_config {}

  tags = {
    "CostCenter" = "SpikeReply"
  }
}


##################################################################################
# Outputs
##################################################################################

output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "func_app_name" {
  value   = azurerm_linux_function_app.fxn.name
}