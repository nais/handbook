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
