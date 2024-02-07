# Azure AD

[:fontawesome-brands-github: nais/azurerator](https://github.com/nais/azurerator) creates and manages Azure AD applications via Kubernetes Custom Resources for [use in various authentication scenarios](https://doc.nais.io/security/auth/azure-ad/).

This is an optional addon in NaaS. It is not enabled by default.

## For Tenant

### Requirements

To be able to use this addon, you will need to bring your own [Azure AD tenant](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis).

Unfortunately, we do not offer provisioning nor management of Azure AD itself as a service.
The Azure AD tenant must be wholly owned and operated by your organization.

You will also need to set up a couple of things within said tenant. We'll guide you through the steps.

### Google Service Accounts

Azurerator uses [federated credentials](https://learn.microsoft.com/en-us/graph/api/resources/federatedidentitycredentials-overview?view=graph-rest-1.0)
in order to authenticate itself to your Azure AD tenant, by using tokens issued by Google. 
This removes the need to share client secrets between our organizations.
The tokens are in turn only issued to Google Service Accounts that exist within the NAIS projects that we've created for your Google organization.

To set this up, you will need to find some identifiers from within your Google organization:

1. Find the NAIS Google Project IDs:
    1. Use the `gcloud` CLI: `gcloud projects list --filter="nais-"`
    2. There should be one project ID for each environment; `nais-dev-xxxx` and `nais-prod-xxxx`. Note these down.
2. For each project ID, find the unique Service Account ID for Azurerator:
    1. `gcloud iam service-accounts describe azurerator@<PROJECT_ID>.iam.gserviceaccount.com`, where `PROJECT_ID` is the ID found in the previous step.
    2. Note down the `uniqueId` for the service account. This ID uniquely identifies the Google Service Account that Azurerator uses in each environment.

### Azure AD Application Registration

An [Azure AD application registration](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals)
within the tenant mentioned above is needed for Azurerator to create and manage application registrations within Azure AD.

1. Sign in to your Azure Account through the [Azure portal](https://portal.azure.com/).
2. Select **Azure Active Directory**.
3. Select **App registrations**.
4. Select **New registration**.
    1. Name the application, for example "azurerator".
    2. Supported account type doesn't matter, single tenant is fine. 
    3. Leave **Redirect URI** empty.
5. Under **Overview**, note down the values for the following fields:
    1. **Application (client) ID**.
    2. **Directory (tenant) ID**
6. Navigate to **Certificates and secrets**.
    1. Select **Federated credentials**.
    2. Select **Add credentials**.
    3. Under **Federated credential scenario**, select **Other issuer**.
    4. Under **Issuer**, enter the value `https://accounts.google.com`
    5. Under **Subject**, enter the value for `uniqueId` that you noted down from the [previous section on Google Service Accounts](#google-service-accounts).
    6. Under **Name**, enter the value `nais-<environment>`, for example `nais-dev` or `nais-prod`
    7. Leave the **Audience** at the default value, i.e. `api://AzureADTokenExchange`
    8. Repeat the steps starting from step **6** with the second `uniqueId` from the [previous section on Google Service Accounts](#google-service-accounts).
7. Navigate to **API permissions**.
    1. Select **Add a permission**.
    2. Select **Microsoft Graph**.
    3. Select **Application permissions**.
    4. The application needs the following permissions:
        - `Application.ReadWrite.All`
        - `DelegatedPermissionGrant.ReadWrite.All`
        - `GroupMember.Read.All`
    5. Add the permissions.
    6. Select **Grant admin consent for &lt;tenant name&gt;**.
    7. Confirm to grant the application access to the configured permissions.

    If done correctly, the list of permissions should look like this:

    ![The list of configured permissions for the Application registration in Azure AD. The permissions Application.ReadWrite.All, DelegatedPermissionGrant.ReadWrite.All and Group.Read.All for the Microsoft Graph API are all added as Application permissions. Admin consent has been granted to all of the permissions.](../../assets/azure-ad-permissions-setup.png)

### Microsoft Graph Object ID

In order for Azurerator to pre-approve delegated API permissions for the managed applications,
you will need to find the **Object ID** for the Microsoft Graph Enterprise Application that is unique to each Azure AD tenant.

1. Sign in to your Azure Account through the [Azure portal](https://portal.azure.com/).
2. Select **Azure Active Directory**.
3. Select **Enterprise applications**.
4. Filter the list of applications:
    1. **Applicaton ID starts with** == "00000003-0000-0000-c000-000000000000"
    2. **Application type** == "Microsoft Applications"
5. You should see an application named `GraphAggregatorService` or `Microsoft Graph`.
6. Note down the **Object ID** for this application.

### Application Access Groups

Azurerator creates Azure AD application registrations that are restricted by default:

- Users are not allowed access to the application unless they are explicitly given access.
- Access is granted by group membership; groups are assigned directly to applications.
- Users must be direct members of the groups, i.e. nested groups will not work.

You will need to define a group that contains all users in your tenant. 
The definition of "all users" is left for you to decide. This can for example be:

- all users, including guest accounts and machine users
- all users that are not guests in your tenant
- all users that have a valid license
- all users within a certain department, and so on

Refer to the following guides at Microsoft for details on groups:

- [creating and managing groups](https://learn.microsoft.com/en-gb/azure/active-directory/fundamentals/how-to-manage-groups) 
- [dynamic group memberships](https://learn.microsoft.com/en-gb/azure/active-directory/enterprise-users/groups-dynamic-membership)

The all users group will be assigned to any application that has enabled the `allowAllUsers` directive. 
Note down the **object ID** for this group.

---

Once you've got through all of the above, provide the NAIS team with the following information:

| Property                          | Description                                                                 |
|:----------------------------------|:----------------------------------------------------------------------------|
| Tenant ID                         | See [Azure AD Application Registration](#azure-ad-application-registration) |
| Client ID                         | See [Azure AD Application Registration](#azure-ad-application-registration) |
| Microsoft Graph Object ID         | See [Microsoft Graph Object ID](#microsoft-graph-object-id)                 |
| Default All-Users Group Object ID | See [Application Access Groups](#application-access-groups)                 |

## For NAIS

1. Enter the required configuration for `azurerator` in Fasit, using the information given by the tenant
2. Enable the `azurerator` feature in Fasit
3. Enable the `azurerator` feature within `naiserator` in Fasit
