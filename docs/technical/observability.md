# Observability Stack

Sit back and relax, we got you covered. The observability stack in nais is designed to provide you with all the tools you need to monitor and troubleshoot your applications.

## Overview

On a high level there are two parallel observability stacks in nais, one for nais-system namespaces (we call it the management stack) and one for tenant applications. Both stacks are based on the same components – Prometheus for metrics, Loki for logs, and Tempo for traces and Grafana for visualization.

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
        prometheus-dev-nais[nais-system]
        prometheus-dev-tenant[team apps]
      end

      subgraph "prod"
        prometheus-prod-nais[nais-system]
        prometheus-prod-tenant[team apps]
      end

      subgraph "management"
        grafana-tenant[grafana.$tenant.cloud.nais.io] --> prometheus-dev-tenant
        grafana-tenant[grafana.$tenant.cloud.nais.io] --> prometheus-prod-tenant
        prometheus-management-nais[nais-system]
      end
    end

    subgraph "nais-io"
      grafana-nais-io[monitoring.nais.io] --> prometheus-dev-nais
      grafana-nais-io[monitoring.nais.io] --> prometheus-prod-nais
      grafana-nais-io[monitoring.nais.io] --> prometheus-management-nais
    end
```

The observability stack in nais consists of the following components:

<div class="grid cards" markdown>

- :simple-prometheus: [__Prometheus Operator__](https://prometheus-operator.dev/) for managing Prometheus instances, providing easy monitoring definitions for Kubernetes services and deployment and management of Prometheus instances.
- :simple-prometheus: [__Prometheus__](https://prometheus.io/) for metrics, offering powerful querying and alerting capabilities to monitor the performance and health of applications.
- :simple-prometheus: [__Alertmanager__](https://prometheus.io/docs/alerting/alertmanager/) for alerting, handling alerts sent by client applications such as the Prometheus server and managing silencing, inhibition, and alert grouping.
- :simple-grafana: [__Grafana__](https://grafana.com/) for visualization, enabling the creation of dashboards and graphs to visualize metrics, logs, and traces from various data sources.
- :simple-grafana: [__Grafana Loki__](https://grafana.com/oss/loki/) for logs, providing a highly efficient and cost-effective log aggregation system that integrates seamlessly with Grafana.
- :simple-grafana: [__Grafana Tempo__](https://grafana.com/oss/tempo/) for traces, offering a scalable and high-performance distributed tracing backend that integrates with Grafana for trace visualization.
- :simple-opentelemetry: [__OpenTelemetry Collector__](https://opentelemetry.io/docs/collector/) for collecting, processing, and exporting telemetry data, supporting multiple formats and providing a vendor-agnostic solution for telemetry data management.
- :simple-fluentd: [__Logging Operator__](https://kube-logging.dev) for collecting logs from stdout/stderr, simplifying the deployment and management of Fluentd log collectors in Kubernetes environments.

</div>

## OpenTelemetry Collector

The OpenTelemetry Collector is a vendor-agnostic, open-source telemetry collector that can be used to collect, process, and export telemetry data. It is a powerful tool that can be used to collect logs, metrics, and traces from a variety of sources and export them to a variety of destinations.

OpenTelemetry Collector implements the [OpenTelemetry protocol (OTLP)](https://opentelemetry.io/docs/specs/otlp/) which is a standard for transmitting telemetry data.

We have two parallel OpenTelemetry Collectors running in nais, one for the management stack and one for tenant applications. The management collector is used to collect telemetry data from nais-system namespaces and the tenant collector is used to collect telemetry data from tenant applications.

```mermaid
---
config:
    flowchart:
        defaultRenderer: elk
---
%%{init: {'theme':'dark'}}%%
  flowchart
    subgraph "tenant"
      subgraph "$env"
        subgraph "$env-nais-system" [nais-system]
          $env-management-collector[Management Collector]

          $env-otel-internet-collector[Internet Collector]
          $env-otel-collector[Collector]
          $env-tempo[Grafana Tempo]
          $env-loki[Grafana Loki]
          $env-prometheus[Prometheus]
        end
      end

      subgraph "management"
        subgraph "nais-system"
          management-internet-collector[Internet Collector]
          management-collector[Collector]
          management-tempo[Grafana Tempo]
          management-loki[Grafana Loki]
          management-prometheus[Prometheus]
        end
      end
    end

    $env-otel-collector -- traces --> $env-tempo
    $env-otel-collector -- logs --> $env-loki
    $env-otel-collector -- metrics --> $env-prometheus

    management-collector -- traces --> management-tempo
    management-collector -- logs --> management-loki
    management-collector -- metrics --> management-prometheus

    naisdevice -- otlp --> management-internet-collector
    management-internet-collector -- otlp --> management-collector

    $env-management-collector -- otlp --> management-collector

    github[GitHub Actions] -- otlp --> $env-otel-internet-collector
```

=== "Full otlp"

    Full otlp is used when all telemetry data is sent to the OpenTelemetry Collector including logs, metrics, and traces.

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

    Traces only is used when only traces are sent to the OpenTelemetry Collector, logs are sent using stdout/stderr and metrics are scraped by Prometheus.

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