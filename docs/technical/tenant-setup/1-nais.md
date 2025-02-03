# Step 1 - Nais-team preparations

## Create the terraform service user

In [nais-terraform-modules](https://github.com/nais/nais-terraform-modules)

Add the new tenant to `serviceaccounts.tf`. 

The name you choose here will be the $NAIS_TENANT_ALIAS used in the next step.

Create a PR and let Atlantis plan and apply the changes.

## Add the new tenant to the Nais billing account

- Billing -> Account Management -> Right side menu -> Add user.

## Ask the tenant about what IP-ranges they want to use

TODO: frode
