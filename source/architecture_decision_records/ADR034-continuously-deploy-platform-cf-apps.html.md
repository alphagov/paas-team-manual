---
title: ADR034 - Continuously deploy platform CF applications
---

# ADR034: Continuously deploy platform CF applications

## Context

As part of GOV.UK PaaS we have a number of applications that we consider to be
an essential part of the platform deployed as cloud foundry apps. These include:

* paas-admin
* paas-billing
* paas-accounts

Prior to July 2019 the versions of these applications were pinned in paas-cf,
and they were only deployed along with the whole platform. This had a couple of
negative consequences:

* Following a change to an app's source and a passing build an additional
  manual change to paas-cf was required to deploy it
* Deploying apps required waiting for unrelated slow bits of the pipeline to
  complete (e.g. terraform apply, bosh deploy, cf acceptance tests), despite
  the fact that a change to an app could not possibly affect or be affected by
  these steps

There were also some advantages of specifying the version of applications
explicitly:

* There's an record of which versions of the applications work with which
  versions of the platform.
* Merges to paas-cf require a signed merge commit to be deployed, so we can be
  explicit about the set of people who are allowed to deploy changes

## Decision

We will update the pipeline to:

* Require GPG signatures on git commits before deploying applications in staging and production
* Automatically deploy every build of the master branch of the applications to staging
* In staging: tag the application repo when a deployment passes its acceptance tests
* In production: automatically deploy any build which has been tagged by staging

## Status

Accepted

## Consequences

* Deployments to paas-admin, paas-billing and paas-accounts will take minutes instead of hours
* We will continue to enforce that all production code requires a signed commit to deploy
* We will no longer have a single record of which version of the applications
  were deployed with which version of the platform

