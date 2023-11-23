terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = "tfstoragetumworkshop"
    container_name       = "tum-workshop-session1"
    key                  = "repo-0.tfstate"
    use_oidc             = true
  }

}

provider "azurerm" {
  features {}
  use_oidc = true
}
