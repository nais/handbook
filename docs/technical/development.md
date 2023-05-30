# How we develop NAIS

> Do one thing, and do it well - Unix philosophy

NAIS is made up by a number of components, each has their own repository and release cycle. This document describes how we develop NAIS.

## NAIS namespaces

Over the years we have a number of namespaces that we use for different purposes. The most important ones are:

| Name | Description | Status |
| ---- | ----------- | ------ |
| `nais` | Team namespace for NAIS (example) application | Some what deprecated |
| `nais-system` | Current namespace for NAIS components | Active |
| `nais-verification` | Test applications for verifying NAIS with alerts | Active |

### Special namespaces

Some namespaces are special and should not be used for NAIS components.

| Name | Description | Owner |
| ---- | ----------- | ----- |
| `default` | Default namespace Kubernetes | Kubernetes |
| `kube-system` | Kubernetes system namespace | Kubernetes |
| `kube-public` | Kubernetes public namespace | Kubernetes |
| `cnrm-system` | [Cloud Native Resource Manager](https://cloud.google.com/config-connector/docs/overview) | Google |
| `configconnector-operator-system` | [Cloud Native Resource Manager](https://cloud.google.com/config-connector/docs/overview) | Google |
| `kyverno` | Only [Kyverno](https://kyverno.io/) is allowed here | NAIS |

### Deprecated namespaces

These namespaces are deprecated and should not be used for new components.

| Name | Description | Status |
| ---- | ----------- | ------ |
| `aura` | Previous namespace for Aura components | Deprecated |
| `nginx` | Previous namespace for nginx ingress controller | Deprecated |
| `plattformsikkerhet` | Previous namespace for plattformsikkerhet components | Deprecated |
