terraform {
  required_version = "~>1.5.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.64.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

