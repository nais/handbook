# Announcements

For å la flere kunne få med seg hva som skjer på plattformen har vi lagd en logg på [nais.io/log](https://nais.io/log/).
For å unngå dobbeltarbeid ved at man må publisere på nettsiden, og i Slack har, har vi lagd en liten [bot](https://github.com/nais/announcements/) som henter siste innlegg fra en RSS-kilde, og publiserer nye innlegg i Slack.
Derfor trenger man kun lage nye annonseringer i [nais/nais.github.io](https://github.com/nais/nais.github.io/tree/main/src/routes/(pages)/log/posts)-repoet.

Hver annonseringer er en Markdown-fil med støtte for Slack-emojis *i* content-delen, ikke i frontmatter-delen.

Eksempel på en annonsering:

``` markdown
---
title: "En første aprilspøk"
date: 2020-04-01T12:00
author: Aprilspøk
tags: [github, action, cloud, build, gcp]
layout: log
---

Etter dagens suksess med flytting av NAIS deploy til GCP ønsker vi å skru av funksjonalitet knyttet til legacy byggesystemer. Det har vært en del ustabilitet rundt GitHub Actions og CircleCI så de ønsker vi gå bort fra. Vi har testet ut nye systemer og landet på at vi skal flytte alle bygg ut på Google Cloud Build. Vi kommer derfor til å skru av støtte for andre byggesystemer. Fra i dag av blir dermed Jenkins, Travis, CircleCI, GitHub Actions, m.fl. deprecated og vil trigge en warning i byggejobben. Vi skrur av støtte mandag den 29. juni 2020.
:trolll:
```

Når en ny annonsering blir pushet til repoet, så vil Github Action bygge og publisere Github pages, og sende et kall til announcementsbotten.
