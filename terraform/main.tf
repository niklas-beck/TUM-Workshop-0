##################################################################################
# Function App
##################################################################################
resource "azurerm_application_insights" "logging" {
  name                = "${var.basename}-ai"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"
  tags = {
    sample = "functions-storage-managed-identity"
    "CostCenter" = "SpikeReply"
  }
}

resource "azurerm_storage_account" "fxnstor" {
  name                     = "${var.basename}fx"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags = {
    sample = "functions-storage-managed-identity"
    "CostCenter" = "SpikeReply"
  }
}

resource "azurerm_app_service_plan" "fxnapp" {
  name                = "${var.basename}-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "functionapp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  tags = {
    sample = "functions-storage-managed-identity"
    "CostCenter" = "SpikeReply"
  }
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
  tags = {
    sample = "functions-storage-managed-identity"
    "CostCenter" = "SpikeReply"
  }
}