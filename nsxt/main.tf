terraform {
    required_providers {
        nsxt = {
            source = "vmware/nsxt"
        }
    }
}

provider "nsxt" {
    host                 = var.nsx_host
    username             = var.nsx_username
    password             = var.nsx_password
    allow_unverified_ssl = var.allow_unverified_ssl
}

resource "nsxt_policy_group" "Allvms" {
  display_name = "PROD-VMS"
  domain       = "default"

  criteria {
    condition {
      key         = "Tag"
      member_type = "VirtualMachine"
      operator    = "EQUALS"
      value       = "vms"
    }
  }
}

resource "nsxt_policy_security_policy" "policy1" {
    display_name = "My policy's"
    description  = "Terraform provisioned Security Policy"
    category     = "Application"
    locked       = false
    stateful     = true
    tcp_strict   = false

    rule {
        display_name       = "block_ssh"
        destination_groups = [nsxt_policy_group.Allvms.path]
        source_groups = [nsxt_policy_group.Allvms.path]
        action             = "REJECT"
        services           = [
            "/infra/services/SSH"
        ]
        logged             = true
    }

    lifecycle {
        create_before_destroy = true
    }
}

# resource "nsxt_policy_gateway_policy" "gw_web_policy" {
#     display_name = "GW-Web-Servers-Policy"
#     description  = "Gateway firewall policy for the web workloads"
#     category     = "LocalGatewayRules"
#     locked       = false
#     stateful     = false
#     tcp_strict   = false

#     rule {
#         display_name = "ALLOW-Web-To-Internet"
#         action       = "ALLOW"
#         direction    = "OUT"

#         source_groups = [
#             nsxt_policy_group.web_servers.path
#         ]

#         scope = [
#             data.nsxt_policy_tier1_gateway.tier1.path
#         ]
#     }

#     rule {
#         display_name = "ALLOW-Internet-To-Web-HTTPS"
#         action       = "ALLOW"
#         direction    = "IN"

#         destination_groups = [
#             nsxt_policy_group.web_servers.path
#         ]

#         services = [
#             "/infra/services/HTTPS"
#         ]

#         scope = [
#             data.nsxt_policy_tier1_gateway.tier1.path
#         ]
#     }

#     # Default deny (catch-all)
#     rule {
#         display_name = "DENY-ALL"
#         action       = "DROP"
#         direction    = "IN_OUT"

#         scope = [
#             data.nsxt_policy_tier1_gateway.tier1.path
#         ]
#     }

# }
