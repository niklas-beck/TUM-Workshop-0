#Set the terraform required version
terraform {
  required_version = "~> 1.6.4"
  required_providers {
    # It is recommended to pin to a given version of the Provider
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.81.0"
    }

    random = {
      version = "~>2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-statefile"
    storage_account_name = "terraformstorage543"
    container_name       = "tum-workshop-session1"
    key                  = "tumworkshop-0.tfstate"
  }

}

provider "azurerm" {
  features {}
}

# Data

# Make client_id, tenant_id, subscription_id and object_id variables
#data "azurerm_client_config" "current" {}