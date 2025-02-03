#! /usr/bin/env bash

set -e

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <ORG_ID> <NAIS_TENANT_ALIAS>"
	echo ""
	echo "ORG_ID: Your GCP organization ID"
	echo "NAIS_TENANT_ALIAS: The alias for the tenant. Will be provided by the Nais team"
	exit 1
fi

ORG_ID=$1
NAIS_TENANT_ALIAS=$2

cat <<EOF > nais-user-permissions.json
    {
      "bindings": [
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/artifactregistry.admin"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/compute.admin"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/container.admin"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/dns.admin"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/logging.admin"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/resourcemanager.folderCreator"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/resourcemanager.folderIamAdmin"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/resourcemanager.projectCreator"
        },
        {
          "members": [
            "serviceAccount:nais-tf-__TENANTNAME__@nais-io.iam.gserviceaccount.com"
          ],
          "role": "roles/serviceusage.serviceUsageAdmin"
        }
      ]
    }
EOF

echo "Creating the Nais users permissions file"
sed -i "s/__TENANTNAME__/$NAIS_TENANT_ALIAS/g" nais-user-permissions.json && echo "✔️ Permissions file created"

echo "Allowing nais.io domain to be used to log into VMs. Note: does not grant permissions to VMs, just the possibility for the users to come from this domain."
gcloud organizations add-iam-policy-binding "$ORG_ID" --member="domain:nais.io" --role="roles/compute.osLoginExternalUser" && echo "✔️ nais.io domain allowed to log into VMs"

echo "Creating the Nais folder"
gcloud resource-manager folders create --display-name=nais --organization="$ORG_ID" && echo "✔️ Nais folder created"

echo "Getting the folder id for the Nais folder"
NAIS_FOLDER_ID=$(gcloud resource-manager folders list --organization="$ORG_ID" --filter "displayName=nais AND parent=organizations/${ORG_ID}" --format "value(name)") && echo "Folder id for nais folder: $NAIS_FOLDER_ID" && echo "✔️ Folder id retrieved"

echo "Setting the IAM policy for the Nais folder"
gcloud resource-manager folders set-iam-policy "$NAIS_FOLDER_ID" nais-user-permissions.json && echo "✔️ IAM policy set for the Nais folder"
