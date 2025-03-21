# NAIS Overview
This document is a high-level overview of the NAIS platform

## Namespaces
Over the years we have a number of k8s namespaces that we use for different purposes.
The ones to know about are:

| Name | Description |
| ---- | ----------- |
| `nais-system` | Where we deliver NAIS functionality |
| `nais` | Team namespace for NAIS. Custom functionality for NAV |
| `nais-verification` | Test applications for verifying NAIS with alerts |
| `kyverno` | Only [Kyverno](https://kyverno.io/) is allowed in here |
| `cnrm-system` | Where [Cloud Native Resource Manager](https://cloud.google.com/config-connector/docs/overview) runs. Managed by Google |

## Tenants
All of our tenant's k8s clusters are accessible with our `@nais.io` user.

However, sometimes we need to access resources _as_ a tenant user.
These users are created manually by someone with admin privileges to the tenant's admin account (Frode, Johnny, Sten, Vegar, Morten, Trong).

For guides, hints, and tricks on how to navigate between tenants in daily work-flows, see [tenant switching workflows](/docs/daily-workflows/tenant-switching-workflows.md).

### nais' Google-organization tenants
Apart from the tenants we offer to our users, we have some additional google organizations for various purposes:

#### nais.io
This is the central tenant where we have all the tools and services that are shared across all the other tenants, like:

- billing datasets
- monitoring and logging for the nais team ([https://monitor.nais.io](https://monitor.nais.io))
- fasit and pubsub topics for distributing configuration to other tenants ([https://fasit.nais.io](https://fasit.nais.io))
- buckets with terraform state
- naisdevice's control plane
- our `@nais.io` -users and -admins groups

This tenant has its own terraform project called [nais-io-terraform-modules](https://github.com/nais/nais-io-terraform-modules).

#### ci-nais.io
This environment shall remain untouched by human hands.
All features are installed and verified in this tenant before being rolled out to the other tenants.

This tenant is configured by [nais-terraform-modules](https://github.com/nais/nais-terraform-modules).

It is marked in Fasit as a CI environment.

#### dev-nais.io
This is the tenant where we test new features and experiment with configuration.

This tenant is configured by [nais-terraform-modules](https://github.com/nais/nais-terraform-modules).

#### test-nais.no
An environment for potential future tenants to test out the platform.
It is not connected to Aiven, so testing is limited to basic functionality.
When someone wants access to test-nais.no, we will create test-nais.no users for them manually.

This tenant is configured by [nais-terraform-modules](https://github.com/nais/nais-terraform-modules)
