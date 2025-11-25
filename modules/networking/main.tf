terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}

provider "nsxt" {
  host                 = "192.168.1.22"
  username             = "admin"
  password             = "Welkom01!123"
  allow_unverified_ssl = true
  max_retries          = 2
}

variable "edge_transport_node_display_name" {
  description = "Display name for the Edge transport node"
  type        = string
}

variable "edge_transport_node_description" {
  description = "Description applied to the Edge transport node"
  type        = string
  default     = "Terraform-managed Edge transport node"
}

variable "edge_transport_node_hostname" {
  description = "Hostname assigned within the Edge transport node settings"
  type        = string
}

variable "edge_transport_node_node_id" {
  description = "ID of a pre-deployed Edge appliance to convert into a transport node"
  type        = string
  default     = null
}

variable "edge_failure_domain_id" {
  description = "Optional failure domain backing the Edge transport node"
  type        = string
  default     = null
}

variable "edge_transport_node_host_switch_name" {
  description = "Host switch name that the Edge transport node will manage"
  type        = string
}

variable "edge_transport_node_uplink_profile_id" {
  description = "Realized ID of the uplink host switch profile applied to the Edge host switch"
  type        = string
}

variable "edge_transport_node_vtep_ha_profile_id" {
  description = "Optional realized ID of the VTEP HA host switch profile"
  type        = string
  default     = null
}

variable "overlay_transport_zone_id" {
  description = "Identifier of the overlay transport zone for the Edge transport node"
  type        = string
}

variable "edge_transport_node_transport_zone_profile_ids" {
  description = "Optional transport zone profile IDs for the overlay transport zone endpoint"
  type        = list(string)
  default     = []
}

variable "edge_transport_node_additional_transport_zone_ids" {
  description = "Additional transport zone IDs (for VLAN uplinks, etc.)"
  type        = list(string)
  default     = []
}

variable "edge_transport_node_pnic_device_name" {
  description = "Physical NIC device name (for example fp-eth0)"
  type        = string
}

variable "edge_transport_node_pnic_uplink_name" {
  description = "Logical uplink name bound to the physical NIC"
  type        = string
}

variable "edge_transport_node_use_dhcp" {
  description = "Controls whether the Edge VTEP IP is obtained via DHCP"
  type        = bool
  default     = true
}

variable "edge_transport_node_ip_pool_id" {
  description = "Static IP pool ID for the Edge VTEP (leave null when using DHCP)"
  type        = string
  default     = null
}

variable "edge_cluster_path" {
  description = "Full policy path of the NSX edge cluster to back the Tier-0 gateway"
  type        = string
}

resource "nsxt_edge_transport_node" "edge" {
  display_name = var.edge_transport_node_display_name
  description  = var.edge_transport_node_description
  failure_domain = var.edge_failure_domain_id
  node_id      = var.edge_transport_node_node_id

  standard_host_switch {
    host_switch_name = var.edge_transport_node_host_switch_name

    ip_assignment {
      assigned_by_dhcp = var.edge_transport_node_use_dhcp
      static_ip_pool   = var.edge_transport_node_ip_pool_id
    }

    transport_zone_endpoint {
      transport_zone          = var.overlay_transport_zone_id
      transport_zone_profiles = var.edge_transport_node_transport_zone_profile_ids
    }

    dynamic "transport_zone_endpoint" {
      for_each = var.edge_transport_node_additional_transport_zone_ids
      content {
        transport_zone = transport_zone_endpoint.value
      }
    }

    uplink_profile  = var.edge_transport_node_uplink_profile_id
    vtep_ha_profile = var.edge_transport_node_vtep_ha_profile_id

    pnic {
      device_name = var.edge_transport_node_pnic_device_name
      uplink_name = var.edge_transport_node_pnic_uplink_name
    }
  }

  node_settings {
    hostname = var.edge_transport_node_hostname
  }
}

resource "nsxt_policy_tier0_gateway" "tier0" {
  display_name    = "t0-gw"
  description     = "Northbound Tier-0 gateway for 192.168.1.0/24 lab"
  ha_mode         = "ACTIVE_ACTIVE"
  edge_cluster_path = var.edge_cluster_path
}

resource "nsxt_policy_tier1_gateway" "tier1" {
  display_name                = "t1-gw"
  description                 = "Tenant Tier-1 gateway attached to t0-gw"
  tier0_path                  = nsxt_policy_tier0_gateway.tier0.path
  route_advertisement_types   = ["TIER1_CONNECTED"]
  enable_firewall             = true
  default_rule_logging        = false
}


