---
title: ADR026 - DNS layout for UK hosting
---

# ADR026: DNS layout for UK hosting

## Context

We are moving AWS hosting from Ireland to London. This ADR contains the decisions of the DNS names we will use for apps and system components that will be hosted in London.

## Decision

We will use the following domain patterns for the London hosting:

* `(system_component).london.(system_domain)`
* `(app_name).london.(app_domain)`

Where:

* (system_component) -- api, uaa, doppler, ssh, etc.
* (system_domain) -- _cloud.service.gov.uk_, _staging.cloudpipeline.digital_
* (app_domain) -- _cloudapps.digital_, _staging.cloudpipelineapps.digital_

The reasons are:

* We should re-use the (system_component) first part to minimise the changes to the Cloud Foundry manifests.
* We should re-use the (system_domain) and (app_domain) last part, because these domains are assigned to GOV.UK PaaS as the public interface.
* The domain part `london` is preferrable to `uk`, because AWS may provide multiple-region hosting within the UK in the future.

The domain structure for the dev and CI environments won't change. For the dev environments we will create a flag to choose where to create the deployment.

### Examples

#### Production

|Ireland|London|
|----|------|
|# _api.cloud.service.gov.uk_|_api.london.cloud.service.gov.uk_|
|# _sample-app.cloudapps.digital_|_sample-app.london.cloudapps.digital_|

#### Staging

|Ireland|London|
|----|------|
|# _api.staging.cloudpipeline.digital_|_api.london.staging.cloudpipeline.digital_|
|# _sample-app.staging.cloudpipelineapps.digital_|_sample-app.london.staging.cloudpipelineapps.digital_|

## Status

Accepted

## Consequences

New tenants will be encouraged to use London hosting. Plans need to be derived to notify exiting tenants to move their apps and services to London.
