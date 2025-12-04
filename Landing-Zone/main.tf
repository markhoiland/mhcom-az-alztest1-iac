# Landing Zone - Core ALZ Configuration
# Using Azure Verified Module (AVM) for Azure Landing Zones

terraform {
  required_version = ">= 1.12.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
    alz = {
      source  = "azure/alz"
      version = "~> 0.20"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.4"
    }
  }

  # Configure remote backend for state management
  # Uncomment and configure for your environment
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "stterraformstate"
  #   container_name       = "tfstate"
  #   key                  = "alz-landing-zone.tfstate"
  # }
}

provider "azurerm" {
  features {}

  # OIDC authentication is configured via environment variables:
  # ARM_CLIENT_ID, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
  # ARM_USE_OIDC=true
}

# ALZ provider configuration
# Uses official ALZ library for policies and archetypes
provider "alz" {
  library_references = [
    {
      path = "platform/alz"
      ref  = "2025.09.0"
    }
  ]
}

provider "azapi" {
  # Inherits authentication from azurerm provider
}

# Get the current Azure configuration for tenant ID
data "azapi_client_config" "current" {}

# Azure Landing Zones Pattern Module
module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.15"

  # Core ALZ architecture
  architecture_name  = "alz"
  location           = var.location
  parent_resource_id = var.root_management_group_id != null ? var.root_management_group_id : data.azapi_client_config.current.tenant_id

  # Optional configurations
  subscription_placement       = var.subscription_placement
  policy_assignments_to_modify = var.policy_assignments_to_modify
  policy_default_values        = var.policy_default_values
  timeouts                     = var.timeouts
}

