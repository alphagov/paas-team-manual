Context
=======

We wanted to open up access to tenant applications in our production environment. 

As part of an earlier story, Pingdom checks were set up for a healthcheck application in CI, Staging, and Production. At this stage applications were not accessible from non-office IP addresses.

The problem we faced was a need to test the code introduced to make our production environment accessible to the world. Initially, we suggested applying the same change to our staging environment. However, this approach means all applications in staging will be accessible from anywhere.

If we use Pingdom to assert an application is accessible from the outside world then we need to remove the explicit rules (security groups) allowing Pingdom traffic. This means our CI environment would not be accessible to Pingdom probes.

* [#116104189 - set up Pingdom](https://www.pivotaltracker.com/story/show/116104189)
* [#115347323 - allow public access to tenant applications](https://www.pivotaltracker.com/story/show/115347323)

Decision
========

It was decided we would make the staging environment accessible to the outside world as well as production, and define future work for removing the CI Pingdom check and security groups allowing Pingdom probes, and setting up tests from the pipeline which use the Pingdom API.

Given that the advantages relate to the availability of our production environment, they outweigh not having an automated healthcheck on an application in our CI environment. However, we remain open to hearing solutions to providing healthchecks for CI in future.

Status
======

Proposed

Consequences
============

A story is now required to remove the Pingdom health check for our CI environment, and the security groups allowing Pingdom probes.

### Positive
* We are now able to test accessibility using the staging environment
* We are now able to use Pingdom to assert not just application health, but routing as well.
* We have maintained consistency between staging and production

### Negative
* Any applications in our staging environment need to be considered for whether they are suitable to be public.
* We would no longer have healthchecks via Pingdom for our CI environment.
