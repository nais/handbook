# Custom Domains

Nais comes with default domains and certificates for applications under the `cloud.nais.io` domain, but tenants can also use their own custom domains.

## For Tenant

### Requirements and Setup

* A domain
* A DNS provider that supports CNAME records

### DNS Configuration

1. Create a `CNAME` record for the domain pointing to one of existing environment domains.

```plaintext
*.example.com             CNAME <tenant>.cloud.nais.io.
*.intern.example.com      CNAME internal.<tenant>.cloud.nais.io.
*.dev.example.com         CNAME external.dev.<tenant>.cloud.nais.io.
*.intern.dev.example.org  CNAME dev.<tenant>.cloud.nais.io.
```

2. Provide the list of domains to the NAIS team.

## For Nais

1. Add the correct domain to the tenant in nais-terraform-modules under `external_loadbalancers` and `internal_loadbalancers`.

```hcl
  external_loadbalancers = {
    "external" = {
      backends = [
        {
          neg = "dev-external",
          domains = [
            { name = "external.dev.example.cloud.nais.io", dns_zone = module.management.info.tenant_dns_zone, subdomains = ["*"] },
            { name = "dev.example.org", dns = [], cert = ["auto_wc"], subdomains = ["*"] },
          ]
        }
      ]
    },
  }
```

   * Provide the tenant with the ACME DNS challenge token for the domain. This is the `custom_dns_authorizations` output from terraform.

1. Add the domain to the environment in nais/doc.
2. Add the domain to the naiserator feature in Fasit.

* `Extra internal hosts` and `Extra external hosts` in the `naiserator` feature in Fasit.

4. Ensure the DNS configuration is properly documented.
5. Verify that the custom domain is working as expected and that certificates are being provisioned correctly.
