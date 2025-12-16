provider "nsxt" {
  host                 = var.nsx_host
  username             = var.nsx_username
  password             = var.nsx_password
  allow_unverified_ssl = var.allow_unverified_ssl
}

terraform {
  backend "azurerm" {
    resource_group_name  = "S1193726"
    storage_account_name = "tfstate28161"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Data Source for Edge Cluster
data "nsxt_policy_edge_cluster" "edge_cluster" {
  display_name = "edgecluster"
}

# Tier-0 Gateway
resource "nsxt_policy_tier0_gateway" "tier0_gw" {
  display_name         = "Tier-0-Gateway"
  description          = "Tier-0 Gateway deployed via Terraform"
  failover_mode        = "PREEMPTIVE"
  default_rule_logging = false
  enable_firewall      = true
  ha_mode              = "ACTIVE_ACTIVE"
  edge_cluster_path    = data.nsxt_policy_edge_cluster.edge_cluster.path

  # Assumes an Edge Cluster exists. Replace with UUID or data source if needed.
  # edge_cluster_path = "/infra/sites/default/enforcement-points/default/edge-clusters/<edge-cluster-uuid>"
  
  bgp_config {
    local_as_num = "65000"
  }
}

# Tier-1 Gateway
resource "nsxt_policy_tier1_gateway" "tier1_gw" {
  display_name              = "Tier-1-Gateway"
  description               = "Tier-1 Gateway deployed via Terraform"
  tier0_path                = nsxt_policy_tier0_gateway.tier0_gw.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"
}

