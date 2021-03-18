---
title: ADR004 - Domain naming scheme
---

# ADR004: Domain naming scheme

## Context

As part of our deployment we have a pipeline, where changes that are made can move from a development environment through to production illustrated thusly:

![pipeline image](../images/pipeline.jpg)

There are a number of externally available endpoints that are accessed to manage and view information about the platform, as well as issue commands via the Cloud Foundry API. In addition to this, a URL also needs to be available to access Apps hosted on the platform. These need to be accessed via some sort of sensible URL.

The reason for splitting system domains from app domains was to prevent applications from stealing traffic to CF components (for example, api.<domain>) or masquerading as official things of the platform (for example, signup.<domain>).

### Naming considerations
A number of aspects were considered as part of the naming process.

* Clear sense of purpose
* Clear distinction between Production and other Environments
* No overly technical names (for example, hosting/paas/scalable-elastic-public-government-hosting)
* Prevent possibility of domains suggesting 'live' service, for example if we allowed [app name].paas.gov.uk it could appear as thought they were live services.


## Decision

For _non_ production environments we will be using the following domains:

* [environment name].cloudpipeline.digital
* [app name].[environment name].cloudpipelineapps.digital

For our production environment we will be using the following domains:

* cloud.service.gov.uk
* [app name].cloudapps.digital

It is important to note that live services will 'Bring Your Own' domain, apps available at cloudapps.digital are not live 'production' applications.

## Domain Overview

### Development Domains
Purpose | URL |
------------ | -------------
# Deployer Concourse | deployer.foo.dev.cloudpipeline.digital
# Cloud Foundry API | api.foo.dev.cloudpipeline.digital
# Cloud Foundry User Account and Authentication | uaa.foo.dev.cloudpipeline.digital
# Applications | bar.foo.dev.cloudpipelineapps.digital

### Continuous Integration (CI) Domains
Purpose | URL |
------------ | -------------
# Deployer Concourse | deployer.master.ci.cloudpipeline.digital
# Cloud Foundry API | api.master.ci.cloudpipeline.digital
# Cloud Foundry User Account and Authentication | uaa.master.ci.cloudpipeline.digital
# Applications | bar.master.ci.cloudpipelineapps.digital

### Staging Domains
Purpose | URL |
------------ | -------------
# Deployer Concourse | deployer.london.staging.cloudpipeline.digital
# Cloud Foundry API | api.london.staging.cloudpipeline.digital
# Cloud Foundry User Account and Authentication | uaa.london.staging.cloudpipeline.digital
# Applications | bar.london.staging.cloudpipelineapps.digital

### Production Domains
Purpose | URL |
------------ | -------------
# Deployer Concourse | deployer.cloud.service.gov.uk
# Cloud Foundry API | api.cloud.service.gov.uk
# Cloud Foundry User Account and Authentication | uaa.cloud.service.gov.uk
# Applications | bar.cloudapps.digital

## Status

Accepted

## Consequences

Certificates etc. had to be purchased, domains registered, and our automated deployments configured to allow us to specify the domains for each stage of the pipeline.
