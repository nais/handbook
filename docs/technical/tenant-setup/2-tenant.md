# Step 2 - Tenant preparations

!!! note
    This step is done by the tenant administrators, and is typically done in collaboration with the Nais team.

When setting up Nais in your Google organization, we will need a dedicated folder for all resources related to Nais. Everything Nais related will be contained within this folder, and no further permissions are required in the organization.

## Required settings

The tenant administrator that will perform the following commands will need these permissions on the organization level: 

- `Owner`
- `Organization Administrator`
- `Folder Creator`
- `Organization Policy Administrator`

### Edit `Domain restricted sharing` policy

If `Domain restricted sharing` is enabled, allow users from nais.io (nais-io) by adding the domain to `iam.allowedPolicyMemberDomains` under `IAM/Organization Policies`

1. Select the top-level organization in the Google Cloud Console
1. Go to `IAM & Admin` -> `Organization policies`
1. Find the policy `Domain restricted sharing` (iam.allowedPolicyMemberDomains)
1. Actions (three dots) -> Edit policy
1. Click `Manage policy`
1. Here, you will likely see a existing rule with a custom allow policy for your domain (`is:C0XXXXXX`). Add the value `is:C00xgb366` to this rule. This is the nais.io domain.
1. Click `Done` and `Set policy`
1. Allow a couple of minutes for the policy to take effect

### Run setup script

Download and run the setup script found here: https://raw.githubusercontent.com/nais/handbook/refs/heads/main/scripts/tenant-setup.sh

This can be done using the Google Cloud Shell, or locally if you have `gcloud` installed.

## Teams and users (admin google com)

### Create Kubernetes security group

This group is used to manage access to the kubernetes clusters, and this is where Nais automatically adds teams that should have access to the clusters.

1. Go to [https://admin.google.com/ac/groups](https://admin.google.com/ac/groups)
1. Click on `Create group`
1. Enter `gke-security-groups` as the group name
1. Enter `gke-security-groups` as the email address
1. Enter `This group manages who has GKE permissions` as the description
1. Note: Do *not* check the box for `Security`
1. Click `Next`
1. Select 'Only invited users' in the 'Who can join the group' section. Leave the rest as default.
1. Click `Create Group`

### Create nais admin user

Nais needs a dedicated user account in the Google directory. This user must be manually created [in the Google Admin console](https://admin.google.com/ac/users). The user must be granted the `Groups Admin` role to be able to create and maintain groups for the teams:

1. Go to [https://admin.google.com/ac/users](https://admin.google.com/ac/users)
1. Click on `Add new user`
1. Enter `nais` as first name, and `admin` as last name
1. Enter `nais-admin` as the primary email
1. Click `Add new user` to add the user account (you can safely ignore the generated password)
1. Click on the created user (might require a hard refresh of the user list) and then on `Assign roles` under the `Admin roles and privileges` section
1. Assign the `Groups Admin` role and click `Save`

### Create Console admins group

Nais (API) automatically syncs users from the Google Workspace to its own database. Tenants can control which users that should be assigned the admin role in Nais by creating a group called `console-admins@<tenant-domain>`, and then add the necessary users to this group. When Console/Nais API runs the user sync it will look for this group, and make sure that the users in the group are granted the admin role.
Whenever a user is removed from the group, Nais will revoke the admin role from the user on the next sync.

1. Go to [https://admin.google.com/ac/groups](https://admin.google.com/ac/groups)
1. Click on `Create group`
1. Enter `console-admins` as the group name
1. Enter `console-admins` as the email address
1. Enter `This group is used to control who has admin permissions in the Nais Console` as the description
1. Click `Next`
1. Select 'Only invited users' in the 'Who can join the group' section. Leave the rest as default.
1. Click `Create Group`

Users with the admin role in Console have access to some additional settings:

- Configure / enable / disable reconcilers
- Grant / revoke roles
- Manipulate reconciler states for teams

## Highly recommended settings

### Log location

Every project created in GCP will have a default log location for all logs. The default is Global.
In order to keep your logs in europe, we _strongly_ recommend setting the default log location to europe using the following command

```bash
gcloud alpha logging settings update --organization=$ORG_ID --storage-location=europe-north1
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
gcloud beta resource-manager org-policies set-policy --organization=$ORG_ID <file name>.yaml
```
