Installing nais
===============

Installing nais in your own cluster is a complicated process, where few or no steps are documented.
This document is an attempt to give a short introduction and describe a few of the initial steps to get you started.

Keep in mind that nais is a big ball of interconnected services and infrastructure, and as of now there isn't any clear guide for how to install and operate it on your own. 

Most of the required knowledge for installing nais in a cluster is tribal knowledge in the nais team, but we're a friendly bunch, so you can always ask us for more information.


## The absolute minimum

The bare minimum needed in a cluster would be the CRDs and Naiserator, but that alone would probably only give you a very rudimentary "nais cluster".
CRDs are installed with the chart in the [liberator repo](https://github.com/nais/liberator/tree/main/charts).
Naiserator is probably best to install using the chart in the [naiserator repo](https://github.com/nais/naiserator/tree/master/charts/naiserator?rgh-link-date=2023-09-12T11%3A16%3A47Z).

There are quite a few values to adjust in those charts, with very little documentation on what each does.
We don't have any better option than trying them out or tracing their use in the code to understand them more.


## Deploying applications

The next step you might want to install is the [deploy system](https://github.com/nais/deploy/tree/master/charts), which consists of a hookd instance available from anywhere you would like to deploy from (Github, local machine, etc), and a deployd instance running in the clusters you wish to deploy to.
Deployd in the cluster needs to be able to reach hookd (the cluster doesn't need to be directly on the internet, as long as deployd can call out to hookd).
Deploying is done using the deploy cli (or the deploy github actions), which takes some inputs and sends them to hookd, which forwards to deployd in the selected cluster, which applies the manifests in the cluster.

See the [user documentation](https://doc.nais.io) for details about deploying applications.


## Integrations

A complete nais experience requires that all the integrated services are available, but most of these are not documented.
Some of them also require various infrastructure to be in place and work in a certain way, which is also not documented.

Here are some components you might want to look at, although some of these may contain NAV specific code that wouldn't work outside our clusters.

Documentation on each is also limited:

* [CNRM](https://cloud.google.com/config-connector/docs/overview) for integration with several GCP features
* [Kafkarator](https://github.com/nais/kafkarator), [Aivenator](https://github.com/nais/aivenator) and [Mutilator](https://github.com/nais/mutilator) for integration with a few Aiven services (Kafka, OpenSearch, InfluxDB and Redis)
* [BQrator](https://github.com/nais/bqrator) for BigQuery integration
* [Azurerator](https://github.com/nais/azurerator) for automated registration and lifecycle management of Azure Active Directory applications.
* [Digdirator](https://github.com/nais/digdirator) for automated registration and lifecycle management of ID-porten and Maskinporten clients (integrations) with feature Maskinporten Scopes (APIS).
* Console [frontend](https://github.com/nais/console-frontend) and [backend](https://github.com/nais/console-backend) which contains a dashboard and overview for teams.
* Teams [frontend](https://github.com/nais/teams-frontend) and [backend](https://github.com/nais/teams-backend) which allows management of teams and namespaces.

This is a very quick, high-level introduction, but for now it's all we have 😅
