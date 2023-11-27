##################################################################################
# Storage Account
##################################################################################
resource "azurerm_storage_account" "storage_account" {
  name                     = var.basename
  resource_group_name      = data.azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  location = var.location
  tags = {
    "CostCenter" = "SpikeReply"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "container1"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

##################################################################################
# Upload Files
##################################################################################

resource "azurerm_storage_blob" "blob" {
  for_each = fileset(path.module, "file_uploads/*")
 
  name                   = trimprefix(each.key, "file_uploads/")
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = each.key
}

##################################################################################
# Role Assignments
##################################################################################

// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-owner
// Provides full access to Azure Storage blob containers and data
resource "azurerm_role_assignment" "functionToStorage" {
  scope              = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.fxn.identity[0].principal_id
}