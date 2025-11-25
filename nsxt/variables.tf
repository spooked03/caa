variable "nsx_host" {
  description = "The NSX-T Manager host"
  type        = string
}

variable "nsx_username" {
  description = "The NSX-T Manager username"
  type        = string
}

variable "nsx_password" {
  description = "The NSX-T Manager password"
  type        = string
  sensitive   = true
}

variable "allow_unverified_ssl" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = true
}

# Infrastructure Variables
variable "compute_manager_name" {
  description = "Name of the Compute Manager (vCenter)"
  type        = string
}

variable "edge_cluster_name" {
  description = "Name of the Edge Cluster to create"
  type        = string
  default     = "Edge-Cluster-01"
}

variable "edge_node_name" {
  description = "Name of the Edge Node"
  type        = string
  default     = "Edge-Node-01"
}

variable "edge_node_hostname" {
  description = "Hostname for the Edge Node"
  type        = string
  default     = "edge01.example.com"
}

variable "edge_node_ip" {
  description = "Management IP for the Edge Node"
  type        = string
}

variable "edge_node_gateway" {
  description = "Gateway for the Edge Node management network"
  type        = string
}

variable "edge_node_subnet_mask" {
  description = "Subnet mask for the Edge Node management network"
  type        = string
  default     = "255.255.255.0"
}

variable "edge_uplink_profile_name" {
  description = "Name of the Uplink Profile for Edge Node"
  type        = string
  default     = "nsx-edge-single-nic-uplink-profile"
}

variable "vc_id" {
  description = "UUID of the Compute Manager (vCenter)"
  type        = string
}

variable "compute_cluster_id" {
  description = "ID of the Compute Cluster to deploy Edge Node"
  type        = string
}

variable "datastore_id" {
  description = "ID of the Datastore to deploy Edge Node"
  type        = string
}

variable "management_network_id" {
  description = "ID of the Management Network (Portgroup) for Edge Node"
  type        = string
}

variable "edge_node_data_network_ids" {
  description = "List of Network IDs (Portgroups) for Edge Node Data/TEP traffic"
  type        = list(string)
}

variable "edge_cluster_profile_path" {
  description = "Path of the Edge Cluster Profile"
  type        = string
  default     = "/infra/edge-cluster-profiles/default-edge-high-availability-profile"
}

variable "transport_zone_overlay_name" {
  description = "Name of the Overlay Transport Zone"
  type        = string
  default     = "nsx-overlay-transportzone"
}

variable "transport_zone_vlan_name" {
  description = "Name of the VLAN Transport Zone"
  type        = string
  default     = "nsx-vlan-transportzone"
}

# Gateway Variables
variable "t0_gateway_name" {
  description = "Name of the Tier-0 Gateway"
  type        = string
  default     = "T0-Gateway"
}

variable "t1_gateway_name" {
  description = "Name of the Tier-1 Gateway"
  type        = string
  default     = "T1-Gateway"
}
