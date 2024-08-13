# External ingress

We support adding external ingresses that other controls using cert-manager.
This is easily done by adding a `CNAME` record pointing to an ingress we control.

Read more about delegated domains for dns01 at [cert-manager.io/docs](https://cert-manager.io/docs/configuration/acme/dns01/#delegated-domains-for-dns01).

Underneath I've written the steps needed to take for us to get this working.

## Getting external ingress up and running

I'm going to use `detsombetyrnoe.no` as an example.

1. Ask the secops team do add the following to the domain

    ```
    _acme-challenge.detsombetyrnoe.no  IN  CNAME  _acme-challenge.detsombetyrnoe.inter.nav.no.
    ```

2. Create an Kubernetes `Issuer`:

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: detsombetyrnoe-no
      namespace: nais-system
    spec:
      acme:
        email: frode.sundby@nav.no
        preferredChain: ISRG Root X1
        privateKeySecretRef:
          name: cloud-nais-io-account-key
        server: https://acme-v02.api.letsencrypt.org/directory
        solvers:
        - selector:
            dnsZones:
              - detsombetyrnoe.no
          dns01:
            cnameStrategy: Follow
            cloudDNS:
              hostedZoneName: intern-nav-no
              project: nais-prod-020f
    ```

    You can use `dnsName` if you don't have subdomains, or if you want to be explicit.

3. Then create a Kubernetes `Certificate`:

    ```yaml
	apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: wc-detsombetyrnoe-no
      namespace: nais-system
    spec:
      dnsNames:
      - detsombetyrnoe.no
      - '*.detsombetyrnoe.no'
      issuerRef:
        name: detsombetyrnoe-no
      secretName: wc-detsombetyrnoe-no-tls
    ```

4. After the certificate has been approved by Let's encrypt, you need to notify `loadbalancer` about your certificate secret `wc-detsombetyrnoe-no-tls`.
   Go to [Fasit](https://fasit.nais.io) > Your env > loadbalancer, and add your secret name to the `Certificates` list.
5. Then you need to inform `Naiserator` about the new ingress, `detsombetyrnoe.no`.
   Go to [Fasit](https://fasit.nais.io) > Your env > Naiserator, and add your secret name to the `Extra external hosts` list.
6. Ask the user to add their new ingress to their `nais.yaml`.
7. Success?

### Subdomains? Yeah, but manually...

This solution also supports subdomains, but we need the secops team to add each subdomain as an `_acme_challenge`.

```
_acme-challenge.www.detsombetyrnoe.no	IN	CNAME	_acme-challenge.detsombetyrnoe.intern.nav.no.
```

PS: Make sure there are not other issuer with the `tag: issuewild`!
