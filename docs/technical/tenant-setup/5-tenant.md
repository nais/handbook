# Step 5 - Tenant post terraforming

### Set up domain-wide delegation (in tenant admin.google.com)

Nais performs some operations on behalf of the Nais admin user mentioned above. For this to work the, this user needs domain-wide delegation with some scopes. This must be manually set up in the Google Admin console:

1. Go to [https://admin.google.com/ac/owl/domainwidedelegation](https://admin.google.com/ac/owl/domainwidedelegation)
1. Click on `Add new` to add a new Client ID
1. Enter the ID of the tenant directory service account
    ```bash title="Using gcloud"
    MANAGEMENT_PROJECT_ID=<tenant management project>
    gcloud iam service-accounts --project=$MANAGEMENT_PROJECT_ID describe tenant-directory-sa@$MANAGEMENT_PROJECT_ID.iam.gserviceaccount.com --format="value(uniqueId)"
    ```
1. Add the following scopes:
    - `https://www.googleapis.com/auth/admin.directory.group`
    - `https://www.googleapis.com/auth/admin.directory.user.readonly`
1. Click on `Authorize`

After this is done you should see something like the following:

![Screenshot of the Domain-wide Delegation screen in the Google Admin console](../../assets/domainwidedelegation-screenshot.png)
