# Management Variables

variable "automation_account_name" {
  description = "The name of the automation account"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "eastus"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for management resources"
  type        = string
}

variable "automation_account_encryption" {
  description = "Encryption settings for the automation account"
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = optional(string, null)
  })
  default  = null
  nullable = true
}

variable "automation_account_identity" {
  description = "Identity configuration for the automation account"
  type = object({
    type         = string
    identity_ids = optional(set(string), null)
  })
  default  = null
  nullable = true
}

variable "automation_account_local_authentication_enabled" {
  description = "Enable local authentication for the automation account"
  type        = bool
  default     = true
}

variable "automation_account_public_network_access_enabled" {
  description = "Enable public network access for the automation account"
  type        = bool
  default     = true
}

variable "automation_account_sku_name" {
  description = "The SKU name for the automation account"
  type        = string
  default     = "Basic"
}

variable "data_collection_rules" {
  description = "Map of data collection rules to create"
  type = map(object({
    name               = string
    description        = optional(string, null)
    destinations       = any
    data_flows         = any
    data_sources       = optional(any, null)
    kind               = optional(string, null)
    stream_declaration = optional(any, null)
    tags               = optional(map(string), null)
  }))
  default = {}
}

variable "enable_telemetry" {
  description = "Enable telemetry for the module"
  type        = bool
  default     = true
}

variable "linked_automation_account_creation_enabled" {
  description = "Enable linked automation account creation"
  type        = bool
  default     = true
}

variable "log_analytics_solution_plans" {
  description = "List of Log Analytics solution plans to deploy"
  type = list(object({
    product   = string
    publisher = optional(string, "Microsoft")
  }))
  default = [
    {
      product   = "OMSGallery/Updates"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/VMInsights"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/ChangeTracking"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/Security"
      publisher = "Microsoft"
    }
  ]
}

variable "log_analytics_workspace_allow_resource_only_permissions" {
  description = "Allow resource-only permissions for the Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  description = "Force CMK for query on the Log Analytics workspace"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_daily_quota_gb" {
  description = "Daily quota in GB for the Log Analytics workspace (-1 for unlimited)"
  type        = number
  default     = -1
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  description = "Enable internet ingestion for the Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_internet_query_enabled" {
  description = "Enable internet query for the Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_local_authentication_enabled" {
  description = "Enable local authentication for the Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_reservation_capacity_in_gb_per_day" {
  description = "Reservation capacity in GB per day for the Log Analytics workspace"
  type        = number
  default     = null
  nullable    = true
}

variable "log_analytics_workspace_retention_in_days" {
  description = "Retention period in days for the Log Analytics workspace"
  type        = number
  default     = 30
}

variable "log_analytics_workspace_sku" {
  description = "The SKU for the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "resource_group_creation_enabled" {
  description = "Enable resource group creation by the module"
  type        = bool
  default     = true
}

variable "sentinel_onboarding" {
  description = "Configuration for Microsoft Sentinel onboarding"
  type = object({
    customer_managed_key_enabled = optional(bool, false)
  })
  default  = null
  nullable = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "user_assigned_managed_identities" {
  description = "Map of user assigned managed identities to create"
  type = map(object({
    name = string
    tags = optional(map(string), null)
  }))
  default = {}
}
