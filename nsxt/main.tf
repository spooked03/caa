provider "nsxt" {
  host                 = var.nsx_host
  username             = var.nsx_username
  password             = var.nsx_password
  allow_unverified_ssl = var.allow_unverified_ssl
}

# Data Sources
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = var.transport_zone_overlay_name
}

data "nsxt_policy_transport_zone" "vlan_tz" {
  display_name = var.transport_zone_vlan_name
}

# Edge Cluster Profile
# Using variable for profile path as resource/data source is not easily guessable without docs
# resource "nsxt_policy_edge_cluster_profile" "profile" { ... }

data "nsxt_policy_uplink_host_switch_profile" "uplink_profile" {
  display_name = var.edge_uplink_profile_name
}

# Edge Node (MP API Resource)
resource "nsxt_edge_transport_node" "edge_node_1" {
  display_name = var.edge_node_name
  description  = "Edge Node 1"
  
  deployment_config {
    form_factor = "MEDIUM"
    node_user_settings {
      cli_password   = var.nsx_password
      root_password  = var.nsx_password
      audit_password = var.nsx_password
    }
    vm_deployment_config {
      vc_id                 = var.vc_id
      compute_id            = var.compute_cluster_id
      storage_id            = var.datastore_id
      management_network_id = var.management_network_id
      data_network_ids      = var.edge_node_data_network_ids
      management_port_subnet {
        ip_addresses  = [var.edge_node_ip]
        prefix_length = 24
      }
      default_gateway_address = [var.edge_node_gateway]
    }
  }

  node_settings {
    hostname = var.edge_node_hostname
  }

  standard_host_switch {
    host_switch_name = "nsx-edge-switch"
    host_switch_profile = [data.nsxt_policy_uplink_host_switch_profile.uplink_profile.id]
    
    # IP Assignment for TEPs
    ip_assignment {
      assigned_by_dhcp = true
    }
    # Transport Zones
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_tz.id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.vlan_tz.id
    }
  }
}

# Edge Cluster
resource "nsxt_policy_edge_cluster" "main" {
  display_name              = var.edge_cluster_name
  description               = "Edge Cluster created via Terraform"
  edge_cluster_profile_path = var.edge_cluster_profile_path
  
  # member block is not supported in nsxt_policy_edge_cluster
  # Nodes should be added via their own resource or manually if using MP nodes with Policy Cluster

}

# Tier-0 Gateway
resource "nsxt_policy_tier0_gateway" "t0_gateway" {
  display_name = var.t0_gateway_name
  description  = "Tier-0 Gateway"
  failover_mode = "PREEMPTIVE"
  default_rule_logging = false
  enable_firewall = true
  ha_mode = "ACTIVE_STANDBY"
  
  edge_cluster_path = nsxt_policy_edge_cluster.main.path
}

# Tier-1 Gateway
resource "nsxt_policy_tier1_gateway" "t1_gateway" {
  display_name = var.t1_gateway_name
  description  = "Tier-1 Gateway"
  edge_cluster_path = nsxt_policy_edge_cluster.main.path
  failover_mode     = "PREEMPTIVE"
  default_rule_logging = false
  enable_firewall   = true
  tier0_path        = nsxt_policy_tier0_gateway.t0_gateway.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
}
