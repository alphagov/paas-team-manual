---
title: ADR030 - Single staging environment in London
---

# ADR030: Single staging environment in London


# Context

We run a Cloud Foundry platform in London (AWS eu-west-2 region) to allow GOV.UK PaaS tenants to host their applications and services in the UK. This is driven by the hosting needs of some of the existing GOV.UK PaaS tenants.

In addition we need to manage the use of Amazon Web Service resources to reduce our running costs. Having staging environments in both Ireland and the UK increases the total infrastructural costs, which is not justified by the benefit of the additional tested cases.

The London region is newer than the Ireland and currently offers a subset of services compared to the Ireland region. Hence, having the staging environment in London should allow us to capture the cases that may cause failure due to the unavailability of services.

Therefore, the risks of running a single staging environment are offset by the cost savings and simplification of deployment pipelines.

# Decision

We will remove the Ireland (eu-west-1) staging environment resulting in a single staging environment in AWS London (eu-west-2).


# Status
Accepted


# Consequences
We will have one staging environment for testing both London and Ireland production environment. This ADR does not affect the setup of the dev or production environment. 



