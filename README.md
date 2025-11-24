# VMware VCSA and NSX Automation

## Getting Started

To begin working with this project, set up the development environment and prepare the container.

1. **Clone the repository**
2. **Start the development container**

   Use the provided Docker Compose file to spin up the environment:

   ```bash
   docker compose up -d
   ```

3. **Enter the running container with an interactive shell**

   ```bash
   docker compose exec caa-dev fish
   ```
   or run a singele command inside the container:

   ```bash
   docker compose exec caa-dev tofu --version
   ```


---

## Project Structure

* `deploy_nsx.sh`: Deploys NSX Manager using `ovftool`.
* `install_vcsa.sh`: Installs VCSA using the `vcsa-deploy` CLI.
* `secrets.json`: Encrypted JSON file with sensitive credentials, managed using SOPS.
* `vcsa.json.template`: Template used to generate the VCSA deployment configuration.

## Setup

You can work inside the devcontainer or install the required tools manually.

### 1. Secrets Management

This project uses `sops` to store and encrypt secrets. You must provide the correct age key to decrypt `secrets.json`.

Place your age key file at:

```
/config/key.txt
```

When using the devcontainer, the key is mounted automatically if placed in that location.

If configuring manually, define the key file path through an environment variable:

```bash
export SOPS_AGE_KEY_FILE=key.txt
```

To view or modify secrets:

```bash
sops secrets.json
```

### 2. Configuration

Before deploying, update the necessary files to match your environment.

* Update `secrets.json` with the correct passwords.
* Adjust environment specific variables in `deploy_nsx.sh` and confirm that the path to `ovftool` is correct.
* Modify `vcsa.json.template` and review `install_vcsa.sh` to ensure all values match your setup.

## Usage

Give execution permissions to the scripts before running them:

```bash
chmod +x scripts/*
```

or:

```bash
chmod +x scripts/specific_script.sh
```

### Deploying VCSA

```bash
../scripts/install_vcsa.sh
```

### Deploying NSX Manager

```bash
../scripts/deploy_nsx.sh
```
