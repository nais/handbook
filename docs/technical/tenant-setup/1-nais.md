# Step 1 - Nais-team preparations



Nais-team needs to do the following:

- In nais-terraform-modules, add new tenant to serviceaccounts.tf. -> PR -> apply
- add the new user to NAV's billing account (frode, sten or johnny). Billing -> Account Management -> right side menu -> Add user.
- Create group $NAAS_TENANT_NAME-k8s-admins with the email: $NAAS_TENANT_NAME-k8s-admins@nais.io in nais.io admin.google.com # Dette trenger vi vel ikke lenger? kan bare bruke nais@nais.io


Snakk med tenant om IP-ranges, og oppdater nais/core/ipplan
