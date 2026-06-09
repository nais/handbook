# Privileges and users

See [Typical workflow examples](daily-workflows/tenant-switching-workflows) for a reminder on how to approach user juggling (or the lack thereof) in relation to tenants.

## Nais-io user

The nais-io user is used to administer Nais across all tenants.
This user has very few permissions by default, but you can elevate your access as needed using [narc](narcos).
Be aware that the `reason` field in `narc` commands is mandatory, it is important to justify why you need access to a specific resource, as this is logged and visible to tenants.
With elevated access, your permissions are expanded for a limited period within the nais directory of the individual tenant.

## Tenant user

Sometimes we need to test how the functionality we have built is experienced by developers on nais.
For this purpose we have dedicated users in some of the test tenants, dev-nais users in the dev-nais tenant.
With this user you can explore the console, create teams, and use the platform as a regular developer.
These users are created manually by someone with admin access to the tenant.

## Superadmin

In addition to being Nais administrators, we are also responsible for NAV's GCP organization.
This requires permissions beyond the nais directory, and a handful of people in the nais team have personal impersonal users secured with a physical key that are able to perform actions at the organization level.
