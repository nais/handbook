Procedure to follow when upgrading Kafka
========================================

Kafka is an important service in NAV, and problems that affect Kafka affects many teams.
For that reason we have decided to describe the procedure for upgrading Kafka in detail, to have a playlist to refer to.

The upgrade should be properly announced in #nais-announcements, with a copy to relevant channels, either by link or by copied text.
For NAV, #kafka is a relevant channel.
For any other tenants that use Kafka, the tenant will typically have one support channel which should get a copy of the announcement.

## 1. Upgrade in dev-nais-dev first

The dev-nais tenant is our testing tenant, and allows testing platform changes without affecting developer teams.
By upgrading in dev-nais-dev first, we can check that kafka-canary continues to work, and optionally run additional tests to verify that everything works.

It is considered enough to check that the kafka-canary continues to work and handles the upgrade process without major issues.

Once everything is confirmed to work in dev-nais-dev, rolling out to ci-nais should be next.

Upgrading is done by changing `kafka_version` in the `naas.tf` file for [dev-nais tenant, dev environment](https://github.com/nais/nais-terraform-modules/blob/main/tenants/dev-nais/naas.tf).


## 2. Upgrade the ci-nais tenant

The ci-nais tenant is our CI tenant, and should emulate a production tenant as close as possible.
Upgrading in ci-nais will allow us to check that the upgrade process works in a tenant that is more similar to production.

Once everything is confirmed to work in ci-nais, rolling out to other tenants/clusters should be started as soon as possible.

Upgrading is done by changing `kafka_version` in the `naas.tf` file for [ci-nais tenant, ci environment](https://github.com/nais/nais-terraform-modules/blob/main/tenants/dev-nais/naas.tf).


## 3. Upgrade development environments

Currently, NAV is the only tenant that uses Kafka, but we have one project that fall in this category:

- nav-dev

The upgrade should be announced clearly, with a request for teams to check their applications during the upgrade and after.

After the upgrade, teams will have 1 week to report any issues to the nais-team, who can decide if the upgrade in production should be held back or go ahead.

<!-- Upgrading is done by changing `kafka_version` in the `naas.tf` file for nav tenant, dev environment. -->
<!-- TODO: https://github.com/nais/nais-terraform-modules/blob/main/tenants/nav/naas.tf -->


## 4. Upgrade remaining environments

When announcing the upgrade, request that teams that haven't checked their dev environment do so now, and allow for a few hours before starting the upgrade.
Make sure to dedicate time to watch the upgrade progress, and follow up on any reports of problems.

Make sure to inform the users when the upgrade has completed.

Upgrading is done by changing the default value for the `kafka_version` variable in these files:

* [modules/aiven/variables.tf](https://github.com/nais/nais-terraform-modules/blob/main/modules/aiven/variables.tf)
* [modules/legacy/variables.tf](https://github.com/nais/nais-terraform-modules/blob/main/modules/legacy/variables.tf)
* [modules/tenant/variables.tf](https://github.com/nais/nais-terraform-modules/blob/main/modules/tenant/variables.tf)
