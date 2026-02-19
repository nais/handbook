# Nais alerts

!!! info
    Status: Draft

When developing and operating Nais features, we often need to add alerts so we're able to respond quickly if something unexpected or undesirable should happen.

This document describes how we currently do alerting in Nais.

## Alerting in Nais

We use Slack as the delivery mechanism for alerts, similar to what we provide for the teams.

The primary channel for alerts is #naas-alerts. This channel is monitored by the whole team during working hours, and by Naisvakt 24/7.

## Levels of criticality

With the exception of the `info` level, all alerts entering the channel are handled by Naisvakt.
Handling an alert means acknowledging it, investigating it or ensuring that the right people are notified.

If the alert does not lead to or require action, and is not `info`, the alert must be tuned. Notify the people who created it.

It's important that we have control over and continuously work to tune alerts to avoid false positives and unnecessary work - leading to alert fatigue.

In the `PrometheusRules` resource you use `spec.groups[].rules[].labels.severity` to set the level, and `spec.groups[].rules[].labels.ping: nais-vakt` if the alarm needs to notify the Naisvakt.

### Critical w/Naisvakt tag

Must be handled immediately, and will wake Naisvakt (and probably anyone in close proximity) at night. Ensure that the alert is critical enough to warrant this.
Examples: `Deploy canary failing`, `Connectivity tests failing`.

### Critical

Should be handled immediately during waking hours (not necessary to wake Naisvakt at night). Use for errors that are critical for the service itself but not for the end users.
Examples: `Backup failing`

### Warning

Should be handled at next available opportunity.
Examples: `Disk usage above 80%`, `Certificate expiring in 14 days`

### Info

Informational alerts that do not require immediate action/handling, but are important to know about.
Examples: `etcd latency alert`, we can't do anything about it, but it's good to know.

## Alert Rules

Alert rules are defined in the `PrometheusRule` resource in the `/templates` directory of the feature repository.

``` { .yaml .annotate }
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: "my-feature"
spec:
  groups:
  - name: "./my.feature.rules"
    rules:
    - alert: "MyFeatureErrorRateHigh" # (1)
      expr: |
        (
            sum(rate(nginx_ingress_controller_requests{service="my-feature", status=~"5.."}[5m])) by (service)
        )
        /
        (
            sum(rate(nginx_ingress_controller_requests{service="my-feature"}[5m])) by (service)
        ) > 0.05
      for: 10m # (2)
      labels:
        severity: "warning"
        namespace: "nais-system"
      annotations:
        description: |
            The error rate for my-feature is above 5% for http requests.
        consequence: |
            Descibe how this affects the users of the service.
        action: |
            Check recent changes to the feature https://github.com/nais/helm-charts/commits/main/features/my-feature
            Check the for any errors `kubectl logs -n nais-system svc/{{`{{`}} $labels.service {{`}}`}}`
        dashboard_url: | # (3)
            "https://monitoring.nais.io/d/abc123/my-feature?var-tenant={{ $.Values.fasit.tenant.name }}&var-env={{ $.Values.fasit.env.name }}"
        runbook_url: |
            "https://github.com/nais/vakt/blob/main/runbooks/my-feature.md"
```

1. Follow the naming convention `FeatureNameAlertDescription` for the alert name.
2. The alert activation time should not be more than 10 minutes for critical alerts.
3. You can use templating to create a dashboard URL that links to the relevant dashboard with the correct variables set for the feature.

## More examples

### Info level alerts

For informational alerts that should go to `#nais-alerts-info`, add these labels:

``` { .yaml .annotate }
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: "nais-info-alerts"
spec:
  groups:
  - name: "./nais.info.rules"
    rules:
    - alert: "EtcdHighLatency"
      expr: |
        histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket[5m])) > 0.5
      for: 5m
      labels:
        severity: "info" # (1)
        namespace: "nais-system"
        alert_type: "custom" # (2)
        channel: "nais-alerts-info" # (3)
      annotations:
        summary: "etcd disk latency is high"
        description: "etcd WAL fsync latency is {{ $value }}s (99th percentile)"
        action: "Monitor etcd performance dashboard for trends"
```

1. Use `info` severity for informational alerts
2. Set `alert_type: custom` to route to info channel
3. Specify the target channel

### Critical alerts with Naisvakt ping

For alerts that should wake Naisvakt, add the `ping: nais-vakt` label:

``` { .yaml .annotate }
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: "nais-critical-alerts"
spec:
  groups:
  - name: "./nais.critical.rules"
    rules:
    - alert: "NaisDeployCanaryFailing"
      expr: |
        (
          sum(rate(nais_deployment_canary_failures_total[10m])) by (cluster, tenant)
          /
          sum(rate(nais_deployment_canary_total[10m])) by (cluster, tenant)
        ) > 0.5
      for: 2m # (1)
      labels:
        severity: "critical"
        ping: "nais-vakt" # (2)
        namespace: "nais-system"
      annotations:
        summary: "NAIS deployment canary failure rate is high"
        description: "{{ $value | humanizePercentage }} of canary deployments are failing"
        consequence: "Teams cannot deploy applications successfully"
        action: |
          Check canary deployment logs: `kubectl logs -n nais-system -l app=deploy-canary`
        runbook_url: "https://github.com/nais/vakt/blob/main/runbooks/deployment-canary.md"
```

1. Short activation time for critical issues
2. Add `ping: nais-vakt` to notify Naisvakt immediately

### Alerts with multiple conditions

You can combine multiple metrics in alert expressions:

``` { .yaml .annotate }
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: "nais-complex-alerts"
spec:
  groups:
  - name: "./nais.complex.rules"
    rules:
    - alert: "NaisAPIServerDegraded"
      expr: |
        (
          sum(rate(apiserver_request_duration_seconds_count{code!~"2.."}[5m])) by (cluster)
          /
          sum(rate(apiserver_request_duration_seconds_count[5m])) by (cluster)
        ) > 0.05
        and # (1)
        histogram_quantile(0.99,
          sum(rate(apiserver_request_duration_seconds_bucket[5m])) by (le, cluster)
        ) > 2
      for: 5m
      labels:
        severity: "critical"
        ping: "nais-vakt"
        namespace: "nais-system"
      annotations:
        summary: "Kubernetes API server is degraded"
        description: "API server has high error rate and latency"
        consequence: "kubectl commands and deployments will be slow or fail"
        action: "Check API server logs and etcd health"
```

1. Use `and` to combine conditions - both error rate AND latency must be high
