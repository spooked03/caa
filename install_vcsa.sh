#!/bin/bash


# Configuration
DEPLOY_CMD="/home/student/vcsa/vcsa-cli-installer/lin64/vcsa-deploy"
TEMPLATE_FILE="/home/student/vcsa/vcsa.json.template"
GENERATED_FILE="/home/student/vcsa/vcsa.json"

# Run VCSA deploy
# Generate JSON using jq to fill in the template
SECRETS=$(sops -d secrets.json)
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
