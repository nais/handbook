# Aiven services and Kafka

Aiven is a third party service provider that nais uses for some of the features we provide.
If the tenant wishes to use some of those features, Aiven needs to be enabled for the tenant.
The tenant does not need to have any interaction with Aiven directly, but the NAIS team will need to set up the
necessary resources.

Aiven provides these services:

- Kafka (one per tenant environment)
- OpenSearch (Created on-demand for each application)
- Redis (Created on-demand for each application)

This is an optional feature that is not enabled by default.

## For Tenant

### Requirements and Setup

No preparation is required from the tenant.

### Usage by Applications

Applications that wishes to use Kafka must configure the application:

```yaml
spec:
  kafka:
    pool: <tenant>-<environment>
```

Relevant documentation for applications:

- [Kafka](https://docs.nais.io/persistence/kafka/)
- [OpenSearch](https://docs.nais.io/persistence/opensearch/)
- [Redis](https://docs.nais.io/persistence/redis/)


## For NAIS

- Enable Aiven for the tenant in nais-terraform-modules
- If the tenant wishes to use Kafka, enable Kafka in nais-terraform-modules

- After terraform has created the necessary Aiven resources, enable relevant features in Fasit 
  (including required dependencies):

    - `aiven-operator`
    - `mutilator`
    - `aivenator`

- If Kafka is enabled, also enable these features:

    - `kafka-canary`
        - In management environment
    - `kafkarator`
    - `aiven-alerts`
    - `kafka-canary-alert`
    - `kafka-lag-exporter`
