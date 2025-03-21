# Digdirator

!!! info "Digdirator enabled"
    This is an optional addon in NaaS. It is not enabled by default.

[Digdirator](https://github.com/nais/digdirator) is a feature that integrates with Digdir self-service API. Digdirator
enables automated registration and lifecycle management of ID-porten and Maskinporten clients.

Before Digdirator can use the self-service API, the tenant must receive administration clients from Digdir,
one for each client type, Maskinporten and ID-porten.
The Digdir self-service API is secured with oAuth2 using a `business certificate`.

An overview of the setup is as follows:

* Clients exist in Digdir and a `business certificate` is configured
* Clients are configured with [scopes](#digdir-configuration) required
* Add Client ID's to Secret Manager in your project
* Add `business certificate` to Google Key Management Service in your project
* Add business certificate `certificate-chain` to Secret Manager in your project

## For Tenant

### Requirements

#### Digdir configuration

??? info "Recommended configuration for administration clients"
    To secure the integration with Digdir we recommend using a separate certificate for each registered client and that tenants request Digdir to lock each
    certificate to each client. If you already have a certificate for your clients, you can use that. As setup with these kinds of certificates
    is not part of this guide, we recommend that you contact Digdir for assistance.

##### Configure administration clients for ID-porten & Maskinporten

* ID-porten client is configured with scopes: `idporten:dcr.write idporten:dcr.read`
* Maskinporten client is configured with scopes: `idporten:dcr.write idporten:dcr.read idporten:scopes.write`
* `business certificates` are registered in Digdir

!!! success "Tenant imports the Client ID's to [Secret Manager](#google-secret-manager) and provide the resource names to NAIS"
    `projects/<project-id>/secrets/<secret-id>/versions/<version>`

??? info "Digdirator use of Client ID"
    Digdirator sets the Client ID as the claim `iss` when authenticating against Digdir self-service API

#### NAIS configuration

We really care about our compadres (tenants) and we think that a separation of concerns is a good & secure way to
go.
It also helps us to keep the cluster secure and stable. The configuration setup for Digdirator favor security as
NAIS never have direct access to your business certificate.

When setup in Digdir is confirmed by tenant and before we can enable Digdirator, the following steps must be completed:

##### Business certificate

??? info "Update existing certificate"
    Update of a certificate only requires the tenant to provide NAIS with the new `<version>`

The tenant upload their `business certificate` to
[Google Cloud KMS](https://cloud.google.com/kms/docs/how-tos). Digdirator will never have direct access to the certificate.
Once it is uploaded the business certificate can only be used for cryptographic operations.
The business certificate can never be downloaded or retrieved from the KMS storage.

An authenticated & authorized Digdirator can only request the `Google KMS` to sign a payload containing an unsigned
token with claims, if successful the KMS returns a signed JWT, this JWT is later used to authenticate against Digdir self-service
API.

!!! success "Certificate is [successfully uploaded](#import-certificates) to Google KMS, provide NAIS with the resource names"
    `projects/<project-id>/locations/<location>/keyRings/<keyring>/cryptoKeys/<key>/cryptoKeyVersions/<version>`

##### Certificate chain

??? info "Update existing certificate chain"
    This information unlikely to change, only if a new certificate type is added to the Google KMS.
    Then the tenant must provide the new resource name or `<version>` of the certificate chain.

Now your probably are wondering why another secret storage we already configured KMS?

Well, when authenticating using a `buissness certificate` the oauth2.0 spec recommends the `certificate chain` to be
present in the token header.

The public `certificate chain` should be set to the `x5c` (X.509 certificate chain) header parameter, corresponding to
the key used to digitally sign the JWS (JSON Web Signature).

`Google Cloud Key Mangement Service` is designed as a cryptographic system: nobody, including yourself, can get the keys
out: this means they're locked inside the system, and you don't have to worry in practice about them leaking.
The tradeoff is that the only thing you can do with those keys is encrypting, decrypt, and other cryptographic
operations.

But when you do have configuration info like a certificate chain or a client-id, where your software actually needs the
secret, not cryptographic operations, then `Secret Manager` is designed for that use case.

!!! success "Certificate chains is [successfully uploaded](#import-certificates) to `Secret Manager`, provide NAIS with the resource names"
    `projects/<project-id>/secrets/<secret-id>/versions/<version>`

###### Example format of a certificate chain

```Text
-----BEGIN CERTIFICATE-----
MIIFCDECEBC...
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIE3sKEA...
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFZTKK...
-----END CERTIFICATE-----
```

## For NAIS

When Digdirator is enabled, NAIS configures Digdirator with a service account which holds a set of roles to access Google Cloud KMS and Secret Manager in your
cluster project.

To access `Google KMS` the service account is assigned the IAM role `roles/cloudkms.signerVerifier`,
which enables sign, verify, and getPublicKey operations.

??? info "Google Cloud KMS roles"
    ```Text
    cloudkms.cryptoKeyVersions.useToSign
    cloudkms.cryptoKeyVersions.useToVerify
    cloudkms.cryptoKeyVersions.viewPublicKey
    cloudkms.locations.get
    cloudkms.locations.list
    resourcemanager.projects.get
    ```

To access `Secret Manager` the service account is assigned the IAM role `roles/secretmanager.secretAccessor` which allows Digdirator to
access the payload of secrets.

??? info "Google Secret Manager roles"
    ```Text
    secretmanager.secrets.get
    secretmanager.secrets.access
    resourcemanager.projects.get
    ```

NAIS will configure Digdirator with the information provided, you relax your cognitive load.
Configure your [NAIS application](https://docs.nais.io/nais-application/application/) with ID-porten or Maskinporten, push code -> deploy.
NAIS handles the rest.

!!! warning "ID-porten sidecar"
    If you plan to use the [ID-porten sidecar](https://docs.nais.io/security/auth/idporten/sidecar/?h=sidecar), prior to usage, the feature [Wonderwall](https://docs.nais.io/appendix/wonderwall/) must be enabled.
    Contact NAIS team for more information.

## Summary of NAIS configuration

If we were to translate the above information required by NAIS to configure automated lifecycle of Digdir clients.
Translated to yaml, it would look something like this

```yaml
maskinporten:
  kms:
    key: "projects/123456789/locations/europe-north1/keyRings/nais-test/cryptoKeys/maskinporten-cert-chain/cryptoKeyVersions/1"
  secret-manager:
    client-id: "projects/123456789/secrets/maskinporten-client-id/versions/1"
    cert-cain: "projects/123456789/secrets/maskinporten-cert-chain/versions/1"
idporten:
  kms:
    key: "projects/123456789/locations/europe-north1/keyRings/nais-test/cryptoKeys/idporten-cert-chain/cryptoKeyVersions/1"
  secret-manager:
    client-id: "projects/123456789/secrets/idporten-client-id/versions/1"
    cert-cain: "projects/123456789/secrets/idporten-cert-chain/versions/1"
```

## Import Certificates

### Pre-requisites

[gcloud](https://cloud.google.com/sdk/docs/install) CLI is installed and configured with a user that have access to the
project.

Some configuration can be done in the Google Cloud Console, automatic wrap and import must be done with the `gcloud`
CLI.

#### Google Cloud KMS

1. Create a [target key and key ring](https://cloud.google.com/kms/docs/importing-a-key#create_targets) in your project
2. Create a [import job](https://cloud.google.com/kms/docs/importing-a-key#import_job) for the target key.
3. Make an import request for [key](https://cloud.google.com/kms/docs/importing-a-key#request_import)

4. Wrap and import of key can be done in automatically or manually.

    * Automatically [wrap and import](https://cloud.google.com/kms/docs/importing-a-key#automatically_wrap_and_import)
      with `gcloud` CLI
    * Manually is divided into 2 steps
        * [Manually wrap](https://cloud.google.com/kms/docs/wrapping-a-key) using OpenSSL for Linux or macOS.
        * [Manually import](https://cloud.google.com/kms/docs/importing-a-key#importing_a_manually-wrapped_key) in the
          Google
          Cloud Console or gcloud CLI.

#### Google Secret Manager

* Create a [secret](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#creating_a_secret) in
  your project
