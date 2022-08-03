# What is NaaS (Nais As A Service)?

## Introduction
NaaS is a centralized system for governance of NAIS clusters and a uniform way of applying features.
Its purpose is remaining a clear separation between tenants and their configuration, whilst still remaining centralized control.

## An architecture overview
### The nais-io GCP organization
<span style="display:flex">
<img src="/assets/naas-nais-io-org.png" width="350" style="margin-right:20px"/>
<span>
We want a clear separation between the administration of the clusters and the clusters themselves. 
The `nais-io` GCP organization serves this purpose; this is where administrative users, configuration and control-plane components reside.
</span>
</span>
> [What is a GCP organization?](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy#organizations)


### Tenant GCP organization
Each tenant has its own separate GCP organization.
As with the nais-io GCP organization, we want a clear separation between administration and workloads.
![](/assets/naas-partner-org.png)

#### The nais-management GCP project
To achieve this, all tenant wide services (eg. deploy, tenant console, etc.) run in a separate GCP project called nais-management.
This GCP project is fully managed and owned by the NAIS team.

#### Tenant environment GCP projects
The tenant will have multiple clusters, typically dev and prod, and each of these clusters require a suite of NAIS components (eg. naiserator, monitoring, etc.).
To separate NAIS components and from tenant workloads, each cluster has a nais-system namespace, where all NAIS-related services reside.
All tenant workloads will run in separate team namespaces in this cluster.

> [ What is a GCP project?](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy#projects)


## Administration and authorization
### Cluster administrators
NAIS personnel has an `@nais.io` user, who initially has no permissions outside of the `nais-io` GCP organization.
There is an administration group in the `nais-io` GCP organization that is granted access to the respective tenant's GCP organization.
This groups is normally empty, but when there is a demand, NAIS operators can grant themselves just in time access by adding their user to this group, and thus access to the tenant.
![](/assets/naas-admin-groups.png)
> **Example:** The group `nav-k8s-admins@nais.io` is granted administrative rights in NAV tenant GCP organization.

### Cluster users
The tenant is responsible for populating their GCP organization with users.
This is typically done by synchronizing users from their IDP.
Additionally we recommend configuring an IDP, so the tenant remains in control of the authorization flow.
![](/assets/naas-user-admin.png)
> **Example:** Nav synchronize their users from Azure AD and configure Azure AD to be the IDP.

Each tenant has their own `console` where they can manage users, features and access for each of their teams.
When a user is allocated to a team, access to resources are granted according to what is configured by the tenant in their console.

## Control plane and cluster configuration
The NAIS control plane consist of two primary components, `Fasit` and `naisd`.
`Fasit` is the primary configuration database for all clusters.
It runs in the `nais-io` cluster in the `nais-io` GCP organization.
`Naisd` is a component that runs in each cluster and is responsible for applying and installing components.
When a configuration is ready to be applied to a cluster, `Fasit` publish a message to a pub/sub-topic specific to the relevant cluster.
`Naisd` picks up the message and applies the configuration.
When the configuration is applied, `naisd` sends a status message on a central status topic.
`Fasit` reads all statuses from all clusters and use this information to give a complete overview of the entire ecosystem.
![](/assets/naas-control-plane.png)

## Cluster features
All of the components that are available for deployment in a cluster are wrapped in helm-charts.
Each component has a github workflow that builds the helm-chart (and if applicable a docker image).
The workflow publish each of these artifacts to an artifact registry in the nais-io GCP organization (using workload identity).

The chart will normally contain sane defaults for the component, but can be overridden in Fasit on a per cluster basis.
The component definition in fasit also caters for dependencies between features.
> **Example:** naiserator depends on the nais-crds availability in the cluster in order to work.

## Naisdevice
Every cluster is a private cluster using only private IP-addresses with no direct exposure to the public.
In order to reach a cluster, a user is required to run `naisdevice`, which sets up a VPN tunnel to a `naisdevice gateway` in the relevant cluster.
![](/assets/naas-naisdevice.png)
Anyone who require access to the clusters will have to install `naisdevice` on their computer.
Based on the domain provided in the user's authorization token, the authentication server will grant access to the relevant clusters.

## Exposing applications
<span style="display:flex">
<img src="/assets/naas-loadbalancing.png" width="350" style="margin-right:20px"/>
<span>
Each cluster has a single load balancer and a single set of ingress controllers.
Access to each domain on this load balancer is goverened by cloud armor policies.
The tenant can restrict which clients can access a domain by defining cloud armor policies. <br/>
> **Example:** app-a.x.com can be exposed globally, whilst app-b.y.com is restricted to a predefined set of source IPs.

The load balancer will terminate SSL using certificates provided by the tenant.
</span>
</span>
