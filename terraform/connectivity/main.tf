# Connectivity - ALZ Hub and Spoke Connectivity Configuration
# Using Azure Verified Module (AVM) for Azure Landing Zones Hub and Spoke VNet

terraform {
  required_version = ">= 1.12.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.4"
    }
  }

  # Configure remote backend for state management
  # Uncomment and configure for your environment
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-management"
    storage_account_name = "stmhcommgmt01"
    container_name       = "tfstate"
    key                  = "connectivity-hub-spoke.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id_connectivity
}

provider "azapi" {
  # Inherits authentication from azurerm provider
}

# ALZ Hub and Spoke Connectivity Pattern Module
# This module deploys hub and spoke network topology for Azure Landing Zones
module "hub_and_spoke" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "~> 0.16"

  # Hub virtual networks configuration
  hub_virtual_networks = var.hub_virtual_networks

  # Optional shared settings
  hub_and_spoke_networks_settings = var.hub_and_spoke_networks_settings

  # Naming conventions
  default_naming_convention          = var.default_naming_convention
  default_naming_convention_sequence = var.default_naming_convention_sequence

  # Telemetry and tags
  enable_telemetry = var.enable_telemetry
  tags             = var.tags

  # Retry and timeout configuration
  retry    = var.retry
  timeouts = var.timeouts
}
