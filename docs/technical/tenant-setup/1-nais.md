# Step 1 - Nais: preparations

## Create the terraform service user

In [nais-terraform-modules](https://github.com/nais/nais-terraform-modules):

Add the new tenant to `serviceaccounts.tf`.
The name chosen here will be the `$TENANT` used in the next step.

Create a PR and let Atlantis plan and apply the changes.

## Add the new tenant to the Nais billing account

Use your Nav GCP (@nav.no) account to do this:

- https://console.cloud.google.com/billing/
    - Billing -> Account Management -> Right side menu (Show info panel) -> Add principal

Add `nais-tf-<TENANT>@nais-io.iam.gserviceaccount.com` as Billing Account User

## Decide cluster IP-ranges

Make sure we have IP-ranges that do not overlap with the tenant's existing infrastructure.
So ask the tenants if they have any preferences for ranges to use, or to avoid.

### Example ranges

```text
Management
  ip_cidr_range           = "10.17.0.0/23"
  pods_ip_cidr_range      = "10.17.64.0/18"
  svc_ip_cidr_range       = "192.168.0.0/21"
  master_ip_cidr_range    = "172.16.0.0/28"
  loadbalancer_cidr_range = "100.64.0.0/24"
  aiven_vpc_cidr_range    = "10.10.1.0/24"
  psa_ip_cidr_range       = "100.65.0.0/24"

Dev
  ip_cidr_range            = "10.17.2.0/23"
  pods_ip_cidr_range       = "10.17.128.0/18"
  svc_ip_cidr_range        = "192.168.4.0/21"
  master_ip_cidr_range     = "172.16.0.16/28"
  loadbalancer_cidr_range  = "100.64.1.0/24"
  shared_vpc_ip_cidr_start = "100.71.0.0"
  aiven_vpc_cidr           = "10.17.8.0/24"

Prod
  ip_cidr_range            = "10.17.4.0/23"
  pods_ip_cidr_range       = "10.17.192.0/18"
  svc_ip_cidr_range        = "192.168.8.0/21"
  master_ip_cidr_range     = "172.16.0.32/28"
  loadbalancer_cidr_range  = "100.64.2.0/24"
  shared_vpc_ip_cidr_start = "100.71.16.0"
  aiven_vpc_cidr           = "10.17.9.0/24"
```
