---
title: ADR029 - Aiven project structure
---

# ADR029: Aiven project structure

## Context

Aiven provides hosted Elasticsearch for the Elasticsearch backing service.

The PaaS has several environments which will need to use Aiven. These
environments should be isolated from each other so that changes made in testing
and development environments do do not affect production users.

Aiven provide a "Project" abstraction where a user can be a member of several
projects. API tokens are user specific. By creating one user per project it's
possible to scope API tokens to a project.

## Decision

We'll use separate projects for separate environments, initially using the
following Aiven projects:

* ci-testing (for the CI environment for the elasticsearch broker itself)
* paas-cf-dev
* paas-cf-staging
* paas-cf-prod

For staging and prod we will use separate API tokens within the same project to
separate credentials between the London and Ireland regions.

We will have the following per-project users to hold API tokens:

the-multi-cloud-paas-team+aiven-ci@digital.cabinet-office.gov.uk
the-multi-cloud-paas-team+aiven-dev@digital.cabinet-office.gov.uk
the-multi-cloud-paas-team+aiven-staging@digital.cabinet-office.gov.uk
the-multi-cloud-paas-team+aiven-prod@digital.cabinet-office.gov.uk

The credentials for the ci and dev users will be stored in the
`paas-credentials` passwordstore. staging and prod will be stored in
`paas-credentials-high`.

Members of the PaaS team will each have their own user which will have access
all of the projects for management purposes.

## Status

Accepted

## Consequences

Members of the PaaS team will need their own Aiven accounts.

The Aiven credentials of the four service users will be managed in the PaaS
team's passwordstores.

We will be able to interact with elasticsearch on a given environment without
risk of affecting other environments.

