# Setting up a tenant organization

## Required settings

### Required permissions
On the user that will run the following commands, the following IAM roles are required on the organization level.

- `Owner`
- `Organization Administrator`
- `Folder Creator`
- `Organization Policy Administrator`

### Create the nais folder
Everything related to nais is contained within this folder.

```bash
gcloud resource-manager folders create --display-name=nais --organization=<your org ID>
```

#### Grant access to the nais team and the terraform user
To allow the nais team the required permissions to operate nais, add the iam-policy below to the nais folder.

Replace `${TENANTNAME}` with the name provided by the NAIS team.

<details>
<summary>Click to see file content</summary>
```json
{
  "bindings": [
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/artifactregistry.admin"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/compute.admin"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/container.admin"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/dns.admin"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/logging.admin"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/resourcemanager.folderCreator"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/resourcemanager.folderIamAdmin"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/resourcemanager.projectCreator"
    },
    {
      "members": [
        "serviceAccount:nais-tf-${TENANTNAME}@nais-io.iam.gserviceaccount.com"
      ],
      "role": "roles/serviceusage.serviceUsageAdmin"
    }
  ]
}
// Todo: find correct roles for viewers and admins
- nais-viewers
- nais-admins
```
</details>
Run the following command to allow the roles in the nais folder:

``` bash
gcloud resource-manager folders set-iam-policy <nais folder ID> <file name>.json
```


### Console-user
The console user needs some permissions - we don't know which yet.

### Kubernetes group
In [Google Admin](https://admin.google.com) create a group named `gke-security-group`. 
This group is used to manage access to the kubernetes clusters, and will be managed by console.

### Custom organization role
[Config connector](https://cloud.google.com/config-connector/docs/overview) requires a service user in each of the team projects that will be created.
We want to restrict this user's access to a bare minimum using a custom role.
We cannot define custom roles at the folder level. Since we need to use a custom role for every project within the nais folder, we define the custom role at the organization level.

Save the content below to a .yaml file
<details>
<summary>Click to see file content</summary>
``` yaml
title: "NAIS Custom CNRM Role"
description: "Custom role for namespaced cnrm users to allow creation of resources"
stage: "GA"
includedPermissions:
- cloudkms.cryptoKeys.create
- cloudkms.cryptoKeys.get
- cloudkms.cryptoKeys.update
- cloudkms.keyRings.create
- cloudkms.keyRings.get
- cloudkms.keyRings.getIamPolicy
- cloudkms.keyRings.setIamPolicy
- cloudsql.databases.create
- cloudsql.databases.delete
- cloudsql.databases.get
- cloudsql.databases.list
- cloudsql.databases.update
- cloudsql.instances.create
- cloudsql.instances.delete
- cloudsql.instances.get
- cloudsql.instances.list
- cloudsql.instances.update
- cloudsql.users.create
- cloudsql.users.delete
- cloudsql.users.list
- cloudsql.users.update
- resourcemanager.projects.get
- resourcemanager.projects.getIamPolicy
- resourcemanager.projects.setIamPolicy
- storage.buckets.create
- storage.buckets.get
- storage.buckets.getIamPolicy
- storage.buckets.list
- storage.buckets.setIamPolicy
- storage.buckets.update
```
</details>

Run the following command to apply it to your organization:

``` bash
gcloud iam roles create CustomCNRMRole --organization=<your org ID>  --file=<your file name>.yaml
```

## Highly recommended settings
### Log location
Every project created in GCP will have a default log location for all logs. The default is Global.
In order to keep your logs in europe, we _strongly_ recommend setting the default log location to europe using the following command


```bash 
gcloud alpha logging settings update --organization=<your org ID> --storage-location=europe-north1
```
### Organization policy for location
Although all resources created by nais is located within the EU, teams are still able to create resources anywhere unless an organizational constraint is in place.

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

``` bash
gcloud beta resource-manager org-policies set-policy --organization=<your org ID> <file name>.yaml
```

