---
title: ADR033 - Redirect HTTP for applications
---

# ADR033: Redirect HTTP for applications

## Context

In [ADR032](/architecture_decision_records/ADR032-ssl-only-for-applications-and-cf-endpoints) we decided that
we would only support https for applications on the PaaS, and that we would
drop plain http connections (port 80).

Since then, we've observed this causing confusion for users on numerous
occasions where they think their app isn't working after being pushed.

The situation is improved with the inclusion of the `cloudapps.digital` domain
in the [HSTS preload](https://hstspreload.org/?domain=cloudapps.digital) list,
but this only helps users with recent versions of modern browsers.

As a result of the continued confusion for users we should revisit the decision
from ADR443.


There are a number of things that could be done to address this:

### Update the CF CLI to include the scheme

Currently, the CF CLI outputs the fully-qualified hostname of the app after
pushing, but doesn't include the scheme. This has caused confusion for users
when this is copy/pasted into browsers, and then times out.

Getting the CLI to include the scheme here will help with the specific case of
users getting confused immediately after pushing an app.

It's unclear how much work this involves, as currently information about
whether a route is http or https doesn't appear to be modeled in CloudFoundry
anywhere.

If this involves changes to the CLI, there's no guarantee that users will
upgrade their CLI.

Additionally, there is some debate about how effective this change would be. It
will probably fix some cases, but won't cover everything.

### Redirect http to https

Add an endpoint that listens to all http requests on cloudapps.digital and
redirects them to the corresponding https URL.

There's a risk with this that a service could link to the http version of a
page by mistake and not notice due to the redirect. We can mitigate this be
having the redirect strip the path and query when redirecting so that it always
redirects to the base URL.

There's another risk that a misconfiguration could allow non-encrypted traffic
through to applications. This would need to be mitigated by having acceptance
tests to cover this.

## Decision

We will redirect http traffic to the corresponding root https endpoint.

We will continue to maintain HSTS preload lists for our production domains.

## Status

Accepted

## Consequences

We must configure and maintain an endpoint on the routers that accepts http
connections and redirects to the corresponding base https endpoint.
