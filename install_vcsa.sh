#!/bin/bash


# Configuration
DEPLOY_CMD="/home/student/vcsa/vcsa-cli-installer/lin64/vcsa-deploy"
TEMPLATE_FILE="/home/student/vcsa/vcsa.json.template"
GENERATED_FILE="/home/student/vcsa/vcsa.json"

# Run VCSA deploy
# Generate JSON using jq to fill in the template
jq --arg esxi_pass "$(jq -r '.ESXI_PASSWORD' secrets.json)" \
   --arg os_pass "$(jq -r '.VCSA_OS_PASSWORD' secrets.json)" \
   --arg sso_pass "$(jq -r '.VCSA_SSO_PASSWORD' secrets.json)" \
   '.new_vcsa.esxi.password = $esxi_pass | 
    .new_vcsa.os.password = $os_pass | 
    .new_vcsa.sso.password = $sso_pass' \
   "$TEMPLATE_FILE" > "$GENERATED_FILE"

# Run VCSA deploy
"$DEPLOY_CMD" install --accept-eula "$GENERATED_FILE"

# Cleanup
rm "$GENERATED_FILE"
