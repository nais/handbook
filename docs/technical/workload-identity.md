# Nais Workload Identity

Workloads (`Application` and `NaisJob` resources) in Nais Kubernetes clusters are automatically mounted with a Projected Service Account Token (PSAT) that can be used to authenticate with Nais components.

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

### Example: Validating middleware in Go

The [`github.com/coreos/go-oidc/v3/oidc`](https://pkg.go.dev/github.com/coreos/go-oidc/v3/oidc) package handles OIDC discovery, JWKS fetching and caching, signature verification, and validation of the `iss`, `aud`, and time claims for you (validation steps 1–4 above). The remaining step is to validate `sub` and/or the `kubernetes.io` claim yourself (step 5).

The middleware constructor discovers the cluster's OIDC metadata from the issuer and builds a verifier once at startup, then returns an HTTP middleware that verifies the bearer token on each request and puts the resulting claims on the request context:

```go
package middleware

import (
	"context"
	"fmt"
	"net/http"
	"strings"

	"github.com/coreos/go-oidc/v3/oidc"
)

type claims struct {
	Subject    string `json:"sub"`
	Kubernetes struct {
		Namespace      string `json:"namespace"`
		ServiceAccount struct {
			Name string `json:"name"`
			UID  string `json:"uid"`
		} `json:"serviceaccount"`
	} `json:"kubernetes.io"`
}

type ctxAuthKey struct{}

// Authentication builds an HTTP middleware that authenticates requests using a
// projected ServiceAccount token from the given cluster. The issuer is the
// `issuer` value from the cluster's OIDC metadata document.
func Authentication(ctx context.Context, issuer string) (func(http.Handler) http.Handler, error) {
	provider, err := oidc.NewProvider(ctx, issuer)
	if err != nil {
		return nil, fmt.Errorf("initialize OIDC provider: %w", err)
	}

	verifier := provider.Verifier(&oidc.Config{
		ClientID: "nais", // verifies that the `aud` claim contains "nais"
	})

	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// The auth scheme is case-insensitive (RFC 7235 §2.1).
			scheme, bearer, ok := strings.Cut(r.Header.Get("Authorization"), " ")
			if !ok || !strings.EqualFold(scheme, "Bearer") {
				http.Error(w, "missing bearer token", http.StatusUnauthorized)
				return
			}

			idToken, err := verifier.Verify(r.Context(), bearer)
			if err != nil {
				http.Error(w, "invalid token", http.StatusUnauthorized)
				return
			}

			var c claims
			if err := idToken.Claims(&c); err != nil {
				http.Error(w, "invalid token", http.StatusUnauthorized)
				return
			}

			// Apply authorization checks, e.g. require a specific namespace
			// or service account name.
			if c.Kubernetes.Namespace == "" || c.Kubernetes.ServiceAccount.Name == "" {
				http.Error(w, "forbidden", http.StatusForbidden)
				return
			}

			ctx := context.WithValue(r.Context(), ctxAuthKey{}, &c)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}, nil
}
```

If your component must trust more than one cluster, look up the issuer from the unverified token (the `iss` claim) and select the matching verifier before calling `Verify`. Never trust claims from an unverified token for anything other than routing to the correct verifier.

## Usage for consumer workloads

Regardless of how the token is mounted, the PSAT should be considered an **opaque token** for the consumer. The workload should not attempt to parse or validate the token itself, but rather use it as a bearer token when making requests to Nais components:

```http
GET /resource HTTP/1.1
Host: server.example.com
Authorization: Bearer <PSAT>
```

The token is periodically rotated; re-read the token from disk before each use rather than caching its contents.

### For `Application` and `NaisJob` workloads

Nais automatically mounts the PSAT in the workload's filesystem. The path is exposed through the `NAIS_SERVICE_ACCOUNT_TOKEN_PATH` environment variable. No extra configuration is required.

### For raw Kubernetes workloads

Our own internal ("raw") workloads — plain `Pod`, `Deployment`, `Job`, etc. that are not managed by Naiserator — do not get a token mounted automatically. Instead, mount your own PSAT:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-workload
  namespace: my-namespace
---
apiVersion: v1
kind: Pod
metadata:
  name: my-workload
  namespace: my-namespace
spec:
  serviceAccountName: my-workload
  containers:
    - name: my-workload
      image: my-image
      volumeMounts:
        - name: nais-token
          mountPath: /var/run/secrets/nais.io
          readOnly: true
  volumes:
    - name: nais-token
      projected:
        sources:
          - serviceAccountToken:
              path: token
              audience: nais # or the expected audience for the Nais component that the workload calls
              expirationSeconds: 600
```

The token is then available as a file at `/var/run/secrets/nais.io/token`.

### Example: Acquiring the token in Go

Read the token from disk on each request so that rotation is picked up automatically. An [`oauth2.TokenSource`](https://pkg.go.dev/golang.org/x/oauth2#TokenSource) that reads the file makes this transparent when combined with `oauth2.NewClient`:

```go
import (
	"context"
	"fmt"
	"os"
	"strings"

	"golang.org/x/oauth2"
)

// fileTokenSource reads a projected service account token from disk on every
// call, so rotated tokens are picked up without restarting the process.
type fileTokenSource struct {
	path string
}

func (f fileTokenSource) Token() (*oauth2.Token, error) {
	b, err := os.ReadFile(f.path)
	if err != nil {
		return nil, fmt.Errorf("reading token file %q: %w", f.path, err)
	}
	return &oauth2.Token{
		AccessToken: strings.TrimSpace(string(b)),
		TokenType:   "Bearer",
	}, nil
}
```

Use it to build an HTTP client that automatically attaches the bearer token:

```go
// For Application/NaisJob: os.Getenv("NAIS_SERVICE_ACCOUNT_TOKEN_PATH")
// For raw workloads: the projected volume path, e.g. "/var/run/secrets/nais.io/token"
ts := fileTokenSource{path: os.Getenv("NAIS_SERVICE_ACCOUNT_TOKEN_PATH")}

client := oauth2.NewClient(ctx, ts)

// Requests made with this client carry "Authorization: Bearer <PSAT>".
resp, err := client.Get("https://server.example.com/resource")
```

