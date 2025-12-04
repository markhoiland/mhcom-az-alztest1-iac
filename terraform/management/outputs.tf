# Management Outputs

output "automation_account_id" {
  description = "The resource ID of the automation account"
  value       = module.alz_management.automation_account.id
}

output "automation_account_name" {
  description = "The name of the automation account"
  value       = module.alz_management.automation_account.name
}

output "log_analytics_workspace_id" {
  description = "The resource ID of the Log Analytics workspace"
  value       = module.alz_management.log_analytics_workspace.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  value       = module.alz_management.log_analytics_workspace.name
}

output "log_analytics_workspace_workspace_id" {
  description = "The workspace ID of the Log Analytics workspace"
  value       = module.alz_management.log_analytics_workspace.workspace_id
}

output "resource_group_id" {
  description = "The resource ID of the management resource group"
  value       = module.alz_management.resource_group.id
}

output "resource_group_name" {
  description = "The name of the management resource group"
  value       = module.alz_management.resource_group.name
}

output "data_collection_rule_ids" {
  description = "Map of data collection rule IDs"
  value       = module.alz_management.data_collection_rule_ids
}

output "user_assigned_identity_ids" {
  description = "Map of user assigned managed identity IDs"
  value       = module.alz_management.user_assigned_identity_ids
}
