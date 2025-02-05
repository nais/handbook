# Step 3 - Nais terraforming the tenant

Here we describe the steps required to run through the terraform as this is not necessarily a straight forward process.

## Nais-terraform-modules repository

1. Copy an existing tenant folder to get have naas.tf and main.tf as templates.
1. Update the naas.tf and main.tf files to represent desired reality.
1. Add the new tenant to atlantis.yaml

## console.cloud.gooogle.com -> nais-io project

1. go to secret manager and create two empty secrets named:
   - <tenantname>-management-iap-client-id
   - <tenantname>-management-iap-client-secret
1. location europe-north1, labels: "provisioned: manually"
1. add dummy content to make sure we have a latest version
1. grant the nais-tf-<tenant>@nais-io.iam.gserviceaccount.com the role `roles/secretmanager.secretAccessor` on the secrets
1. add nais-tf-<tenant>@nais-io.iam.gserviceaccount.com to the domain https://search.google.com/search-console?resource_id=sc-domain%3Adoc.<tenant>.cloud.nais.io
