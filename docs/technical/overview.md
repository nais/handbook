# NAIS Overview

This document is a high-level overview of the NAIS platform

## Namespaces

Over the years we have a number of namespaces that we use for different purposes. The ones to know about are:

| Name | Description |
| ---- | ----------- |
| `nais-system` | Where we deliver NAIS functionality |
| `nais` | Team namespace for NAIS. Custom functionality for NAV |
| `nais-verification` | Test applications for verifying NAIS with alerts |
| `kyverno` | Only [Kyverno](https://kyverno.io/) is allowed in here |
| `cnrm-system` | Where [Cloud Native Resource Manager](https://cloud.google.com/config-connector/docs/overview) runs. Managed by Google |

## Tenants
Apart from the tenants where we have users, we have some additional google organizations for various purposes

### nais.io
This is the central tenant where we have all the tools and services that are shared across all the other tenants, like: 
- billing datasets 
- monitoring and logging for the nais team
- fasit and pubsub topics for distributing configuration to other tenants
- buckets with terraform state
- naisdevice control plane
- our nais.io-users and nais.io-admins group
This tenant has its own terraform project called [nais-io-terraform-modules](https://github.com/nais/nais-io-terraform-modules)

### ci-nais.io
This environment shall remain untouched by human hands. All features are installed and verified in this tenant before being rolled out to the other tenants.
This tenant is configured by [nais-terraform-modules](https://github.com/nais/nais-terraform-modules)
It is marked in Fasit as a CI environment

### dev-nais.io
This is the tenant where we test new features and experiment with configuration
This tenant is configured by [nais-terraform-modules](https://github.com/nais/nais-terraform-modules)

### test-nais.no
An environment for potential future tenants to test out the platform.
It is not connected to Aiven, so testing is limited to basic functionality.
When someone wants access to test-nais.no, we will create test-nais.no users for them manually.
This tenant is configured by [nais-terraform-modules](https://github.com/nais/nais-terraform-modules)

All of the above tenants are accessible with our nais.io-user.
However, we sometimes need to access resources as a tenant user. These users are created manually by someone with admin privileges to the tenant's admin account. (Frode, Johnny, Sten, Vegar, Morten, Trong)
