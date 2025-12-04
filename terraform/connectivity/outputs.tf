# Connectivity Outputs

output "virtual_network_resource_ids" {
  description = "Resource IDs of the hub virtual networks"
  value       = module.hub_and_spoke.virtual_network_resource_ids
}

output "virtual_network_resource_names" {
  description = "Resource names of the hub virtual networks"
  value       = module.hub_and_spoke.virtual_network_resource_names
}

output "firewall_resource_ids" {
  description = "Resource IDs of the Azure Firewalls"
  value       = module.hub_and_spoke.firewall_resource_ids
}

output "firewall_resource_names" {
  description = "Resource names of the Azure Firewalls"
  value       = module.hub_and_spoke.firewall_resource_names
}

output "firewall_private_ip_addresses" {
  description = "Private IP addresses of the Azure Firewalls"
  value       = module.hub_and_spoke.firewall_private_ip_addresses
}

output "firewall_public_ip_addresses" {
  description = "Public IP addresses of the Azure Firewalls"
  value       = module.hub_and_spoke.firewall_public_ip_addresses
}

output "firewall_policies" {
  description = "Azure Firewall policies for each hub virtual network"
  value       = module.hub_and_spoke.firewall_policies
}

output "bastion_host_resource_ids" {
  description = "Resource IDs of the Azure Bastion hosts"
  value       = module.hub_and_spoke.bastion_host_resource_ids
}

output "bastion_host_dns_names" {
  description = "DNS names of the Azure Bastion hosts"
  value       = module.hub_and_spoke.bastion_host_dns_names
}

output "bastion_host_public_ip_address" {
  description = "Public IP addresses of the Azure Bastion hosts"
  value       = module.hub_and_spoke.bastion_host_public_ip_address
}

output "dns_server_ip_addresses" {
  description = "DNS server IP addresses for each hub virtual network"
  value       = module.hub_and_spoke.dns_server_ip_addresses
}

output "private_dns_zone_resource_ids" {
  description = "Resource IDs of the private DNS zones"
  value       = module.hub_and_spoke.private_dns_zone_resource_ids
}

output "route_tables_firewall" {
  description = "Route tables associated with the firewalls"
  value       = module.hub_and_spoke.route_tables_firewall
}

output "route_tables_user_subnets" {
  description = "Route tables associated with user subnets"
  value       = module.hub_and_spoke.route_tables_user_subnets
}

output "route_tables_gateway_resource_ids" {
  description = "Resource IDs of route tables associated with gateway subnets"
  value       = module.hub_and_spoke.route_tables_gateway_resource_ids
}
