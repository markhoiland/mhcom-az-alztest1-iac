# Example terraform.tfvars for Connectivity Hub and Spoke
# Copy this file to terraform.tfvars and update values for your environment

# Required: Connectivity subscription ID
subscription_id_connectivity = "00000000-0000-0000-0000-000000000000"

# Hub virtual networks configuration
# This example creates a primary hub in East US with basic connectivity resources
hub_virtual_networks = {
  primary = {
    location                  = "eastus"
    default_hub_address_space = "10.0.0.0/16"
    # default_parent_id = "/subscriptions/<subscription-id>/resourceGroups/rg-hub-primary"

    # Control which resources are created
    enabled_resources = {
      firewall                              = true
      firewall_policy                       = true
      bastion                               = true
      virtual_network_gateway_vpn           = false
      virtual_network_gateway_express_route = false
      private_dns_zones                     = true
      private_dns_resolver                  = true
    }

    # Firewall configuration
    firewall = {
      sku_tier              = "Standard"
      subnet_address_prefix = "10.0.0.0/26"
    }

    # Bastion configuration
    bastion = {
      subnet_address_prefix = "10.0.1.0/26"
      sku                   = "Standard"
    }

    # Private DNS resolver configuration
    private_dns_resolver = {
      subnet_address_prefix = "10.0.2.0/28"
    }

    # Gateway configuration (if enabled)
    # virtual_network_gateways = {
    #   subnet_address_prefix = "10.0.3.0/27"
    #   vpn = {
    #     sku = "VpnGw1AZ"
    #   }
    # }
  }

  # Optional: Secondary hub for multi-region deployments
  # secondary = {
  #   location                  = "westus2"
  #   default_hub_address_space = "10.1.0.0/16"
  #   enabled_resources = {
  #     firewall                              = true
  #     firewall_policy                       = true
  #     bastion                               = false
  #     virtual_network_gateway_vpn           = false
  #     virtual_network_gateway_express_route = false
  #     private_dns_zones                     = false
  #     private_dns_resolver                  = false
  #   }
  #   firewall = {
  #     sku_tier              = "Standard"
  #     subnet_address_prefix = "10.1.0.0/26"
  #   }
  # }
}

# Shared settings for all hub networks
hub_and_spoke_networks_settings = {
  enabled_resources = {
    ddos_protection_plan = false # Set to true in production
  }
}

# Enable telemetry
enable_telemetry = true

# Tags for all resources
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Purpose     = "ALZ-Connectivity"
}
