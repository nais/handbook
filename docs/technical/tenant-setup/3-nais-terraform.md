# Step 3 - Nais: terraforming the tenant

Here we describe the steps required to run through the terraform as this is not necessarily a straight forward process.

## Nais-terraform-modules repository

1. Copy an existing tenant folder to get have naas.tf and main.tf as templates.
   - A (non-exhaustive) list of things needed:
      1. Their "nais folder ID"
      1. GitHub org name
      1. GCP org ID
      1. CIDR routing ranges per env
      1. If they want "cost viewing" (BQ) experience, a `tenant_cost_viewer_group` must be created by tenant
1. Update the naas.tf and main.tf files to represent desired reality.
    - To maximize profit, wait with adding domains that require manual certificates.
1. Add the new tenant to atlantis.yaml
1. `naisd` must be manually deployed with helm to each new tenant cluster before fasit will work
    - Remember to set the `--version` flag for the fasit helm chart

## console.cloud.google.com -> nais-io project

1. Add `nais-tf-<tenant>@nais-io.iam.gserviceaccount.com` by visiting the `https://search.google.com/search-console?resource_id=sc-domain%3Adoc.<tenant>.cloud.nais.io` domain with your Nav (not Nais) user.
