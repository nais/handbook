# GCP

GCP is the primary cloud provider for NAV/NAIS.

## NAIS on GCP

NAIS is the first version of NAIS on GCP.

| Repo | Description |
|------|-------------|
| [nais/gcp](https://github.com/nais/gcp) | Terraform infrastructure for network and |
| [nais/nais-platform-apps](https://github.com/nais/nais-platform-apps) | Helm Charts |

### Overview

```mermaid
flowchart
    gke-to-checkpoint<-->nais-dev
    gke-to-checkpoint<-->nais-ci
    gke-to-checkpoint<-->nais-prod

    on-prem<-->gke-to-checkpoint

    nais-dev-->aiven
    nais-prod-->aiven

    subgraph on-prem
      legacy-->oracle
    end

    subgraph gcp[Google Cloud]
      subgraph aiven
        kafka
      end

      subgraph gke-to-checkpoint
        checkpoint[VPN]
      end

      subgraph nais-labs
        gke-labs[GKE]
      end

      subgraph nais-ci
        gke-ci[GKE]
      end

      subgraph nais-dev
        gke-dev[GKE]
      end

      subgraph nais-prod
        gke-prod[GKE]
      end
    end
```

| Environment | Description |
|-------------|-------------|
| nais-ci | NAIS team CI environment |
| nais-dev | NAIS Application dev and test environment |
| nais-prod | NAIS Application production environment |
| nais-labs | NAIS Application playground environment |

## NAIS v2 (NaaS)

NAIS v2 is the second version of NAIS on GCP. For more information, see the [NaaS documentation](https://naas.nais.io/).