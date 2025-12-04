# Landing Zone Variables

variable "subscription_id_management" {
  description = "Azure subscription ID for management resources"
  type        = string
  sensitive   = true
}

variable "root_management_group_id" {
  description = "The ID of the root management group (typically the Tenant Root Group). Do not include the full resource path, just the name/ID. If not provided, uses the tenant ID."
  type        = string
  default     = null
  nullable    = true
}

variable "location" {
  description = "The default Azure region for policy managed identities"
  type        = string
  default     = "eastus"
}

variable "subscription_placement" {
  description = "Map of subscriptions to place into management groups. The key is arbitrary, the value requires subscription_id and management_group_name."
  type = map(object({
    subscription_id       = string
    management_group_name = string
  }))
  default = {}
}

variable "policy_assignments_to_modify" {
  description = "A map of policy assignment objects to modify the ALZ architecture with. Keyed by management group ID."
  type = map(object({
    policy_assignments = map(object({
      enforcement_mode = optional(string, null)
      identity         = optional(string, null)
      identity_ids     = optional(list(string), null)
      parameters       = optional(map(string), null)
      non_compliance_messages = optional(set(object({
        message                        = string
        policy_definition_reference_id = optional(string, null)
      })), null)
      resource_selectors = optional(list(object({
        name = string
        resource_selector_selectors = optional(list(object({
          kind   = string
          in     = optional(set(string), null)
          not_in = optional(set(string), null)
        })), [])
      })), null)
      overrides = optional(list(object({
        kind  = string
        value = string
        override_selectors = optional(list(object({
          kind   = string
          in     = optional(set(string), null)
          not_in = optional(set(string), null)
        })), [])
      })), null)
    }))
  }))
  default = {}
}

variable "policy_default_values" {
  description = "Default values for policy parameters. Map of parameter name to JSON-encoded value."
  type        = map(any)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configuration for management group and policy operations"
  type = object({
    management_group = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    role_definition = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    role_assignment = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    policy_definition = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    policy_set_definition = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    policy_assignment = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    hierarchy_settings = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
    subscription_placement = optional(object({
      create = optional(string, "60m")
      delete = optional(string, "5m")
      update = optional(string, "5m")
      read   = optional(string, "60m")
    }), {})
  })
  default = {}
}
