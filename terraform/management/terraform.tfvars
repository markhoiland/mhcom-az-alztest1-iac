# Example terraform.tfvars for Management
# Copy this file to terraform.tfvars and update values for your environment
subscription_id_management = "3ed8eb5b-718e-48ed-ae2a-344533d4b616"

# Required: Resource names
automation_account_name      = "aa-alz-management"
log_analytics_workspace_name = "law-alz-management"
resource_group_name          = "rg-alz-management"

# Azure region for resources
location = "eastus"

# Log Analytics workspace retention
log_analytics_workspace_retention_in_days = 90

# Enable resource group creation
resource_group_creation_enabled = true

# Enable linked automation account
linked_automation_account_creation_enabled = true

# Enable telemetry
enable_telemetry = true

# Tags for all resources
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Purpose     = "ALZ-Management"
}

# Optional: Enable Microsoft Sentinel
# sentinel_onboarding = {
#   customer_managed_key_enabled = false
# }

# Optional: Configure Log Analytics solutions
# log_analytics_solution_plans = [
#   {
#     product   = "OMSGallery/Updates"
#     publisher = "Microsoft"
#   },
#   {
#     product   = "OMSGallery/VMInsights"
#     publisher = "Microsoft"
#   }
# ]
