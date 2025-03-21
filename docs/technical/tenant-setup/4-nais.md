# Step 4 - Nais post terraforming

## Configure OAuth login for web frontend

Set up an OAuth client for _Console_ in the tenant management project.

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

## Add the API reconcilers user to the billing account

- Billing -> Account Management -> Right side menu (Show info panel) -> Add principal

Add `nais-api-reconcilers@<MANAGEMENT_PROJECT_ID>.iam.gserviceaccount.com` as Billing Account User

## Add new tenant to the documentation repo

1. in .github/workflows/main.yml add the new tenant to the `tenants` list (two places)
1. in docs/workloads/reference/environments.md, add a new section for the tenant with the correct content.
