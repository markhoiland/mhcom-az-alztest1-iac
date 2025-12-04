# Management - ALZ Management Configuration
# Using Azure Verified Module (AVM) for Azure Landing Zones Management

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
    key                  = "management-alz-mgmt.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }
  subscription_id = var.subscription_id_management
}

provider "azapi" {
  # Inherits authentication from azurerm provider
}

# ALZ Management Pattern Module
# This module deploys the management resources for Azure Landing Zones
module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.9"

  # Required parameters
  automation_account_name      = var.automation_account_name
  location                     = var.location
  log_analytics_workspace_name = var.log_analytics_workspace_name
  resource_group_name          = var.resource_group_name

  # Optional parameters
  automation_account_encryption                              = var.automation_account_encryption
  automation_account_identity                                = var.automation_account_identity
  automation_account_local_authentication_enabled            = var.automation_account_local_authentication_enabled
  automation_account_public_network_access_enabled           = var.automation_account_public_network_access_enabled
  automation_account_sku_name                                = var.automation_account_sku_name
  enable_telemetry                                           = var.enable_telemetry
  linked_automation_account_creation_enabled                 = var.linked_automation_account_creation_enabled
  log_analytics_solution_plans                               = var.log_analytics_solution_plans
  log_analytics_workspace_allow_resource_only_permissions    = var.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_local_authentication_enabled       = var.log_analytics_workspace_local_authentication_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  log_analytics_workspace_retention_in_days                  = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku
  resource_group_creation_enabled                            = var.resource_group_creation_enabled
  sentinel_onboarding                                        = var.sentinel_onboarding
  tags                                                       = var.tags

  # Note: data_collection_rules and user_assigned_managed_identities use module defaults
  # which include required attributes (vm_insights for DCR, ama for UAMI)
}
