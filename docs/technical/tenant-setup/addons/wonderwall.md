# Wonderwall

[Wonderwall](https://github.com/nais/wonderwall) is an application that handles OpenID Connect authentication as a sidecar to applications.

This is an optional feature that is not enabled by default.

## For Tenant

### Requirements and Setup

The tenant must bring its own identity provider.

The tenant must set up a secret for each application that will use Wonderwall.
The secret must fulfill the following:

- Must be in the same namespace as the application
- Must follow the naming convention `login-config-<application-name>`
- Must contain the following keys:
  - `WONDERWALL_OPENID_CLIENT_ID` (e.g. `my-client-id`)
  - `WONDERWALL_OPENID_CLIENT_JWK` (e.g. `{"kty":"RSA","e":"AQAB","kid":"my-key-id",...}`)
  - `WONDERWALL_OPENID_WELL_KNOWN_URL` (e.g. `https://idp.example.com/.well-known/openid-configuration`)

### Usage by Applications

To use Wonderwall, the application must be configured to use the sidecar:

```yaml
spec:
  login:
    provider: openid
```

The application must also be configured to allow external traffic to the identity provider:

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

- Configure `aiven.redisPlan`
- Enable `openid.enabled`
- Disable `azure.enabled `
- Disable `idporten.enabled`
- Finally, enable the feature itself
