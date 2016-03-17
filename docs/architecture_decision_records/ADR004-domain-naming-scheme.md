Context
=======
As part of our deployment we have a pipeline, where changes that are made can move from a development environment through to production illustrated thusly:

![pipeline image](images/pipeline.jpg)

There are a number of externally available endpoints that are accessed to manage and view information about the platform, as well as issue commands via the Cloud Foundry API. In addition to this, a URL also needs to be available to access Apps hosted on the platform. These need to be accessed via some sort of sensible URL.

### Naming considerations
A number of aspects were considered as part of the naming process.

* Clear sense of purpose
* Clear distinction between Production and other Environments
* No overly technical names (e.g. hosting/paas/scalable-elastic-public-government-hosting)
* Prevent possibility of domains suggesting 'live' service


Decision
========
For our _not_ production environments we will be using the following domains:

* [environment name].cloudpipeline.digital
* [app name].[environment name].cloudpipelineapps.digital

For our production environment we will be using the following domains:

* cloud.service.gov.uk
* [app name].cloudapps.digital

It is important to note that live services will 'Bring Your Own' domain, apps available at cloudapps.digital are non production applications.

Status
======

Accepted

Consequences
============
Certificates etc. had to be purchased, domains registered, and our automated deployments configured to allow us to specify the domains for each stage of the pipeline.