# VMware VCSA & NSX Automation

This repository contains automation scripts for deploying VMware vCenter Server Appliance (VCSA) and NSX Manager. It utilizes `sops` for secret management to ensure sensitive credentials are not hardcoded in the scripts.

## Project Structure

- `deploy_nsx.sh`: Script to deploy NSX Manager using `ovftool`.
- `install_vcsa.sh`: Script to install VCSA using the `vcsa-deploy` CLI.
- `secrets.json`: Encrypted JSON file containing sensitive passwords (managed by SOPS).
- `vcsa.json.template`: Template configuration for VCSA deployment.

## Prerequisites

Ensure the following tools are installed and available in your environment:

- **Bash**: Shell environment.
- **jq**: Command-line JSON processor.
- **SOPS**: Secrets OPerationS for managing encrypted secrets.
- **VMware OVF Tool**: Required for NSX deployment.
- **VCSA CLI Installer**: Required for VCSA deployment.

## Setup

1. **Secrets Management**:
   This project uses `sops` to manage secrets. Ensure you have the correct keys configured to decrypt `secrets.json`.
   
   To view/edit secrets:
   ```bash
   sops secrets.json
   ```

   The `secrets.json` should contain the following keys:
   - `NSX_MGR_PASSWORD`
   - `VC_PASSWORD`
   - `ESXI_PASSWORD`
   - `VCSA_OS_PASSWORD`
   - `VCSA_SSO_PASSWORD`

2. **Configuration**:
   - Review `deploy_nsx.sh` and update variables such as IPs, hostnames, and file paths (currently hardcoded to `/home/student/vcsa/...`).
   - Review `vcsa.json.template` to ensure network and host configurations match your environment.

## Usage

### Deploying VCSA

Run the installation script:

```bash
./install_vcsa.sh
```

This script will:
1. Decrypt secrets from `secrets.json`.
2. Generate a valid `vcsa.json` config from the template.
3. Execute the `vcsa-deploy` command.
4. Clean up the generated config file.

### Deploying NSX Manager

Run the deployment script:

```bash
./deploy_nsx.sh
```

This script will:
1. Decrypt secrets.
2. Generate an `ovftool.cfg` file.
3. Deploy the NSX Manager OVA to the specified vCenter/ESXi host.
4. Clean up the config file.

## Recommendations

- **Directory Structure**: Consider moving scripts to a `scripts/` directory and configuration templates to a `config/` directory to keep the root clean.
- **Paths**: Avoid hardcoding absolute paths (like `/home/student/...`) in scripts. Use relative paths or environment variables.
