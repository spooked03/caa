#!/bin/bash
set -e

RESOURCE_GROUP_NAME="S1193726"
STORAGE_ACCOUNT_NAME="tfstate${RANDOM}"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# Create Resource Group if it doesn't exist
if [ $(az group exists --name $RESOURCE_GROUP_NAME) = false ]; then
    echo "Creating Resource Group $RESOURCE_GROUP_NAME..."
    az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
else
    echo "Resource Group $RESOURCE_GROUP_NAME already exists."
fi

# Create Storage Account
echo "Creating Storage Account $STORAGE_ACCOUNT_NAME..."
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create Blob Container
echo "Creating Blob Container $CONTAINER_NAME..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

echo "Backend configuration variables:"
echo "resource_group_name = \"$RESOURCE_GROUP_NAME\""
echo "storage_account_name = \"$STORAGE_ACCOUNT_NAME\""
echo "container_name = \"$CONTAINER_NAME\""
echo "key = \"terraform.tfstate\""
