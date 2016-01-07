Context
=======
When building pipelines using concourse, we investigated using the [pool
resource](https://github.com/concourse/pool-resource) in order to control flow
through jobs. This was an alternative to the use of the 
[semver resource](https://github.com/concourse/semver-resource).

These 2 resources are both workarounds to solve the problem of triggering jobs
when we haven't made changes to a resource. 

The problem is that the pool resource relies on write access to a github repo,
which means we must pass public keys that allow this access into the pipeline
and deployed concourse instance - we want to minimise the number of credentials
we pass, and the semver resource relies on AWS credentials that are already
passed.



Decision
========

We will not use the pool resource for flow between jobs - instead we will use
the semver resource

Status
======

Accepted

Consequences
============

This was an investigation into a different approach, so no consequences
