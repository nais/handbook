# Setting up a tenant organization

TODO:

- nais-terraform-modules, legg til ny tenant i lista i serviceaccounts.tf. -> PR -> apply
- add denne brukeren til billing i NAV (frode, sten og johnny kan gjøre dette). Billing -> Account Management -> se på høyresida -> Add user.
- for nytt domene: bestilles av Trond. Når det er klart, kan man klikke seg igjennom og opprette ny org. Da må det verifiseres noe greier som må inn i DNS.

This guide is used when setting up a new tenant. This is typically done by the NAIS team, together with the tenants administrators.

```mermaid
graph TD
A[Google Tenant] --> B[NAIS Folder]
B --> C[management]
B --> D[dev]
B --> E[prod]
```

## Prereq

- [Google Cloud Tenant admin](https://cloud.google.com/identity/docs/set-up-cloud-identity-admin)
- GitHub Organization
- Allow users from nais.io (nais-io) in the `Allowed Domain Policy` under `IAM/Organization Policies`

## Required settings

### Required permissions

On the user that will run the following commands, the following IAM roles are
required on an organization level.

- `Owner`
- `Organization Administrator`
- `Folder Creator`
- `Organization Policy Administrator`

### Create the NAIS folder

Everything related to NAIS is contained within this folder.

```bash
export NAAS_ORG_NAME=my-org # (1)
export NAAS_ORG_ID=$(gcloud organizations list --filter $NAAS_ORG_NAME --format "value(name)")

gcloud organizations add-iam-policy-binding "$NAAS_ORG_ID" --member="domain:nais.io" --role="roles/compute.osLoginExternalUser"
gcloud resource-manager folders create --display-name=nais --organization=$NAAS_ORG_ID
export NAAS_GOOGLE_FOLDERID=$(gcloud resource-manager folders list --organization="$NAAS_ORG_ID" --filter "displayName=nais AND parent=organizations/${NAAS_ORG_ID}" --format "value(name)")
```

1. :man_raising_hand: Change this to the name of your Google Organization

#### Grant access to the NAIS team and the terraform user

To allow the NAIS team the required permissions to operate nais, IAM policies
must be added to the NAIS folder.

!!! bug

    Find correct roles for the following users:

    - nais-viewers
    - nais-admins

??? "Copy and run this command"

    ```bash
    cat <<EOF > naas-google-org-policy.json
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
    read -p "Enter NaaS Tenant Name [$NAAS_TENANTNAME]: " TENANTNAME && \
    export NAAS_TENANTNAME="${TENANTNAME:-$NAAS_TENANTNAME}" && \
    sed -ie "s/__TENANTNAME__/$NAAS_TENANTNAME/g" naas-google-org-policy.json && \
    echo "gcloud resource-manager folders set-iam-policy $NAAS_GOOGLE_FOLDERID naas-google-org-policy.json"
    ```

## Run nais-terraform-modules

Before doing the following step, run the terraform setup.
but even before this again, update nais/core/ipplan

## Teams and users

### Create nais admin user (in tenant admin.google.com)

Nais needs a dedicated user account in the Google directory. This user must be manually created [in the Google Admin console](https://admin.google.com/ac/users). The user must be granted the `Groups Admin` role to be able to create and maintain groups for the teams:

1. Go to [https://admin.google.com/ac/users](https://admin.google.com/ac/users)
2. Click on `Add new user`
3. Enter `nais` as first name, and `admin` as last name
4. Enter `nais-admin` as the primary email
5. Click `Add new user` to add the user account
6. Click on the created user and then on `Assign roles` under the `Admin roles and privileges` section
7. Assign the `Groups Admin` role and click `Save`

### Set up domain-wide delegation (in tenant admin.google.com)

Nais performs some operations on behalf of the Nais admin user mentioned above. For this to work the, this user needs domain-wide delegation with some scopes. This must be manually set up in the Google Admin console:

1. Go to [https://admin.google.com/ac/owl/domainwidedelegation](https://admin.google.com/ac/owl/domainwidedelegation)
2. Click on `Add new` to add a new Client ID
3. Enter the ID of the Nais admin service account (provided by the NAIS team)
4. Add the following scopes:
   - `https://www.googleapis.com/auth/admin.directory.group`
   - `https://www.googleapis.com/auth/admin.directory.user.readonly`
5. Click on `Authorize`

After this is done you should see something like the following:

![Screenshot of the Domain-wide Delegation screen in the Google Admin console](../../assets/domainwidedelegation-screenshot.png)

### Create nais admins group (in tenant admin.google.com)

Nais (API) automatically syncs users from the Google Workspace to its own database. Tenants can control which users that should be assigned the admin role in Nais by creating a group called `nais-admins@<tenant-domain>`, and then add the necessary users to this group. When _teams_ runs the user sync it will look for this group, and make sure that the users in the group are granted the admin role.
Whenever a user is removed from the group, Nais will revoke the admin role from the user on the next sync.

Users with the admin role in Console have access to some additional settings:

- Configure / enable / disable reconcilers
- Grant / revoke roles
- Manipulate reconciler states for teams

### Create Kubernetes security group (in tenant admin.google.com)

This group is used to manage access to the kubernetes clusters, and this is where Nais automatically adds teams that should have access to the clusters.

In [Google Admin](https://admin.google.com) create a group named `gke-security-groups`.
Make sure the group has the **View Members** permission selected for **Group Members**.

### Create nais' k8s nais admin groups (do not confuse with the tenants nais-admins group above, done in nais.io admin.google.com)

Create group $NAAS_TENANT_NAME-k8s-admins with the email: $NAAS_TENANT_NAME-k8s-admins@nais.io

## Configure OAuth login for web frontend

Set up an OAuth client for _Console_.

1. Go to https://console.cloud.google.com
1. Choose project <tenant org> -> nais-management -> nais-management
1. Go to _APIs ans Service_ -> _OAuth consent screen_
1. _Internal_ -> _create_
   1. App name: `nais management`
   1. User support email: `admin@<tenant-domain>`
   1. Developer Contact email: `admin@<tenant-domain>`
1. _Save and continue_ (x2)
1. Go to _APIs ans Service_ -> _Credentials_
1. Click _Create Credentials_ -> _OAuth client ID_
1. Select type _Web Application_
   1. Name: `Console`
   1. Authorized redirect URI: `http://console.<tenant-name>.cloud.nais.io/oauth2/callback`
1. Set Name and Authorized redirect URIs
1. _Create_
1. Copy client id and secret and give to NAIS-team

## Highly recommended settings

### Log location

Every project created in GCP will have a default log location for all logs. The default is Global.
In order to keep your logs in europe, we _strongly_ recommend setting the default log location to europe using the following command

```bash
gcloud alpha logging settings update --organization=$NAAS_ORG_ID --storage-location=europe-north1
```

### Organization policy for location

Although all resources created by NAIS is located within the EU, teams are still able to create resources anywhere unless an organizational constraint is in place.

<details>
<summary>Click to see file content</summary>
``` yaml
constraint: constraints/gcp.resourceLocations
etag: BwVUSr8Q7Ng=
listPolicy:
  allowedValues:
  - in:eu-locations
```
</details>

```bash
gcloud beta resource-manager org-policies set-policy --organization=$NAAS_ORG_ID <file name>.yaml
```

### Github Actions secrets

If you are using Github Actions to deploy your applications, you may want to add the following variable and secret to your organization's Github Actions secrets:

Open `https://github.com/organizations/[ORG_NAME]/settings/secrets/actions`

| Name                              | Type       |
| --------------------------------- | ---------- |
| `NAIS_MANAGEMENT_PROJECT_ID`      | `Variable` |
| `NAIS_WORKLOAD_IDENTITY_PROVIDER` | `Secret`   |

These may also be set in the repository's secrets, but it is recommended to set them in the organization's secrets as they are shared between all teams.

The NAIS team will provide the values.

---
