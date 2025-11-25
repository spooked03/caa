#!/bin/bash

# Determine script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Configuration Variables
SECRETS_FILE="$PROJECT_ROOT/config/secrets.json"

# Check if secrets file exists
if [ ! -f "$SECRETS_FILE" ]; then
    echo "Error: Secrets file not found at $SECRETS_FILE"
    exit 1
fi

# Read secrets using jq
SECRETS=$(sops -d "$SECRETS_FILE")
mgrpasswd=$(echo "$SECRETS" | jq -r '.NSX_MGR_PASSWORD')
vcpass=$(echo "$SECRETS" | jq -r '.VC_PASSWORD')

mgrformfactor="small"
ipAllocationPolicy="fixedPolicy"
mgrdatastore="datastore1"
mgrnetwork="VM Network"
mgrdomain="ad.home.arpa"

mgrname01="nsx-m1"
mgrhostname01="nsx-m1.ad.home.arpa"
mgrip01="192.168.1.22"

mgrnetmask="255.255.255.0"
mgrgw="192.168.1.1"
mgrdns="192.168.1.10"
mgrntp="time.cloudflare.com"

# Secrets and Boolean Flags

mgrssh="True"
mgrroot="True"
logLevel="trivia"

# vCenter Configuration
vcadmin="administrator@vsphere.local"

vcip="192.168.1.21"
mgresxhost01="192.168.1.20"

# Path to OVA and OVF Tool
ovapath="$PROJECT_ROOT/vc/nsx.ova"
# Updated to absolute path based on install_vcsa.sh location assumption
ovftool_bin="/usr/local/bin/ovftool"

mgrvmfolder="" # Optional: Specify folder in vCenter"

# Deploy Command
# Note: 'Network 1' is the default network name in the NSX OVA.

"$ovftool_bin" \
    --name="$mgrname01" \
    --X:injectOvfEnv \
    --X:logFile="ovftool.log" \
    --sourceType=OVA \
    --vmFolder="$mgrvmfolder" \
    --allowExtraConfig \
    --datastore="$mgrdatastore" \
    --net:"Network 1"="$mgrnetwork" \
    --acceptAllEulas \
    --skipManifestCheck \
    --noSSLVerify \
    --diskMode=thin \
    --quiet \
    --hideEula \
    --powerOn \
    --deploymentOption="$mgrformfactor" \
    --ipProtocol=IPv4 \
    --ipAllocationPolicy="$ipAllocationPolicy" \
    --prop:nsx_ip_0="$mgrip01" \
    --prop:nsx_netmask_0="$mgrnetmask" \
    --prop:nsx_gateway_0="$mgrgw" \
    --prop:nsx_dns1_0="$mgrdns" \
    --prop:nsx_domain_0="$mgrdomain" \
    --prop:nsx_ntp_0="$mgrntp" \
    --prop:nsx_isSSHEnabled="$mgrssh" \
    --prop:nsx_passwd_0="$mgrpasswd" \
    --prop:nsx_cli_passwd_0="$mgrpasswd" \
    --prop:nsx_cli_audit_passwd_0="$mgrpasswd" \
    --prop:nsx_hostname="$mgrhostname01" \
    --prop:nsx_allowSSHRootLogin="$mgrroot" \
    --prop:nsx_role="NSX Manager" \
    --X:logLevel="$logLevel" \
    "$ovapath" \
    "vi://$vcadmin:$vcpass@$vcip/?ip=$mgresxhost01"
