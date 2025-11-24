# VMware VCSA & NSX Automation

## Project Structure

- `deploy_nsx.sh`: Script to deploy NSX Manager using `ovftool`.
- `install_vcsa.sh`: Script to install VCSA using the `vcsa-deploy` CLI.
- `secrets.json`: Encrypted JSON file containing sensitive passwords (managed by SOPS).
- `vcsa.json.template`: Template configuration for VCSA deployment.

## Setup
Use the available devcontainer to set up your environment or setup all the tools manually.

1. **Secrets Management**:
   This project uses `sops` to manage secrets. Ensure you have the correct keys to decrypt `secrets.json`. If using devcontainer, the key will be mounted automatically if placed like /config/key.txt. Else manually set environment variable `SOPS_AGE_KEY_FILE` to the path of your age key.
   for example:
   ```bash
   export SOPS_AGE_KEY_FILE=key.txt
   ```
   
   To view/edit secrets:
   ```bash
   sops secrets.json
   ```

2. **Configuration**:
   - `secrets.json` set the correct passwords to be used in the scripts.
   - `deploy_nsx.sh` update variables to match your environment. Make sure the OVFtool path is correct.
   - `install_vcsa.sh` before running update variables to match your environment in the `vcsa.json.template` file. Make sure the OVFtool path is correct.
   
 

## Usage
to deploy simply run the scripts for the components you want to deploy.

### Deploying VCSA

```bash
../scripts/install_vcsa.sh
```


### Deploying NSX Manager

```bash
../scripts/deploy_nsx.sh
```

