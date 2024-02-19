# Observability Stack

This document describes the technical observability stack for nais-system applications.

## Overview

The observability stack in nais consists of the following components:

- [Alertmanager](https://prometheus.io/docs/alerting/alertmanager/)
- [Grafana](https://grafana.com/)
- [Grafana Agent](https://grafana.com/docs/grafana-cloud/agent/)
- [Logging Operator](https://kube-logging.dev)
- [Loki](https://grafana.com/oss/loki/)
- [OpenTelemery Operator](https://opentelemetry.io/docs/operator/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
- [Prometheus Operator](https://prometheus-operator.dev/)
- [Prometheus](https://prometheus.io/)
- [Tempo](https://grafana.com/oss/tempo/)

## OpenTelemetry Collector

The OpenTelemetry Collector is a vendor-agnostic, open-source telemetry collector that can be used to collect, process, and export telemetry data. It is a powerful tool that can be used to collect logs, metrics, and traces from a variety of sources and export them to a variety of destinations.

OpenTelemetry Collector implements the [OpenTelemetry protocol (OTLP)](https://opentelemetry.io/docs/specs/otlp/) which is a standard for transmitting telemetry data.

=== "otlp"

    ```mermaid
    graph LR
      App[Application]
      OtelCollector[Collector]
      Loki
      Prometheus
      Tempo

      App -- otlp --> OtelCollector

      OtelCollector -- traces --> Tempo
      OtelCollector -- logs --> Loki
      OtelCollector -- metrics --> Prometheus

      Tempo -- query --> Grafana
      Loki -- query --> Grafana
      Prometheus -- query --> Grafana
    ```

=== "traces only"

    ```mermaid
    graph LR
      App[Application]
      OtelCollector[Collector]
      LoggingOperator
      Loki
      Prometheus
      Tempo

      App -- traces --> OtelCollector
      App -- stdout/stderr --> LoggingOperator
      LoggingOperator -- forward --> Loki
      App -- scrape --> Prometheus
      OtelCollector -- traces --> Tempo

      Tempo -- query --> Grafana
      Loki -- query --> Grafana
      Prometheus -- query --> Grafana
    ```

### Endpoints

The OpenTelemetry Collector exposes the following endpoints:

- `http://opentelemetry-management-collector:4317` - OpenTelemetry Protocol (OTLP) endpoint for receiving traces, metrics, and logs from applications.
- `https://collector-internet.<tenant>.cloud.nais.io` - Internet exposed OTLP endpoint for receiving traces, metrics, and logs from applications running outside of nais.
