resource "nsxt_policy_dhcp_server" "tier_dhcp" {
  display_name     = "tier_dhcp"
  description      = "DHCP server servicing all 3 Segments"
  server_addresses = ["12.12.99.2/24"]
}