# TokenX

[TokenX] is the short term for the [OAuth 2.0 Token Exchange][rfc8693] flow implemented in the context of Kubernetes.

It primarily exists of:

- an OAuth 2.0 Authorization server that provides applications with security tokens in order to
securely communicate with each-other in a zero trust architecture.
- a Kubernetes operator to register OAuth 2.0 clients and associated credentials with said Authorization Server.

The intent of the token exchange flow is to ensure that the original subject's identity and permissions are propagated
through a request chain of multiple applications, while maintaining security between each application.

This is an optional addon in NaaS. It is not enabled by default.

## For Tenant

Provide the NAIS team with a list of URLs pointing to metadata documents for OAuth 2.0 / OpenID Connect compliant identity providers.
This is often referred to as well-known URLs, typically ending in `/.well-known/openid-configuration` or `/.well-known/oauth-authorization-server`

Otherwise, see [TokenX] for usage.

## For NAIS operators

1. Enter the tenant-provided well-known URL(s) in the Fasit configuration.
    - Enter the equivalent hosts for the outbound hosts needed for external access policies.
2. Generate a set of public/private keypair in JWK format, e.g. through <https://mkjwk.org/>.
    - Specifications:
        - Key Type: RSA
        - Key Size: 2048
        - Key Usage: Signature
        - Algorithm: RS256
        - Key ID: SHA256
    - The private key is used by Jwker to sign JWT assertions to authenticate itself with Tokendings.
    - The public keyset (JWKS) is used by Tokendings to verify client assertions from Jwker.
3. Enable Jwker in Naiserator.
4. Enable the TokenX feature.

[TokenX]: https://doc.nais.io/security/auth/tokenx/
[rfc8693]: https://www.rfc-editor.org/rfc/rfc8693.html
