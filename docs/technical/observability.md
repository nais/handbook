# Observability Stack

This document describes the technical observability stack for nais-system Features.

## Overview

Observability in nais has two parallel stacks, one for nais-system and one for tenant applications. Both stacks are based on the same components but have different configurations.

```mermaid
---
config:
    flowchart:
        defaultRenderer: elk
---
%%{init: {'theme':'dark'}}%%
  flowchart
    subgraph "tenant"
      subgraph "dev"
        prometheus-dev-nais[prometheus\nnais]
        prometheus-dev-tenant[prometheus\ntenant]
      end

      subgraph "prod"
        prometheus-prod-nais[prometheus\nnais]
        prometheus-prod-tenant[prometheus\ntenant]
      end

      subgraph "management"
        grafana-tenant[grafana.tenant.cloud.nais.io] --> prometheus-dev-tenant
        grafana-tenant[grafana.tenant.cloud.nais.io] --> prometheus-prod-tenant
        prometheus-management-nais["prometheus nais"]
      end
    end

    subgraph "nais-io"
      grafana-nais-io[monitoring.nais.io] --> prometheus-dev-nais
      grafana-nais-io[monitoring.nais.io] --> prometheus-prod-nais
      grafana-nais-io[monitoring.nais.io] --> prometheus-management-nais
    end
```

The observability stack in nais consists of the following components:

- [Alertmanager](https://prometheus.io/docs/alerting/alertmanager/)
- [Grafana](https://grafana.com/)
- [Grafana Agent](https://grafana.com/docs/grafana-cloud/agent/)
- [Logging Operator](https://kube-logging.dev)
- [Loki](https://grafana.com/oss/loki/)
- [OpenTelemery Operator](https://opentelemetry.io/docs/operator/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
- [prometheus Operator](https://prometheus-operator.dev/)
- [prometheus](https://prometheus.io/)
- [Tempo](https://grafana.com/oss/tempo/)

## OpenTelemetry Collector

The OpenTelemetry Collector is a vendor-agnostic, open-source telemetry collector that can be used to collect, process, and export telemetry data. It is a powerful tool that can be used to collect logs, metrics, and traces from a variety of sources and export them to a variety of destinations.

OpenTelemetry Collector implements the [OpenTelemetry protocol (OTLP)](https://opentelemetry.io/docs/specs/otlp/) which is a standard for transmitting telemetry data.

=== "Full otlp"

    ```mermaid
    graph LR
      Feature[Feature]
      OtelCollector[Collector]
      Loki
      prometheus
      Tempo

      Feature -- otlp --> OtelCollector

      OtelCollector -- traces --> Tempo
      OtelCollector -- logs --> Loki
      OtelCollector -- metrics --> prometheus

      Tempo -- query --> Grafana
      Loki -- query --> Grafana
      prometheus -- query --> Grafana
    ```

=== "Traces only"

    ```mermaid
    graph LR
      Feature[Feature]
      OtelCollector[Collector]
      LoggingOperator
      Loki
      prometheus
      Tempo

      Feature -- traces --> OtelCollector
      Feature -- stdout/stderr --> LoggingOperator
      LoggingOperator -- forward --> Loki
      Feature -- scrape --> prometheus
      OtelCollector -- traces --> Tempo

      Tempo -- query --> Grafana
      Loki -- query --> Grafana
      prometheus -- query --> Grafana
    ```

### Endpoints

The OpenTelemetry Collector exposes the following endpoints:

| Endpoint                                            | Description                                                   |
| --------------------------------------------------- | ------------------------------------------------------------- |
| `http://opentelemetry-management-collector:4317`    | Internal endpoint for features in nais-system namespace.      |
| `https://collector-internet.<tenant>.cloud.nais.io` | Internet exposed endpoint for things running outside of nais. |

Fasit features can use environment values in `Feature.yaml` to get the correct OpenTelemetry config without hardcoding the endpoint.

??? example "Feature.yaml"
    ```yaml
    values:
      observability.otelp.endpoint:
        computed:
          template: "{{ .Env.otel_otlp_endpoint }}"
      observability.otelp.protocol:
        computed:
          template: "{{ .Env.otel_otlp_protocol }}"
      observability.otelp.insecure:
        computed:
          template: "{{ .Env.otel_otlp_insecure }}"
    ```

### Tenant Clusters

All nais clusters have a dedicated OpenTelemetry Collector instance running in the `nais-system`. Tenant clusters forwards to management cluster using the `otlp-http` endpoint so that all telemetry data from nais-system is collected in a single place.

```mermaid
---
config:
    flowchart:
        defaultRenderer: elk
---
%%{init: {'theme':'dark'}}%%
flowchart
  subgraph "management"[Management Cluster]
    subgraph "management-nais-system"[nais-system]
      OtelCollector[Management Collector]
      Tempo
      Loki
      prometheus
      Feature[Feature]
    end
  end

  subgraph "dev"[Tenant Dev Cluster]
    subgraph "dev-nais-system"[nais-system]
      DevFeature[Feature]
      DevOtelC[Management Collector]
    end
  end

  subgraph "prod"[Tenant Prod Cluster]
    subgraph "prod-nais-system"[nais-system]
      ProdFeature[Feature]
      ProdOtelC[Management Collector]
    end
  end

  Feature -- otlp-grpc --> OtelCollector

  DevFeature -- otlp-grpc --> DevOtelC
  ProdFeature -- otlp-grpc --> ProdOtelC
  DevOtelC -- otlp-http --> OtelCollector
  ProdOtelC -- otlp-http --> OtelCollector

  OtelCollector -- traces --> Tempo
  OtelCollector -- logs --> Loki
  OtelCollector -- metrics --> prometheus
```