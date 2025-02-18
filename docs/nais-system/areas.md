# NAIS areas

To ensure that all parts of NAIS are well taken care of, we have created what we call "areas". Everything we create, have a home in one of these areas. 
Each area has one or two _anchors_. The anchors responsibility is to ensure that the area is well taken care of. They have oversight over the area, and are the go-to person for questions and discussions related to the area. E.g. if an [initiative](nais-system/initiatives.md) is proposed that affects the area, the anchor should be involved in the discussion.

NAIS is divided into several areas, each with its own anchor. The anchor is responsible for the area and is the go-to person for questions and discussions related to the area. The anchor is also responsible for keeping the area's board up to date.

## naisdevice

**Anchor(s):** Vegar

**Components:** naisdevice

## Cluster

**Anchor(s):** Sten

**Components:** nais-terraform-modules, nettverk(mesh, lb, peering), Kubernetes-clustere.

## Persistence

**Anchor(s):** Morten

**Components:** DB, Kafka, ValKey, OpenSearch, Bigquery, Buckets

**Board**: https://github.com/orgs/nais/projects/23/views/1

## Auth

**Anchor(s):** Trong

**Components:** Digdirator, Azurerator, Wonderwall, TokenX, IAP / Forward Auth

**Board**: https://github.com/orgs/nais/projects/27/views/1

## Vulnerabilities

**Anchor(s):** Tommy & Youssef

**Components:** SLSA, DependencyTrack, Picante, vulnerability scanning, Security Champion, supply chain security

## Observability

**Anchor(s):** Hans Kristian & Terje

**Components:** Prometheus, Grafana, Alertmanager, Loki, Tempo, Fluentd/fluentbit, node_exporter, kube-state-metrics, OpenTelemetry

## Tooling

**Anchor(s):** Thomas & Christer

**Components:** Nais API, Console, Nais CLI, Fasit, hookd, deployd, deploy-action. 

## Visuelt

**Anchor(s):** Andreas & Roger

**Components:** Nais Console, nais.io (visuelt), doc (visuelt), ds-svelte, Fasit frontend, naisdevice connection successful

## Meta (+ misc)

**Anchor(s):** Frode, Johnny

**Components:** doc, nais.io, handbook, naiserator, liberator, CLI, actions (deploy, docker-build-push, cdn, "spa-deploy")
 
---

**Misc:**

- KrakenD: Tommy & Sindre
- Unleash: Hans Kristian
- Vault: Trong (https://github.com/orgs/nais/projects/26/views/1)

