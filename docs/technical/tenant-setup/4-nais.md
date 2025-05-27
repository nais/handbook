# Step 4 - Nais post terraforming

## Add the API reconcilers user to the billing account

- Billing -> Account Management -> Right side menu (Show info panel) -> Add principal

Add `nais-api-reconcilers@<MANAGEMENT_PROJECT_ID>.iam.gserviceaccount.com` as Billing Account User

## Add new tenant to the documentation repo

1. in .github/workflows/main.yml add the new tenant to the `tenants` list (two places)
1. in docs/workloads/reference/environments.md, add a new section for the tenant with the correct content.
