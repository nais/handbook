# Announcements

To let more people keep track of what's happening on the platform, we've created a log at [nais.io/log](https://nais.io/log/).
Each announcement is a Markdown file.
Remember to post a link to `#nais-announcements`.

Example announcement:

``` markdown
---
title: "An April Fools' joke"
date: 2020-04-01T12:00
author: AprilFools
tags: [github, action, cloud, build, gcp]
layout: log
---

Following today's successful migration of Nais deploy to GCP, we want to disable functionality related to legacy build systems.
There has been some instability around GitHub Actions and CircleCI, so we want to move away from those.
We have evaluated new systems and concluded that we will move all builds to Google Cloud Build.
We will therefore be disabling support for other build systems.
Starting today, Jenkins, Travis, CircleCI, GitHub Actions, and similar tools are deprecated and will trigger a warning in the build job.
Support will be disabled on Monday the 29th of June 2020.
```
