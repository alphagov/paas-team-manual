---
title: ADR031 - Separate PaaS services from the Platform core pipeline
---

# ADR031: Separate PaaS services from the Platform core pipeline


# Context

We have a single pipeline `create-cloudfoundry` which creates a Cloud Foundry
deployment, and also deploys additional services to the platform.

These services include:

- PaaS Accounts
- PaaS Admin
- PaaS Billing
- PaaS Metrics

Which are core components to our platform, but not to Cloud Foundry.

Currently these services are unnecessarily coupled in a couple of places:

- The `post-deploy` job
- The `custom-acceptance-tests` job

Unnecessarily coupling has resulted in flakey app tests blocking CVE
remediation from reaching production.

# Decision

Move, where possible, PaaS services into their own jobs (within the same
`create-cloudfoundry` pipeline) such that they do not impede progress of
deployment to the core platform.


# Status
Accepted


# Consequences

The pipeline will no longer be fully controlled by the `pipeline-lock` pool.

The individual jobs in the pipeline will be less mysterious.
