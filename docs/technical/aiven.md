# Aiven

Aiven is a cloud service that provides a fully-managed, high-performance, and secure cloud database.

The primary use case for Aiven is to provide a managed Kafka cluster for NAIS applications. Read more in the [NAIS documentation](https://docs.nais.io/persistence/kafka/).

## Project Overview

```mermaid
flowchart TB
    subgraph aiven
      cluster1-->account
      cluster2-->account
      cluster3-->account

      cluster2-->cluster1
      cluster3-->cluster2
    end

    subgraph gcp
      b1-->b2
    end
```
