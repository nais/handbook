# Wonderwall

[Wonderwall](https://github.com/nais/wonderwall) is an application that handles OpenID Connect authentication as a sidecar to applications.

This is an optional feature that is not enabled by default.

## For Tenant

### Requirements and Setup

#### Identity Provider

The tenant must bring its own identity provider.

Provide the NAIS team with the well-known URL of the identity provider for each cluster, e.g:

```
https://idp.example.com/.well-known/openid-configuration
```

The given identity provider will be the default for all applications in the cluster using Wonderwall.

#### Secret

The tenant must set up a secret for each application that will use Wonderwall.
The secret must fulfill the following:

- Must be in the same namespace as the application
- Must follow the naming convention
    ```
    login-config-<application-name>
    ```
- Must contain the following keys:
    - `WONDERWALL_OPENID_CLIENT_ID` (e.g. `my-client-id`)
    - `WONDERWALL_OPENID_CLIENT_JWK` (this is a private key in JWK format, e.g. `{"kty":"RSA","e":"AQAB","kid":"my-key-id",...}`)

The secret should also contain an annotation that automatically reloads the pod when the data changes:

```yaml
metadata:
  annotations:
    reloader.stakater.com/match: "true"
```

To override the default identity provider configuration, set the `WONDERWALL_OPENID_WELL_KNOWN_URL` key in the same secret.

### Usage by Applications

Configure the application to enable injection of Wonderwall as a sidecar:

```yaml
spec:
  login:
    provider: openid
```

See the [NAIS application reference](https://doc.nais.io/workloads/application/reference/application-spec/#login) for the complete specifications with all possible options.


Additional documentation:

- [Technical documentation on GitHub](https://github.com/nais/wonderwall/tree/master/docs)
- [Developer-focused documentation on NAIS](https://doc.nais.io/auth/explanations/#login-proxy)

If you've configured `WONDERWALL_OPENID_WELL_KNOWN_URL`, the application must also allow egress traffic to the matching host:

```yaml
spec:
  accessPolicy:
    outbound:
      external:
        - host: <identity-provider-host>
```

## For NAIS

### Requirements

- [Aiven](aiven.md) must be enabled for the tenant.

### Enable the Wonderwall feature flag in naiserator

### Enable the Wonderwall feature in Fasit

- Configure `aiven.redisPlan` (e.g. `hobbyist` for development, `startup-4` for production)
- Configure `openid.wellKnownUrl` provided by the tenant (e.g. `https://idp.example.com/.well-known/openid-configuration`)
- _Enable_ `openid.enabled`
- _Disable_ `azure.enabled `
- _Disable_ `idporten.enabled`
- Finally, enable the feature itself
