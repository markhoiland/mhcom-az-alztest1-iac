# Connectivity Variables

variable "subscription_id_connectivity" {
  description = "Azure subscription ID for connectivity resources"
  type        = string
  sensitive   = true
}

variable "hub_virtual_networks" {
  description = <<DESCRIPTION
A map of hub networks to create. Each hub network requires a location and can optionally configure:
- enabled_resources: Control which resources are created (firewall, bastion, gateways, DNS zones, etc.)
- default_hub_address_space: The default address space for the hub network (e.g., "10.0.0.0/16")
- default_parent_id: The resource group ID where resources will be created
- hub_virtual_network: Virtual network configuration including subnets, route tables, and peering
- firewall: Azure Firewall configuration
- firewall_policy: Azure Firewall Policy settings
- bastion: Azure Bastion configuration
- virtual_network_gateways: VPN and ExpressRoute gateway settings
- private_dns_zones: Private DNS zone configuration
- private_dns_resolver: DNS resolver settings

Example:
hub_virtual_networks = {
  primary = {
    location                  = "eastus"
    default_hub_address_space = "10.0.0.0/16"
    default_parent_id         = "/subscriptions/.../resourceGroups/rg-hub-primary"
    enabled_resources = {
      firewall                              = true
      bastion                               = true
      virtual_network_gateway_vpn           = true
      virtual_network_gateway_express_route = false
      private_dns_zones                     = true
      private_dns_resolver                  = true
    }
  }
}
DESCRIPTION
  type = map(object({
    enabled_resources = optional(object({
      firewall                              = optional(bool, true)
      firewall_policy                       = optional(bool, true)
      bastion                               = optional(bool, true)
      virtual_network_gateway_express_route = optional(bool, true)
      virtual_network_gateway_vpn           = optional(bool, true)
      private_dns_zones                     = optional(bool, true)
      private_dns_resolver                  = optional(bool, true)
    }), {})

    default_hub_address_space = optional(string)
    default_parent_id         = optional(string)
    location                  = string

    hub_virtual_network = optional(object({
      name                          = optional(string)
      address_space                 = optional(list(string))
      parent_id                     = optional(string)
      route_table_name_firewall     = optional(string)
      route_table_name_user_subnets = optional(string)
      bgp_community                 = optional(string)
      ddos_protection_plan_id       = optional(string)
      dns_servers                   = optional(list(string))
      flow_timeout_in_minutes       = optional(number, 4)
      mesh_peering_enabled          = optional(bool, true)
      peering_names                 = optional(map(string))
      routing_address_space         = optional(list(string), [])
      hub_router_ip_address         = optional(string)
      tags                          = optional(map(string))

      route_table_entries_firewall = optional(set(object({
        name                = string
        address_prefix      = string
        next_hop_type       = string
        has_bgp_override    = optional(bool, false)
        next_hop_ip_address = optional(string)
      })), [])

      route_table_entries_user_subnets = optional(set(object({
        name                = string
        address_prefix      = string
        next_hop_type       = string
        has_bgp_override    = optional(bool, false)
        next_hop_ip_address = optional(string)
      })), [])

      subnets = optional(map(object({
        name             = string
        address_prefixes = list(string)
        nat_gateway = optional(object({
          id = string
        }))
        network_security_group = optional(object({
          id = string
        }))
        private_endpoint_network_policies_enabled     = optional(bool, true)
        private_link_service_network_policies_enabled = optional(bool, true)
        route_table = optional(object({
          id                           = optional(string)
          assign_generated_route_table = optional(bool, true)
        }))
        service_endpoints_with_location = optional(list(object({
          service   = string
          locations = optional(list(string))
        })))
        service_endpoint_policy_ids     = optional(set(string))
        delegations                     = optional(list(object({ name = string, service_delegation = object({ name = string, actions = optional(list(string)) }) })))
        default_outbound_access_enabled = optional(bool, false)
      })), {})
    }), {})

    firewall = optional(object({
      name                                              = optional(string)
      resource_group_name                               = optional(string)
      sku_name                                          = optional(string, "AZFW_VNet")
      sku_tier                                          = optional(string, "Standard")
      subnet_address_prefix                             = optional(string)
      subnet_default_outbound_access_enabled            = optional(bool, false)
      firewall_policy_id                                = optional(string, null)
      management_ip_enabled                             = optional(bool, true)
      management_subnet_address_prefix                  = optional(string, null)
      management_subnet_default_outbound_access_enabled = optional(bool, false)
      private_ip_ranges                                 = optional(list(string))
      subnet_route_table_id                             = optional(string)
      tags                                              = optional(map(string))
      zones                                             = optional(list(string))
      default_ip_configuration                          = optional(any, {})
      ip_configurations                                 = optional(any, {})
      management_ip_configuration                       = optional(any, {})
    }), {})

    firewall_policy = optional(object({
      name                              = optional(string)
      resource_group_name               = optional(string)
      sku                               = optional(string, "Standard")
      auto_learn_private_ranges_enabled = optional(bool)
      base_policy_id                    = optional(string)
      location                          = optional(string)
      dns                               = optional(any)
      explicit_proxy                    = optional(any)
      identity                          = optional(any)
      insights                          = optional(any)
      intrusion_detection               = optional(any)
      private_ip_ranges                 = optional(list(string))
      sql_redirect_allowed              = optional(bool, false)
      threat_intelligence_mode          = optional(string, "Alert")
      threat_intelligence_allowlist     = optional(any)
      tls_certificate                   = optional(any)
    }), {})

    bastion = optional(object({
      subnet_address_prefix                  = optional(string)
      subnet_default_outbound_access_enabled = optional(bool, false)
      name                                   = optional(string)
      copy_paste_enabled                     = optional(bool, false)
      file_copy_enabled                      = optional(bool, false)
      ip_connect_enabled                     = optional(bool, false)
      kerberos_enabled                       = optional(bool, false)
      scale_units                            = optional(number, 2)
      shareable_link_enabled                 = optional(bool, false)
      sku                                    = optional(string, "Standard")
      tags                                   = optional(map(string), null)
      tunneling_enabled                      = optional(bool, false)
      zones                                  = optional(set(string), null)
      bastion_public_ip                      = optional(any, {})
    }), {})

    virtual_network_gateways = optional(object({
      subnet_address_prefix                     = optional(string)
      subnet_default_outbound_access_enabled    = optional(bool, false)
      route_table_creation_enabled              = optional(bool, false)
      route_table_name                          = optional(string)
      route_table_bgp_route_propagation_enabled = optional(bool, false)
      express_route                             = optional(any, {})
      vpn                                       = optional(any, {})
    }), {})

    private_dns_zones = optional(object({
      parent_id                                                  = optional(string)
      auto_registration_zone_enabled                             = optional(bool, true)
      auto_registration_zone_name                                = optional(string, null)
      auto_registration_zone_parent_id                           = optional(string, null)
      private_link_excluded_zones                                = optional(set(string), [])
      private_link_private_dns_zones                             = optional(any)
      private_link_private_dns_zones_additional                  = optional(any)
      private_link_private_dns_zones_regex_filter                = optional(any)
      virtual_network_link_default_virtual_networks              = optional(any)
      virtual_network_link_additional_virtual_networks           = optional(any)
      virtual_network_link_by_zone_and_virtual_network           = optional(any)
      virtual_network_link_overrides_by_zone                     = optional(any)
      virtual_network_link_overrides_by_virtual_network          = optional(any)
      virtual_network_link_overrides_by_zone_and_virtual_network = optional(any)
      virtual_network_link_name_template                         = optional(string, null)
      virtual_network_link_resolution_policy_default             = optional(string)
      tags                                                       = optional(map(string), null)
    }), {})

    private_dns_resolver = optional(object({
      name                                   = optional(string)
      resource_group_name                    = optional(string)
      subnet_address_prefix                  = optional(string)
      subnet_name                            = optional(string, "dns-resolver")
      subnet_default_outbound_access_enabled = optional(bool, false)
      default_inbound_endpoint_enabled       = optional(bool, true)
      ip_address                             = optional(string, null)
      inbound_endpoints                      = optional(any, {})
      outbound_endpoints                     = optional(any, {})
      tags                                   = optional(map(string), null)
    }), {})
  }))
  default = {}
}

