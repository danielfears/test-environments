provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

terraform {
  required_providers {
    # https://github.com/terraform-providers/terraform-provider-azurerm/releases
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.56.0"
    }
    # https://github.com/hashicorp/terraform-provider-kubernetes/releases
  }
  required_version = ">= 1.0"
}
