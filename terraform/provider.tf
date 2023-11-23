terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-statefile"
    storage_account_name = "terraformstorage543"
    container_name       = "tum-workshop-session1"
    key                  = "tumworkshop-0.tfstate"
    use_oidc             = true
  }

}

provider "azurerm" {
  features {}
  use_oidc = true
}