variable "hub_and_spoke_networks_settings" {
  description = <<DESCRIPTION
Shared settings for hub and spoke networks. This is where global resources are defined
that can be shared across multiple hub networks.

- enabled_resources: Control which shared resources are created (e.g., DDoS protection plan)
- ddos_protection_plan: Configuration for the shared DDoS protection plan
DESCRIPTION
  type = object({
    enabled_resources = optional(object({
      ddos_protection_plan = optional(bool, true)
    }), {})
    ddos_protection_plan = optional(object({
      name                = optional(string)
      location            = optional(string)
      resource_group_name = optional(string)
      tags                = optional(map(string), null)
    }), {})
  })
  default = {}
}

variable "default_naming_convention" {
  description = <<DESCRIPTION
Default naming conventions for resources. Available placeholders:
- $${location}: The location of the resource
- $${sequence}: A sequence number for uniqueness
DESCRIPTION
  type = object({
    virtual_network_name                                        = optional(string, "vnet-hub-$${location}-$${sequence}")
    firewall_name                                               = optional(string, "fw-hub-$${location}-$${sequence}")
    firewall_policy_name                                        = optional(string, "fwp-hub-$${location}-$${sequence}")
    firewall_public_ip_name                                     = optional(string, "pip-fw-hub-$${location}-$${sequence}")
    firewall_management_public_ip_name                          = optional(string, "pip-fw-hub-mgmt-$${location}-$${sequence}")
    route_table_firewall_name                                   = optional(string, "rt-hub-fw-$${location}-$${sequence}")
    route_table_user_subnets_name                               = optional(string, "rt-hub-std-$${location}-$${sequence}")
    virtual_network_gateway_express_route_name                  = optional(string, "vgw-hub-er-$${location}-$${sequence}")
    virtual_network_gateway_express_route_ip_configuration_name = optional(string, "ipcfg-vgw-hub-er-$${location}-$${sequence}")
    virtual_network_gateway_express_route_public_ip_name        = optional(string, "pip-vgw-hub-er-$${location}-$${sequence}")
    virtual_network_gateway_vpn_name                            = optional(string, "vgw-hub-vpn-$${location}-$${sequence}")
    virtual_network_gateway_vpn_ip_configuration_name           = optional(string, "ipcfg-vgw-hub-vpn-$${location}-$${sequence}")
    virtual_network_gateway_vpn_public_ip_name                  = optional(string, "pip-vgw-hub-vpn-$${location}-$${sequence}")
    virtual_network_gateway_route_table_name                    = optional(string, "rt-hub-gateway-$${location}-$${sequence}")
    private_dns_resolver_name                                   = optional(string, "pdr-hub-$${location}-$${sequence}")
    bastion_host_name                                           = optional(string, "bas-hub-$${location}-$${sequence}")
    bastion_host_public_ip_name                                 = optional(string, "pip-bas-hub-$${location}-$${sequence}")
    ddos_protection_plan_name                                   = optional(string, "ddos-hub-$${location}-$${sequence}")
  })
  default = {}
}

variable "default_naming_convention_sequence" {
  description = "Defines the starting number and padded length for the sequence placeholder in naming conventions."
  type = object({
    starting_number = number
    padding_format  = string
  })
  default = {
    starting_number = 1
    padding_format  = "%03d"
  }
}

variable "enable_telemetry" {
  description = "Enable telemetry for the module. For more information see https://aka.ms/avm/telemetryinfo"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources created by this module"
  type        = map(string)
  default     = {}
}

variable "retry" {
  description = "Retry configuration for resource operations"
  type = object({
    error_message_regex  = optional(list(string), ["ReferencedResourceNotProvisioned"])
    interval_seconds     = optional(number, 10)
    max_interval_seconds = optional(number, 180)
  })
  default = {}
}

variable "timeouts" {
  description = "Timeouts for resource operations"
  type = object({
    create = optional(string, "60m")
    read   = optional(string, "5m")
    update = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = {}
}
