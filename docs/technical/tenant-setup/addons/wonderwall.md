# Wonderwall

[Wonderwall](https://github.com/nais/wonderwall) is an application that handles OpenID Connect authentication as a sidecar to applications.

This is an optional feature that is not enabled by default.

## For Tenant

### Requirements and Setup

#### Identity Provider

The tenant must bring its own identity provider.

Provide the Nais team with the well-known URL of the identity provider for each cluster, e.g:

```
https://idp.example.com/.well-known/openid-configuration
```

The given identity provider will be the default for all applications in the cluster using Wonderwall.

#### Usage by Applications

The tenant must set up a secret for each application that will use Wonderwall.
The secret must be in the same namespace as the application.

Follow the [instructions over at the Nais documentation](https://doc.nais.io/auth/how-to/login/).

To override the default identity provider configuration, you can set the `WONDERWALL_OPENID_WELL_KNOWN_URL` key in the same secret.
If you've configured `WONDERWALL_OPENID_WELL_KNOWN_URL`, the application must also allow egress traffic to the matching host:

```yaml
spec:
  accessPolicy:
    outbound:
      external:
        - host: <identity-provider-host>
```

## For Nais

### Requirements

- [Aiven](aiven.md) must be enabled for the tenant.

### 1. Enable the Wonderwall feature flag in Fasit for Naiserator

### 2. Enable the Wonderwall feature in Fasit

- Configure `aiven.redisPlan` (e.g. `hobbyist` for development, `startup-4` for production)
- Configure `openid.wellKnownUrl` provided by the tenant (e.g. `https://idp.example.com/.well-known/openid-configuration`)
- _Enable_ `openid.enabled`
- Finally, enable the feature itself
