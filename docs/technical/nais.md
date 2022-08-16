# What is NAIS?

_Kubernetes is not just Kubernetes. How did we set it up, and what does NAIS do (nais-yaml, GitHub actions, workflows, etc.)?_

Kubernetes is a Swiss army knife of tools, and each of these tools comes with its own set of instructions.
NAIS is there to help developers utilize these tools without having to read (all) the manual(s).
![](../assets/nais_army_knife.png)

## nais.yaml

Each of the many components that make up Kubernetes is configured via resource definitions.
What we've done in NAIS, is to select what we consider to be the most relevant components and condense their configuration in to a common yaml-file: [nais.yaml](https://doc.nais.io/nais-application/example/).

## Deployment

Through a single yaml-file, the users of the platform should be able to configure and set up everything their application needs. (see [deploy](https://doc.nais.io/deployment/) for more info)

## Observability

Once an application is running on the platform, the developer of that application should be equipped with everything they need to care for their application.
The primary tools for this is [logs](https://doc.nais.io/observability/logs/), [metrics](https://doc.nais.io/observability/metrics/) and [alerts](https://doc.nais.io/observability/alerts/).

## Operators

Even though Kubernetes comes with a lot of features out of the box, there are capabilities we want to add on top, such as databases, token authorization or kafka.
We want to give our users a uniform way of expressing their application's needs, so all additional functionality is added to nais.yaml, but there are different operators in the clusters that handle different parts of the manifest.
For most things concerning default kubernetes resources, [naiserator](https://github.com/nais/naiserator) will handle the business, but most other features have their own dedicated operator.

A "brief history" of NAIS and the current status quo is available on the fron page of our [documentation](https://doc.nais.io).
