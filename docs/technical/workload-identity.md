# Nais Workload Identity

Workloads in Nais Kubernetes clusters are automatically mounted with a Projected Service Account Token (PSAT) that can be used to authenticate with Nais components.

See the implementation in [Naiserator](https://github.com/nais/naiserator/blob/05ca9ee1a5b6d72f7f2b6c1cac8ae54338c78f2c/pkg/resourcecreator/serviceaccount/serviceaccount.go) for details.

## Usage for Nais components

Nais components that require authentication must validate the incoming PSAT as a JWT.

### OIDC Metadata Document

The token is a standard JWT that can be validated using the [OIDC Metadata Document](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata) for a given cluster.

The URL to the metadata document is available in Fasit as an environment variable for each environment under the key `apiserver_oidc_well_known_url`.

Example metadata document:

```json
{
  "issuer": "https://container.googleapis.com/v1/projects/nais-dev-2e7b/locations/europe-north1/clusters/nais-dev",
  "jwks_uri": "https://container.googleapis.com/v1/projects/nais-dev-2e7b/locations/europe-north1/clusters/nais-dev/jwks",
  "response_types_supported": ["id_token"],
  "subject_types_supported": ["public"],
  "id_token_signing_alg_values_supported": ["RS256"],
  "claims_supported": ["iss", "sub", "kubernetes.io"],
  "grant_types": ["urn:kubernetes:grant_type:programmatic_authorization"]
}
```

### JWT Claims

The JWT always includes `nais` in its `aud` (audience) claim, which prevents the token from being reused against non-Nais audiences. Per [RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.3), validators must accept `aud` either as a string or as an array of strings.

It otherwise contains standard claims such as `iss` (issuer) and `sub` (subject), `exp` (expiration time), `iat` (issued at), as well as a custom claim `kubernetes.io` that contains additional metadata such as the Kubernetes Service Account name and namespace.

Example:

```json
{
  "aud": ["nais"],
  "exp": 1729605240,
  "iat": 1729601640,
  "iss": "https://container.googleapis.com/v1/projects/nais-dev-2e7b/locations/europe-north1/clusters/nais-dev",
  "jti": "aed34954-b33a-4142-b1ec-389d6bbb4936",
  "kubernetes.io": {
    "namespace": "my-namespace",
    "node": {
      "name": "my-node",
      "uid": "646e7c5e-32d6-4d42-9dbd-e504e6cbe6b1"
    },
    "pod": {
      "name": "my-pod",
      "uid": "5e0bd49b-f040-43b0-99b7-22765a53f7f3"
    },
    "serviceaccount": {
      "name": "my-serviceaccount",
      "uid": "14ee3fa4-a7e2-420f-9f9a-dbc4507c3798"
    }
  },
  "nbf": 1729601640,
  "sub": "system:serviceaccount:my-namespace:my-serviceaccount"
}
```

See also <https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#serviceaccount-token-volume-projection>.

Note that the `kubernetes.io.pod` and `kubernetes.io.node` claims may be omitted if the token was minted from the API-server instead of the kubelet, for example when running `kubectl create token`.

### JWT Validation

Validators must:

1. **Verify the signature** against the cluster issuer's JWKS (from `jwks_uri` in the metadata document).
2. **Verify `iss`** matches the `issuer` from the cluster's OIDC metadata document ([BCP 225 — Validate Issuer and Subject](https://datatracker.ietf.org/doc/html/rfc8725#section-3.8)).
3. **Verify `aud`** contains `nais`. Accept both string and array forms ([RFC 7519 §4.1.3](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.3), [BCP 225 — Use and Validate Audience](https://datatracker.ietf.org/doc/html/rfc8725#section-3.9)).
4. **Verify time claims** (allow up to 30 seconds of clock skew; most JWT libraries default to 30–60 seconds):
    - `exp` must be in the future ([RFC 7519 §4.1.4](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.4)).
    - `iat` must be in the past or present ([RFC 7519 §4.1.6](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.6)).
    - `nbf`, if present, must be in the past or present ([RFC 7519 §4.1.5](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.5)).
5. **Validate `sub` and/or `kubernetes.io`** as needed — e.g. require `sub` starts with `system:serviceaccount:`, or a specific namespace/service account.

### JWKS caching

Cache the JWKS document (e.g. for 5–15 minutes) rather than fetching it on every request. Refresh on signature verification failure to handle key rotation.

## Usage for consumer workloads

The PSAT is mounted in the workload's filesystem at the path given by the `NAIS_SERVICE_ACCOUNT_TOKEN_PATH` environment variable.

The token is periodically rotated; re-read the file before use rather than caching its contents.

The PSAT should be considered an opaque token for the consumer. The workload should not attempt to parse or validate the token itself, but rather use it as a bearer token when making requests to Nais components:

```http
GET /resource HTTP/1.1
Host: server.example.com
Authorization: Bearer <PSAT>
```
