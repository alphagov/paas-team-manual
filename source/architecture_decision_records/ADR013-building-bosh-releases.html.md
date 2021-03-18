---
title: ADR013 - Building BOSH releases
---

# ADR013: Building BOSH releases

## Context

We use [Bosh](https://bosh.io/) to create and manage our cloudfoundry deployment on AWS.
To deploy software, Bosh needs certain binary dependencies available.
These are known as bosh [releases](https://bosh.io/docs/release.html).

Before this decision, we usually built and uploaded releases to Bosh as part of our [concourse](https://concourse-ci.org/) pipeline.
Occasionally, we would manually build a release, store it on GitHub, and point Bosh to it there.

### Building Bosh Releases

We investigated different approaches to creating bosh releases, in particular

* Multiple pipelines created dynamically using [branch manager](https://github.com/alphagov/paas-concourse-branch-manager)
* A single pipeline using [pullrequest-resource](https://github.com/jtarchie/pullrequest-resource)

The work on these spikes was recorded in
https://www.pivotaltracker.com/n/projects/1275640/stories/115142265
https://www.pivotaltracker.com/n/projects/1275640/stories/128937731

## Decision

We will use the [pullrequest-resource](https://github.com/jtarchie/pullrequest-resource) approach to build all our Bosh releases in a consistent way.

## Status

Accepted

## Consequences

We must gradually migrate all our Bosh release builds to their own build pipelines.
We will need separate jobs to build from master - this already has a proof of concept in the spike.
We may have to add additional config in projects we fork to allow us to create final builds.
