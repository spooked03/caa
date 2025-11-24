#!/bin/bash

# Determine script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Configuration
# Assuming the VCSA installer is located at this absolute path
DEPLOY_CMD="/home/student/vcsa/vcsa-cli-installer/lin64/vcsa-deploy"
TEMPLATE_FILE="$PROJECT_ROOT/config/vcsa.json.template"
GENERATED_FILE="$PROJECT_ROOT/config/vcsa.json"
SECRETS_FILE="$PROJECT_ROOT/config/secrets.json"

# Check if secrets file exists
if [ ! -f "$SECRETS_FILE" ]; then
    echo "Error: Secrets file not found at $SECRETS_FILE"
    exit 1
fi

# Run VCSA deploy
# Generate JSON using jq to fill in the template
SECRETS=$(sops -d "$SECRETS_FILE")
jq --arg esxi_pass "$(echo "$SECRETS" | jq -r '.ESXI_PASSWORD')" \
   --arg os_pass "$(echo "$SECRETS" | jq -r '.VCSA_OS_PASSWORD')" \
   --arg sso_pass "$(echo "$SECRETS" | jq -r '.VCSA_SSO_PASSWORD')" \
   '.new_vcsa.esxi.password = $esxi_pass | 
    .new_vcsa.os.password = $os_pass | 
    .new_vcsa.sso.password = $sso_pass' \
   "$TEMPLATE_FILE" > "$GENERATED_FILE"

# Run VCSA deploy
"$DEPLOY_CMD" install --accept-eula "$GENERATED_FILE"

# Cleanup
rm "$GENERATED_FILE"
