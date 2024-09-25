---
title: Decommissioning Central PaaS infrastructure
---

# Decommissioning Central PaaS infrastructure

## Introduction

This document is a rough guide on what we'll need to do to fully shut down PaaS after the individual PaaS environments have been shut down. This is only a guide, there are likely steps missing and the process may need to be adapted as you go.

## Prerequisites

The following steps should only be carried out after all tenant apps have been migrated off and all of the individual PaaS environments have been decommissioned. The PaaS environments are:

* Production London (prod-lon)
* Production Ireland (prod)
* Staging
* Dev01-Dev05

## Archiving

Archive whatever information needs to be kept before proceeding. We are still investigating what needs to be archived as of 24/09/2024, and we should confirm what we need to keep before proceeding.

## Account Wide Terraform

Destroy all terraform-managed infrastructure in [paas-aws-account-wide-terraform](https://github.com/alphagov/paas-aws-account-wide-terraform).

We will need to create a `destroy` Makefile target for this, as one does not currently exist.

This should be applied across all AWS accounts.

## Services

The following external services will need to be decommissioned after all the PaaS environments have been shut down. This will include deleting resources and closing the accounts, but the steps will vary from service to service.

* AWS (dev, staging & production accounts) - ensure any remaining savings plans are transferred to another org within GDS
* Pivotal tracker
* Logit
* Pingdom
* Pagerduty
* Aiven
* Cronitor
* Statuspage
* Zendesk
* Trello

## Repositories

Archive PaaS repositories on GitHub
